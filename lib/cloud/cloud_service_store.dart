import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';
import 'cloud_service_config.dart';
import 'supabase_initializer.dart';

/// 云服务配置持久化存储
/// 支持3种类型:本地存储、自定义Supabase、自定义WebDAV
class CloudServiceStore {
  static const _kActiveType = 'cloud_active_type'; // local | supabase | webdav
  static const _kSupabaseCfg = 'cloud_supabase_cfg';
  static const _kWebdavCfg = 'cloud_webdav_cfg';
  static const _kFirstFullUploadFlagSupabase = 'cloud_first_full_upload_pending_supabase';
  static const _kFirstFullUploadFlagWebdav = 'cloud_first_full_upload_pending_webdav';

  /// 加载当前激活的云服务配置
  Future<CloudServiceConfig> loadActive() async {
    final sp = await SharedPreferences.getInstance();
    final activeType = sp.getString(_kActiveType) ?? 'local';

    switch (activeType) {
      case 'local':
        return CloudServiceConfig.localStorage();

      case 'supabase':
        final raw = sp.getString(_kSupabaseCfg);
        if (raw != null) {
          try {
            return decodeCloudConfig(raw);
          } catch (e) {
            logW('cloudStore', '解析Supabase配置失败: $e');
          }
        }
        // 回退到本地存储
        return CloudServiceConfig.localStorage();

      case 'webdav':
        final raw = sp.getString(_kWebdavCfg);
        if (raw != null) {
          try {
            return decodeCloudConfig(raw);
          } catch (e) {
            logW('cloudStore', '解析WebDAV配置失败: $e');
          }
        }
        // 回退到本地存储
        return CloudServiceConfig.localStorage();

      default:
        return CloudServiceConfig.localStorage();
    }
  }

  /// 加载Supabase配置(不管是否激活)
  Future<CloudServiceConfig?> loadSupabase() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kSupabaseCfg);
    if (raw == null) return null;
    try {
      return decodeCloudConfig(raw);
    } catch (e) {
      logW('cloudStore', '解析Supabase配置失败: $e');
      return null;
    }
  }

  /// 加载WebDAV配置(不管是否激活)
  Future<CloudServiceConfig?> loadWebdav() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kWebdavCfg);
    if (raw == null) return null;
    try {
      return decodeCloudConfig(raw);
    } catch (e) {
      logW('cloudStore', '解析WebDAV配置失败: $e');
      return null;
    }
  }

  /// 保存并激活配置
  Future<void> saveAndActivate(CloudServiceConfig cfg) async {
    final sp = await SharedPreferences.getInstance();

    switch (cfg.type) {
      case CloudBackendType.local:
        await sp.setString(_kActiveType, 'local');
        // 清理 Supabase 实例
        await SupabaseInitializer.dispose();
        break;

      case CloudBackendType.supabase:
        await sp.setString(_kSupabaseCfg, encodeCloudConfig(cfg));
        await sp.setString(_kActiveType, 'supabase');
        // 标记需要首次全量上传（仅针对 Supabase）
        await sp.setBool(_kFirstFullUploadFlagSupabase, true);
        // 重新初始化 Supabase
        await SupabaseInitializer.initialize(cfg);
        break;

      case CloudBackendType.webdav:
        await sp.setString(_kWebdavCfg, encodeCloudConfig(cfg));
        await sp.setString(_kActiveType, 'webdav');
        // 标记需要首次全量上传（仅针对 WebDAV）
        await sp.setBool(_kFirstFullUploadFlagWebdav, true);
        // 清理 Supabase 实例
        await SupabaseInitializer.dispose();
        break;
    }

    logI('cloudStore', '配置已保存并激活: ${cfg.type.name}');
  }

  /// 仅保存配置,不激活
  Future<void> saveOnly(CloudServiceConfig cfg) async {
    final sp = await SharedPreferences.getInstance();

    switch (cfg.type) {
      case CloudBackendType.local:
        // 本地存储无需保存
        break;

      case CloudBackendType.supabase:
        await sp.setString(_kSupabaseCfg, encodeCloudConfig(cfg));
        logI('cloudStore', 'Supabase配置已保存');
        break;

      case CloudBackendType.webdav:
        await sp.setString(_kWebdavCfg, encodeCloudConfig(cfg));
        logI('cloudStore', 'WebDAV配置已保存');
        break;
    }
  }

  /// 激活指定类型的配置
  Future<bool> activate(CloudBackendType type) async {
    final sp = await SharedPreferences.getInstance();

    switch (type) {
      case CloudBackendType.local:
        await sp.setString(_kActiveType, 'local');
        return true;

      case CloudBackendType.supabase:
        final raw = sp.getString(_kSupabaseCfg);
        if (raw == null) return false;
        try {
          final cfg = decodeCloudConfig(raw);
          if (!cfg.valid) return false;
          await sp.setString(_kActiveType, 'supabase');
          // 标记需要首次全量上传（仅针对 Supabase）
          await sp.setBool(_kFirstFullUploadFlagSupabase, true);
          return true;
        } catch (e) {
          logW('cloudStore', '激活Supabase配置失败: $e');
          return false;
        }

      case CloudBackendType.webdav:
        final raw = sp.getString(_kWebdavCfg);
        if (raw == null) return false;
        try {
          final cfg = decodeCloudConfig(raw);
          if (!cfg.valid) return false;
          await sp.setString(_kActiveType, 'webdav');
          // 标记需要首次全量上传（仅针对 WebDAV）
          await sp.setBool(_kFirstFullUploadFlagWebdav, true);
          return true;
        } catch (e) {
          logW('cloudStore', '激活WebDAV配置失败: $e');
          return false;
        }
    }
  }

  Future<bool> isFirstFullUploadPending() async {
    final sp = await SharedPreferences.getInstance();
    final activeType = sp.getString(_kActiveType) ?? 'local';

    switch (activeType) {
      case 'supabase':
        return sp.getBool(_kFirstFullUploadFlagSupabase) ?? false;
      case 'webdav':
        return sp.getBool(_kFirstFullUploadFlagWebdav) ?? false;
      default:
        return false;
    }
  }

  Future<void> clearFirstFullUploadFlag() async {
    final sp = await SharedPreferences.getInstance();
    final activeType = sp.getString(_kActiveType) ?? 'local';

    switch (activeType) {
      case 'supabase':
        await sp.remove(_kFirstFullUploadFlagSupabase);
        break;
      case 'webdav':
        await sp.remove(_kFirstFullUploadFlagWebdav);
        break;
      default:
        break;
    }
  }
}
