import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'theme.dart';
import 'providers.dart';
import 'styles/colors.dart';
import 'providers/font_scale_provider.dart';
import 'utils/route_logger.dart';
import 'utils/notification_factory.dart';
import 'pages/splash_page.dart';
import 'services/reminder_monitor_service.dart';
import 'services/recurring_transaction_service.dart';
import 'data/db.dart';
import 'l10n/app_localizations.dart';
import 'cloud/cloud_service_store.dart';
import 'cloud/supabase_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化时区（必须在通知服务之前，修复iOS通知问题）
  NotificationFactory.initializeTimeZone();

  // 全局初始化Supabase（如果配置了自定义Supabase服务）
  await _initializeSupabase();

  // 初始化通知服务
  final notificationUtil = NotificationFactory.getInstance();
  await notificationUtil.initialize();

  // 恢复用户的记账提醒设置（关键修复：应用重启后自动恢复提醒）
  await _restoreUserReminder();

  // 启动提醒监控服务（监听应用生命周期，自动恢复丢失的提醒）
  ReminderMonitorService().startMonitoring();

  // 生成待处理的重复交易
  await _generatePendingRecurringTransactions();

  runApp(const ProviderScope(child: MainApp()));
}

/// 全局初始化Supabase
///
/// 在应用启动时检查用户是否配置了自定义Supabase服务，如果配置了则全局初始化
/// 这样可以确保session在应用重启后能够正确恢复
Future<void> _initializeSupabase() async {
  try {
    final store = CloudServiceStore();
    final config = await store.loadActive();

    // 只在配置了Supabase服务时才初始化
    await SupabaseInitializer.initialize(config);
  } catch (e) {
    print('⚠️  Supabase 初始化失败（非致命错误）: $e');
    // 不抛出异常，避免影响应用启动
  }
}

/// 恢复用户之前设置的记账提醒
///
/// 问题场景：
/// - 应用被系统杀死后，通知任务会丢失
/// - 应用更新后，通知任务会被清除
/// - 手机重启后，通知任务需要重新设置
///
/// 解决方案：
/// - 在应用启动时检查用户是否开启了提醒
/// - 如果开启了，重新设置通知任务
Future<void> _restoreUserReminder() async {
  try {
    print('🔄 检查并恢复记账提醒...');
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('reminder_enabled') ?? false;

    if (isEnabled) {
      final hour = prefs.getInt('reminder_hour') ?? 21;
      final minute = prefs.getInt('reminder_minute') ?? 0;
      print('✅ 发现用户已启用记账提醒: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      print('🔔 正在重新设置提醒任务...');

      final notificationUtil = NotificationFactory.getInstance();
      await notificationUtil.scheduleDailyReminder(
        id: 1001,
        title: '记账提醒',
        body: '别忘了记录今天的收支哦 💰',
        hour: hour,
        minute: minute,
      );

      print('✅ 记账提醒已成功恢复');
    } else {
      print('ℹ️  用户未启用记账提醒，跳过恢复');
    }
  } catch (e) {
    print('❌ 恢复记账提醒失败: $e');
    // 不抛出异常，避免影响应用启动
  }
}

/// 生成待处理的重复交易
///
/// 在应用启动时检查所有重复交易模板，生成到期的交易记录
Future<void> _generatePendingRecurringTransactions() async {
  try {
    print('🔄 检查待生成的重复交易...');
    final db = BeeDatabase();
    final service = RecurringTransactionService(db);

    final generatedTransactions = await service.generatePendingTransactions();

    if (generatedTransactions.isNotEmpty) {
      print('✅ 成功生成 ${generatedTransactions.length} 条重复交易记录');
    } else {
      print('ℹ️  没有待生成的重复交易');
    }

    await db.close();
  } catch (e) {
    print('❌ 生成重复交易失败: $e');
    // 不抛出异常，避免影响应用启动
  }
}

class NoGlowScrollBehavior extends MaterialScrollBehavior {
  const NoGlowScrollBehavior();
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // 去除 Android 上的发光效果，避免顶部出现一抹红
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 检查应用初始化状态
    final initState = ref.watch(appInitStateProvider);
    final selectedLanguage = ref.watch(languageProvider);
    
    // 如果是启屏状态，启动初始化
    if (initState == AppInitState.splash) {
      ref.watch(appSplashInitProvider);
    }
    
    final primary = ref.watch(primaryColorProvider);
    final platform = Theme.of(context).platform; // 当前平台
    final base = BeeTheme.lightTheme(platform: platform);
    final baseTextTheme = base.textTheme;

    final theme = base.copyWith(
      textTheme: baseTextTheme,
      colorScheme: base.colorScheme.copyWith(primary: primary),
      primaryColor: primary,
      scaffoldBackgroundColor: Colors.white,
      dividerColor: BeeColors.divider,
      listTileTheme: const ListTileThemeData(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        iconColor: BeeColors.primaryText,
      ),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: baseTextTheme.titleMedium?.copyWith(
            color: BeeColors.primaryText, fontWeight: FontWeight.w600),
        contentTextStyle:
            baseTextTheme.bodyMedium?.copyWith(color: BeeColors.secondaryText),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: baseTextTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primary,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: base.cardTheme.copyWith(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
    );
    // Clamp 系统字体缩放，避免部分设备设置 1.5+ 造成 UI 溢出
    final media = MediaQuery.of(context);
    // init font scale persistence
    ref.watch(fontScaleInitProvider);
    final customScale = ref.watch(effectiveFontScaleProvider);
    final clamped = media.textScaler.clamp(
      minScaleFactor: 0.85,
      maxScaleFactor: 1.15,
    );
    final combinedScale = clamped.scale(customScale); // returns double
    final newScaler = TextScaler.linear(combinedScale);
    return MediaQuery(
      data: media.copyWith(textScaler: newScaler),
      child: MaterialApp(
        title: 'Bee Accounting',
        scrollBehavior: const NoGlowScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: BeeTheme.darkTheme(),
        navigatorObservers: [LoggingNavigatorObserver()],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh'),
          Locale('zh', 'TW'),
          Locale('ja'),
          Locale('ko'),
          Locale('es'),
          Locale('fr'),
          Locale('de'),
        ],
        locale: selectedLanguage,
        // 显式命名根路由，便于路由日志与 popUntil 精确识别
        home: initState == AppInitState.ready ? const BeeApp() : const SplashPage(),
        onGenerateRoute: (settings) {
          if (settings.name == Navigator.defaultRouteName ||
              settings.name == '/') {
            return MaterialPageRoute(
                builder: (_) => initState == AppInitState.ready ? const BeeApp() : const SplashPage(),
                settings: const RouteSettings(name: '/'));
          }
          return null;
        },
      ),
    );
  }
}
