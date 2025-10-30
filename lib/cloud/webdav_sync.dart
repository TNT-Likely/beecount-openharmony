import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../data/db.dart';
import '../data/repository.dart';
import '../utils/logger.dart';
import 'auth.dart';
import 'cloud_service_config.dart';
import 'sync.dart';

/// WebDAV 同步服务
/// 使用 HTTP Basic Authentication 访问 WebDAV 服务器
/// 文件路径：{webdavRemotePath}/users/{username}/ledger_{ledgerId}.json
class WebdavSyncService implements SyncService {
  final CloudServiceConfig config;
  final BeeDatabase db;
  final BeeRepository repo;
  final AuthService auth;

  final Map<int, SyncStatus> _statusCache = {};
  final Map<int, _RecentUpload> _recentUpload = {};
  final Map<int, DateTime> _recentLocalChangeAt = {};

  WebdavSyncService({
    required this.config,
    required this.db,
    required this.repo,
    required this.auth,
  });

  /// 构建 WebDAV 文件路径
  /// 使用简化路径：{basePath}/ledger_{ledgerId}.json
  /// 不创建用户子目录，避免某些 WebDAV 服务器不支持自动创建多级目录
  String _objectPath(String username, int ledgerId) {
    final basePath = config.webdavRemotePath ?? '/';
    final normalizedPath = basePath.endsWith('/') ? basePath : '$basePath/';
    return '${normalizedPath}ledger_$ledgerId.json';
  }

  /// 构建完整的 WebDAV URL
  Uri _buildUrl(String path) {
    final baseUrl = config.webdavUrl!;
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final finalUrl = '$normalizedBase$normalizedPath';
    logI('webdavSync', '构建URL: baseUrl=$baseUrl, path=$path, finalUrl=$finalUrl');
    return Uri.parse(finalUrl);
  }

