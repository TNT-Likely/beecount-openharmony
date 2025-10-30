import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_util.dart';
import 'notification_android.dart';
import 'notification_ios.dart';

/// 通知工厂类 - 根据平台创建对应的通知实现
class NotificationFactory {
  static NotificationUtil? _instance;
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 获取平台特定的通知工具实例
  static NotificationUtil getInstance() {
    if (_instance != null) return _instance!;

    if (Platform.isAndroid) {
      _instance = AndroidNotificationUtil(_plugin);
    } else if (Platform.isIOS) {
      _instance = IOSNotificationUtil(_plugin);
    } else {
      throw UnsupportedError('不支持的平台: ${Platform.operatingSystem}');
    }

    return _instance!;
  }

  /// 初始化时区（必须在使用通知服务之前调用）
  static void initializeTimeZone() {
    try {
      tz.initializeTimeZones();

      // 尝试设置为 Asia/Shanghai
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Shanghai'));
        print('[Timezone] 设置为: Asia/Shanghai');
      } catch (e) {
        // 降级到系统时区
        print('[Timezone] 使用系统时区: ${tz.local.name}');
      }

      print('[Timezone] ✅ 时区初始化完成');
    } catch (e) {
      print('[Timezone] ❌ 时区初始化失败: $e');
    }
  }

  /// 重置实例（用于测试）
  static void reset() {
    _instance = null;
  }
}
