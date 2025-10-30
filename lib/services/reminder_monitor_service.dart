import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/notification_factory.dart';

/// 记账提醒监控服务
///
/// 功能：
/// 1. 监听应用生命周期
/// 2. 应用从后台恢复到前台时，检查提醒是否仍然有效
/// 3. 如果提醒丢失，自动重新设置
class ReminderMonitorService with WidgetsBindingObserver {
  static final ReminderMonitorService _instance = ReminderMonitorService._internal();
  factory ReminderMonitorService() => _instance;
  ReminderMonitorService._internal();

  DateTime? _lastCheckTime;
  static const _checkInterval = Duration(hours: 6); // 最多6小时检查一次

  /// 开始监控
  void startMonitoring() {
    WidgetsBinding.instance.addObserver(this);
    print('✅ 记账提醒监控服务已启动');
  }

  /// 停止监控
  void stopMonitoring() {
    WidgetsBinding.instance.removeObserver(this);
    print('🛑 记账提醒监控服务已停止');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('📱 应用生命周期变化: $state');

    if (state == AppLifecycleState.resumed) {
      // 应用从后台恢复到前台
      _checkAndRestoreReminder();
    }
  }

  /// 检查并恢复提醒
  Future<void> _checkAndRestoreReminder() async {
    try {
      // 避免频繁检查
      if (_lastCheckTime != null &&
          DateTime.now().difference(_lastCheckTime!) < _checkInterval) {
        print('ℹ️  距离上次检查时间过短，跳过本次检查');
        return;
      }

      print('🔍 开始检查记账提醒状态...');
      _lastCheckTime = DateTime.now();

      final prefs = await SharedPreferences.getInstance();
      final isEnabled = prefs.getBool('reminder_enabled') ?? false;

      if (!isEnabled) {
        print('ℹ️  用户未启用记账提醒');
        return;
      }

      // 检查是否有待处理的提醒
      final notificationUtil = NotificationFactory.getInstance();
      final pending = await notificationUtil.getPendingNotifications();
      final hasMainReminder = pending.any((n) => n.id == 1001);

      if (!hasMainReminder) {
        print('⚠️  警告：检测到记账提醒丢失，正在重新设置...');

        final hour = prefs.getInt('reminder_hour') ?? 21;
        final minute = prefs.getInt('reminder_minute') ?? 0;

        await notificationUtil.scheduleDailyReminder(
          id: 1001,
          title: '记账提醒',
          body: '别忘了记录今天的收支哦 💰',
          hour: hour,
          minute: minute,
        );

        print('✅ 记账提醒已重新设置');
      } else {
        print('✅ 记账提醒状态正常 (待处理通知数: ${pending.length})');
      }
    } catch (e) {
      print('❌ 检查提醒状态失败: $e');
    }
  }
}
