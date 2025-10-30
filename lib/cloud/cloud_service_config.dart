import 'dart:convert';

/// 云服务后端类型
enum CloudBackendType {
  local,     // 本地存储(不同步)
  supabase,  // Supabase (自建)
  webdav,    // WebDAV (坚果云、Nextcloud、群晖等)
}

class CloudServiceConfig {
  final CloudBackendType type;
  final String name; // UI 展示名称

  // Supabase 配置
  final String? supabaseUrl;
  final String? supabaseAnonKey;

  // WebDAV 配置
  final String? webdavUrl;
  final String? webdavUsername;
  final String? webdavPassword;
  final String? webdavRemotePath;

  const CloudServiceConfig({
    required this.type,
    required this.name,
    // Supabase
    this.supabaseUrl,
    this.supabaseAnonKey,
    // WebDAV
    this.webdavUrl,
    this.webdavUsername,
    this.webdavPassword,
    this.webdavRemotePath,
  });

  String get id => type.name; // 使用类型作为id

  bool get valid {
    switch (type) {
      case CloudBackendType.local:
        return true; // 本地存储始终有效
      case CloudBackendType.supabase:
        return (supabaseUrl?.isNotEmpty ?? false) &&
               (supabaseAnonKey?.isNotEmpty ?? false);
      case CloudBackendType.webdav:
        return (webdavUrl?.isNotEmpty ?? false) &&
               (webdavUsername?.isNotEmpty ?? false) &&
               (webdavPassword?.isNotEmpty ?? false);
    }
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        // Supabase
        'supabaseUrl': supabaseUrl,
        'supabaseAnonKey': supabaseAnonKey,
        // WebDAV
        'webdavUrl': webdavUrl,
        'webdavUsername': webdavUsername,
        'webdavPassword': webdavPassword,
        'webdavRemotePath': webdavRemotePath,
      };

  static CloudServiceConfig fromJson(Map<String, dynamic> j) =>
      CloudServiceConfig(
        type: CloudBackendType.values
            .firstWhere((e) => e.name == j['type'] as String),
        name: j['name'] as String,
        // Supabase
        supabaseUrl: j['supabaseUrl'] as String?,
        supabaseAnonKey: j['supabaseAnonKey'] as String?,
        // WebDAV
        webdavUrl: j['webdavUrl'] as String?,
        webdavUsername: j['webdavUsername'] as String?,
        webdavPassword: j['webdavPassword'] as String?,
        webdavRemotePath: j['webdavRemotePath'] as String?,
      );

  // 本地存储配置(默认)
  static CloudServiceConfig localStorage() => const CloudServiceConfig(
        type: CloudBackendType.local,
        name: '__LOCAL_STORAGE__',
      );

  String obfuscatedUrl() {
    switch (type) {
      case CloudBackendType.local:
        return '__LOCAL_DEVICE__';
      case CloudBackendType.supabase:
        if (supabaseUrl == null || supabaseUrl!.isEmpty) {
          return '__NOT_CONFIGURED__'; // 特殊标记，在UI层处理本地化
        }
        // 仅显示域名部分（隐藏具体 path / 项目 id）
        try {
          final uri = Uri.parse(supabaseUrl!);
          if (uri.host.isEmpty) return supabaseUrl!; // 如果没有host，返回原始URL
          return uri.host; // 不展示 scheme 与后缀
        } catch (_) {
          return supabaseUrl!; // 解析失败，返回原始URL
        }

      case CloudBackendType.webdav:
        if (webdavUrl == null || webdavUrl!.isEmpty) {
          return '__NOT_CONFIGURED__';
        }
        // 显示WebDAV服务器地址的域名部分
        try {
          final uri = Uri.parse(webdavUrl!);
          if (uri.host.isEmpty) return webdavUrl!; // 如果没有host，返回原始URL
          return uri.host;
        } catch (_) {
          return webdavUrl!; // 解析失败，返回原始URL
        }
    }
  }
}

String encodeCloudConfig(CloudServiceConfig c) => jsonEncode(c.toJson());
CloudServiceConfig decodeCloudConfig(String raw) =>
    CloudServiceConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
