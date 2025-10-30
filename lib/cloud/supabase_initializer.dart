import 'package:supabase_flutter/supabase_flutter.dart' as s;
import '../utils/logger.dart';
import 'cloud_service_config.dart';

/// Supabase 全局初始化管理器
/// 负责在应用启动和配置变更时初始化/重新初始化 Supabase
class SupabaseInitializer {
  static bool _isInitialized = false;
  static String? _currentUrl;
  static String? _currentKey;

  /// 初始化或重新初始化 Supabase
  ///
  /// 如果配置变化，会先清理旧实例再创建新实例
  static Future<void> initialize(CloudServiceConfig config) async {
    if (config.type != CloudBackendType.supabase || !config.valid) {
      logW('SupabaseInitializer', '配置无效，跳过初始化');
      return;
    }

    final url = config.supabaseUrl!;
    final key = config.supabaseAnonKey!;

    // 如果配置没变且已初始化，直接返回
    if (_isInitialized && _currentUrl == url && _currentKey == key) {
      logI('SupabaseInitializer', '配置未变化，使用现有实例');
      return;
    }

    try {
      // 如果已初始化但配置变化，需要重新初始化
      if (_isInitialized) {
        logI('SupabaseInitializer', '配置已变化，重新初始化...');
        await dispose();
      }

      logI('SupabaseInitializer', '初始化 Supabase: ${config.obfuscatedUrl()}');
      await s.Supabase.initialize(
        url: url,
        anonKey: key,
      );

      _isInitialized = true;
      _currentUrl = url;
      _currentKey = key;
      logI('SupabaseInitializer', 'Supabase 初始化成功');
    } catch (e) {
      logE('SupabaseInitializer', '初始化失败: $e');
      rethrow;
    }
  }

  /// 清理当前 Supabase 实例
  static Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }

    try {
      logI('SupabaseInitializer', '清理 Supabase 实例...');
      await s.Supabase.instance.client.auth.signOut();
      // 注意: Supabase.instance 是单例，无法真正"dispose"
      // 我们只能登出并标记为未初始化，下次会重新initialize
      _isInitialized = false;
      _currentUrl = null;
      _currentKey = null;
      logI('SupabaseInitializer', 'Supabase 实例已清理');
    } catch (e) {
      logW('SupabaseInitializer', '清理失败: $e');
    }
  }

  /// 检查是否已初始化
  static bool get isInitialized => _isInitialized;

  /// 获取当前客户端（如果已初始化）
  static s.SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return s.Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
}