  /// 获取 Basic Authentication 头
  Map<String, String> _getAuthHeaders() {
    final credentials = base64Encode(
      utf8.encode('${config.webdavUsername}:${config.webdavPassword}'),
    );
    return {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  /// 计算内容指纹
  String _fingerprint(String content) {
    final bytes = utf8.encode(content);
    return sha256.convert(bytes).toString();
  }

  /// 从 payload 计算内容指纹（规范化后）
  String _contentFingerprintFromMap(Map<String, dynamic> payload) {
    final items = (payload['items'] as List).cast<Map<String, dynamic>>();
    final canon = items
        .map((it) => {
              'happenedAt': it['happenedAt'] as String? ?? '',
              'type': it['type'] as String? ?? '',
              'amount': (it['amount'] as num?)?.toString() ?? '0',
              'categoryName': it['categoryName'] as String? ?? '',
              'categoryKind': it['categoryKind'] as String? ?? '',
              'note': it['note'] as String? ?? '',
            })
        .toList();
    final normalized = jsonEncode({'items': canon});
    return _fingerprint(normalized);
  }

  @override
  Future<void> uploadCurrentLedger({required int ledgerId}) async {
    final user = await auth.currentUser();
    if (user == null) {
      throw Exception('Not logged in');
    }

    logI('webdavSync', '开始上传账本 $ledgerId');

    // 导出数据
    final jsonStr = await exportTransactionsJson(db, ledgerId);
    final url = _buildUrl(_objectPath(user.id, ledgerId));
    final bodyBytes = utf8.encode(jsonStr);
    final fileSizeKB = (bodyBytes.length / 1024).toStringAsFixed(2);

    logI('webdavSync', '准备上传: $ledgerId, 大小: ${fileSizeKB}KB');

    try {
      // 构建包含 Content-Length 的请求头
      final headers = {
        ..._getAuthHeaders(),
        'Content-Length': '${bodyBytes.length}',
      };

      // 上传文件（增加超时时间以支持较大文件）
      final response = await http.put(
        url,
        headers: headers,
        body: bodyBytes,
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 201 || response.statusCode == 204 || response.statusCode == 200) {
        logI('webdavSync', '上传成功: $ledgerId, ${fileSizeKB}KB');

        // 记录上传成功
        final fp = _fingerprint(jsonStr);
        final payload = jsonDecode(jsonStr) as Map<String, dynamic>;
        final cnt = (payload['count'] as num?)?.toInt() ?? 0;
        _recentUpload[ledgerId] = _RecentUpload(
          fingerprint: fp,
          count: cnt,
          uploadedAt: DateTime.now(),
        );
        _statusCache.remove(ledgerId);
      } else {
        throw Exception('上传失败 (HTTP ${response.statusCode}): ${response.body}');
      }
    } on http.ClientException catch (e) {
      logE('webdavSync', '上传失败: $ledgerId, 大小: ${fileSizeKB}KB', e);

      // 提供更友好的错误信息
      if (e.message.contains('Broken pipe') || e.message.contains('Connection reset')) {
        throw Exception(
          '上传失败：连接被服务器关闭\n'
          '文件大小: ${fileSizeKB}KB\n'
          '可能原因：\n'
          '1. WebDAV 服务器限制了上传文件大小\n'
          '2. 请检查服务器配置（如 nginx 的 client_max_body_size）\n'
          '3. 网络连接不稳定\n\n'
          '原始错误: ${e.message}'
        );
      }
      rethrow;
    } catch (e) {
      logE('webdavSync', '上传失败: $ledgerId, 大小: ${fileSizeKB}KB', e);
      rethrow;
    }
  }

  @override
  Future<({int inserted, int skipped, int deletedDup})>
      downloadAndRestoreToCurrentLedger({required int ledgerId}) async {
    final user = await auth.currentUser();
    if (user == null) {
      throw Exception('Not logged in');
    }

    logI('webdavSync', '开始下载账本 $ledgerId');

    final url = _buildUrl(_objectPath(user.id, ledgerId));

    try {
      final response = await http.get(
        url,
        headers: _getAuthHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 404) {
        throw Exception('No remote backup found');
      }

      if (response.statusCode != 200) {
        throw Exception('Download failed with status ${response.statusCode}');
      }

      final jsonStr = utf8.decode(response.bodyBytes);

      // 导入数据
      final result = await importTransactionsJson(repo, ledgerId, jsonStr);

      // 二次去重
      final deletedDup = await repo.deduplicateLedgerTransactions(ledgerId);

      logI('webdavSync', '下载完成: inserted=${result.inserted}, skipped=${result.skipped}, deletedDup=$deletedDup');

      _statusCache.remove(ledgerId);
      _recentLocalChangeAt.remove(ledgerId);

      return (
        inserted: result.inserted,
        skipped: result.skipped,
        deletedDup: deletedDup,
      );
    } catch (e) {
      logE('webdavSync', '下载失败: $ledgerId', e);
      rethrow;
    }
  }

  @override
  Future<SyncStatus> getStatus({required int ledgerId}) async {
    final user = await auth.currentUser();
    if (user == null) {
      return const SyncStatus(
        diff: SyncDiff.notLoggedIn,
        localCount: 0,
        localFingerprint: '',
        message: '__SYNC_NOT_LOGGED_IN__',
      );
    }

    // 检查缓存
    final cached = _statusCache[ledgerId];
    if (cached != null) {
      return cached;
    }

    // 计算本地指纹
    final localJson = await exportTransactionsJson(db, ledgerId);
    final localPayload = jsonDecode(localJson) as Map<String, dynamic>;
    final localFp = _contentFingerprintFromMap(localPayload);
    final localCnt = (localPayload['count'] as num?)?.toInt() ?? 0;

    // 检查近期上传
    final recent = _recentUpload[ledgerId];
    if (recent != null && recent.isRecent) {
      if (recent.fingerprint == localFp) {
        final status = SyncStatus(
          diff: SyncDiff.inSync,
          localCount: localCnt,
          cloudCount: recent.count,
          localFingerprint: localFp,
          cloudFingerprint: recent.fingerprint,
        );
        _statusCache[ledgerId] = status;
        return status;
      }
    }

    // 下载云端数据
    try {
      final cloudData = await _downloadCloudData(user.id, ledgerId);

      if (cloudData == null) {
        final status = SyncStatus(
          diff: SyncDiff.noRemote,
          localCount: localCnt,
          localFingerprint: localFp,
          message: '__SYNC_NO_CLOUD_BACKUP__',
        );
        _statusCache[ledgerId] = status;
        return status;
      }

      final cloudFp = _contentFingerprintFromMap(cloudData);
      final cloudCnt = (cloudData['count'] as num?)?.toInt() ?? 0;
      final cloudExportedAt = cloudData['exportedAt'] != null
          ? DateTime.parse(cloudData['exportedAt'] as String)
          : null;

      // 对比指纹
      SyncDiff diff;
      if (cloudFp == localFp) {
        diff = SyncDiff.inSync;
      } else {
        // 判断方向
        final localChangeAt = _recentLocalChangeAt[ledgerId];
        if (localChangeAt != null && cloudExportedAt != null) {
          if (localChangeAt.isAfter(cloudExportedAt)) {
            diff = SyncDiff.localNewer;
          } else if (cloudExportedAt.isAfter(localChangeAt)) {
            diff = SyncDiff.cloudNewer;
          } else {
            diff = SyncDiff.different;
          }
        } else if (localCnt > cloudCnt) {
          diff = SyncDiff.localNewer;
        } else if (cloudCnt > localCnt) {
          diff = SyncDiff.cloudNewer;
        } else {
          diff = SyncDiff.different;
        }
      }

      final status = SyncStatus(
        diff: diff,
        localCount: localCnt,
        cloudCount: cloudCnt,
        localFingerprint: localFp,
        cloudFingerprint: cloudFp,
        cloudExportedAt: cloudExportedAt,
      );
      _statusCache[ledgerId] = status;
      return status;
    } catch (e) {
      logE('webdavSync', 'getStatus 失败: $ledgerId', e);
      return SyncStatus(
        diff: SyncDiff.error,
        localCount: localCnt,
        localFingerprint: localFp,
        message: e.toString(),
      );
    }
  }

  /// 下载云端数据（返回 JSON payload）
  Future<Map<String, dynamic>?> _downloadCloudData(String username, int ledgerId) async {
    final url = _buildUrl(_objectPath(username, ledgerId));

    try {
      final response = await http.get(
        url,
        headers: _getAuthHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode != 200) {
        throw Exception('Download failed with status ${response.statusCode}');
      }

      final jsonStr = utf8.decode(response.bodyBytes);
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      if (e.toString().contains('404')) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<({String? fingerprint, int? count, DateTime? exportedAt})>
      refreshCloudFingerprint({required int ledgerId}) async {
    final user = await auth.currentUser();
    if (user == null) {
      return (fingerprint: null, count: null, exportedAt: null);
    }

    try {
      final cloudData = await _downloadCloudData(user.id, ledgerId);

      if (cloudData == null) {
        return (fingerprint: null, count: null, exportedAt: null);
      }

      final fp = _contentFingerprintFromMap(cloudData);
      final cnt = (cloudData['count'] as num?)?.toInt();
      final exportedAt = cloudData['exportedAt'] != null
          ? DateTime.parse(cloudData['exportedAt'] as String)
          : null;

      return (fingerprint: fp, count: cnt, exportedAt: exportedAt);
    } catch (e) {
      logE('webdavSync', 'refreshCloudFingerprint 失败: $ledgerId', e);
      return (fingerprint: null, count: null, exportedAt: null);
    }
  }

  @override
  void markLocalChanged({required int ledgerId}) {
    _statusCache.remove(ledgerId);
    _recentUpload.remove(ledgerId);
    _recentLocalChangeAt[ledgerId] = DateTime.now();
  }

  @override
  Future<void> deleteRemoteBackup({required int ledgerId}) async {
    final user = await auth.currentUser();
    if (user == null) {
      throw Exception('Not logged in');
    }

    final url = _buildUrl(_objectPath(user.id, ledgerId));

    try {
      final response = await http.delete(
        url,
        headers: _getAuthHeaders(),
      ).timeout(const Duration(seconds: 10));

      // 204 No Content, 404 Not Found (already deleted)
      if (response.statusCode == 204 || response.statusCode == 404) {
        logI('webdavSync', '云端备份已删除: $ledgerId');
        _statusCache.remove(ledgerId);
        _recentUpload.remove(ledgerId);
      } else {
        logW('webdavSync', '删除返回状态 ${response.statusCode}: $ledgerId');
      }
    } catch (e) {
      logE('webdavSync', '删除失败: $ledgerId', e);
      // 忽略删除错误
    }
  }
}

/// 近期上传记录
class _RecentUpload {
  final String fingerprint;
  final int count;
  final DateTime uploadedAt;

  _RecentUpload({
    required this.fingerprint,
    required this.count,
    required this.uploadedAt,
  });

  bool get isRecent {
    final now = DateTime.now();
    final diff = now.difference(uploadedAt);
    return diff.inMinutes < 5; // 5分钟内视为近期
  }
}
