import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// wheel_date_picker exported via ui barrel
import '../widgets/biz/biz.dart';
import '../styles/design.dart';
import '../providers.dart';
import '../styles/colors.dart';
import '../widgets/ui/ui.dart';
import '../widgets/charts/line_chart.dart';
import '../widgets/analytics/analytics_summary.dart';
import '../widgets/analytics/category_rank_row.dart';
import '../widgets/ui/capsule_switcher.dart';
import 'category_detail_page.dart';
import 'analytics2_page.dart';
import '../l10n/app_localizations.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  String _scope = 'month'; // month | year | all
  String _type = 'expense'; // expense | income | balance
  bool _chartSwiped = false; // 吸收图表区域横滑，避免父级切换收入/支出
  bool _localHeaderDismissed = false; // 本地快速隐藏，实际持久化在 provider 中
  bool _localChartDismissed = false;

  // 显示周期选择器
  void _showPeriodPicker() async {
    final selMonth = ref.read(selectedMonthProvider);
    if (_scope == 'month') {
      final res = await showWheelDatePicker(
        context,
        initial: selMonth,
        mode: WheelDatePickerMode.ym,
        maxDate: DateTime.now(),
      );
      final picked = res == null ? null : DateTime(res.year, res.month, 1);
      if (picked != null) {
        ref.read(selectedMonthProvider.notifier).state = picked;
      }
    } else if (_scope == 'year') {
      final res = await showWheelDatePicker(
        context,
        initial: selMonth,
        mode: WheelDatePickerMode.y,
        maxDate: DateTime.now(),
      );
      if (res != null) {
        ref.read(selectedMonthProvider.notifier).state = DateTime(res.year, 1, 1);
      }
    }
    // all视角不显示选择器
  }

  // 显示类型选择菜单
  void _showTypeMenu() async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('选择视角'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'expense'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: _type == 'expense' ? Theme.of(context).primaryColor : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.homeExpense,
                    style: TextStyle(
                      fontWeight: _type == 'expense' ? FontWeight.bold : null,
                      color: _type == 'expense' ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'income'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: _type == 'income' ? Theme.of(context).primaryColor : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.homeIncome,
                    style: TextStyle(
                      fontWeight: _type == 'income' ? FontWeight.bold : null,
                      color: _type == 'income' ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'balance'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.balance,
                    color: _type == 'balance' ? Theme.of(context).primaryColor : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.homeBalance,
                    style: TextStyle(
                      fontWeight: _type == 'balance' ? FontWeight.bold : null,
                      color: _type == 'balance' ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _type = result;
      });
    }
  }

  // 循环切换类型（用于滑动）：expense -> income -> balance -> expense
  void _cycleTypeForward() {
    setState(() {
      if (_type == 'expense') {
        _type = 'income';
      } else if (_type == 'income') {
        _type = 'balance';
      } else {
        _type = 'expense';
      }
    });
  }

  void _cycleTypeBackward() {
    setState(() {
      if (_type == 'expense') {
        _type = 'balance';
      } else if (_type == 'balance') {
        _type = 'income';
      } else {
        _type = 'expense';
      }
    });
  }

  // 根据scope切换周期（用于图表滑动）
  void _onChartSwipeLeft() {
    final selMonth = ref.read(selectedMonthProvider);
    final now = DateTime.now();
    setState(() {
      if (_scope == 'month') {
        // 月视角：切换到下一个月（不能超过当前月）
        final nextMonth = DateTime(selMonth.year, selMonth.month + 1, 1);
        if (nextMonth.year < now.year ||
            (nextMonth.year == now.year && nextMonth.month <= now.month)) {
          ref.read(selectedMonthProvider.notifier).state = nextMonth;
        }
      } else if (_scope == 'year') {
        // 年视角：切换到下一年（不能超过当前年）
        final nextYear = DateTime(selMonth.year + 1, 1, 1);
        if (nextYear.year <= now.year) {
          ref.read(selectedMonthProvider.notifier).state = nextYear;
        }
      }
      // all视角：不做任何操作
    });
  }

  void _onChartSwipeRight() {
    final selMonth = ref.read(selectedMonthProvider);
    setState(() {
      if (_scope == 'month') {
        // 月视角：切换到上一个月
        final prevMonth = DateTime(selMonth.year, selMonth.month - 1, 1);
        ref.read(selectedMonthProvider.notifier).state = prevMonth;
      } else if (_scope == 'year') {
        // 年视角：切换到上一年
        final prevYear = DateTime(selMonth.year - 1, 1, 1);
        ref.read(selectedMonthProvider.notifier).state = prevYear;
      }
      // all视角：不做任何操作
    });
  }

  // 计算结余序列（收入 - 支出）
  dynamic _calculateBalanceSeries(dynamic incomeData, dynamic expenseData) {
    if (incomeData is List<({DateTime day, double total})> &&
        expenseData is List<({DateTime day, double total})>) {
      final Map<DateTime, double> incomeMap = {for (var e in incomeData) e.day: e.total};
      final Map<DateTime, double> expenseMap = {for (var e in expenseData) e.day: e.total};
      final allDays = {...incomeMap.keys, ...expenseMap.keys}.toList()..sort();
      return allDays.map((day) {
        final income = incomeMap[day] ?? 0.0;
        final expense = expenseMap[day] ?? 0.0;
        return (day: day, total: income - expense);
      }).toList();
    }
    if (incomeData is List<({DateTime month, double total})> &&
        expenseData is List<({DateTime month, double total})>) {
      final Map<DateTime, double> incomeMap = {for (var e in incomeData) e.month: e.total};
      final Map<DateTime, double> expenseMap = {for (var e in expenseData) e.month: e.total};
      final allMonths = {...incomeMap.keys, ...expenseMap.keys}.toList()..sort();
      return allMonths.map((month) {
        final income = incomeMap[month] ?? 0.0;
        final expense = expenseMap[month] ?? 0.0;
        return (month: month, total: income - expense);
      }).toList();
    }
    if (incomeData is List<({int year, double total})> &&
        expenseData is List<({int year, double total})>) {
      final Map<int, double> incomeMap = {for (var e in incomeData) e.year: e.total};
      final Map<int, double> expenseMap = {for (var e in expenseData) e.year: e.total};
      final allYears = {...incomeMap.keys, ...expenseMap.keys}.toList()..sort();
      return allYears.map((year) {
        final income = incomeMap[year] ?? 0.0;
        final expense = expenseMap[year] ?? 0.0;
        return (year: year, total: income - expense);
      }).toList();
    }
    return [];
  }

  // 从序列数据中计算总和
  double _getSumFromSeries(dynamic seriesData) {
    if (seriesData is List<({DateTime day, double total})>) {
      return seriesData.fold<double>(0, (sum, e) => sum + e.total);
    }
    if (seriesData is List<({DateTime month, double total})>) {
      return seriesData.fold<double>(0, (sum, e) => sum + e.total);
    }
    if (seriesData is List<({int year, double total})>) {
      return seriesData.fold<double>(0, (sum, e) => sum + e.total);
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(repositoryProvider);
    final ledgerId = ref.watch(currentLedgerIdProvider);
    final selMonth = ref.watch(selectedMonthProvider);
    // 统计刷新 tick：当有新增/编辑/删除时我们会 +1，这里监听以触发重建和重新拉取
    ref.watch(statsRefreshProvider);

    // 时间范围
    late DateTime start;
    late DateTime end;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_scope == 'month') {
      start = DateTime(selMonth.year, selMonth.month, 1);
      final monthEnd = DateTime(selMonth.year, selMonth.month + 1, 1);
      // 当前月份：只到今天；历史月份：到月末
      final isCurrentMonth =
          selMonth.year == now.year && selMonth.month == now.month;
      end = isCurrentMonth ? today.add(const Duration(days: 1)) : monthEnd;
    } else if (_scope == 'year') {
      start = DateTime(selMonth.year, 1, 1);
      final yearEnd = DateTime(selMonth.year + 1, 1, 1);
      // 当前年份：只到今天；历史年份：到年末
      final isCurrentYear = selMonth.year == now.year;
      end = isCurrentYear ? today.add(const Duration(days: 1)) : yearEnd;
    } else {
      start = DateTime(1970, 1, 1);
      end = today.add(const Duration(days: 1));
    }

    // 按视角获取序列
    Future<dynamic> seriesFuture;
    Future<dynamic>? incomeSeriesFuture;
    Future<dynamic>? expenseSeriesFuture;

    if (_type == 'balance') {
      // 结余模式：同时获取收入和支出数据
      if (_scope == 'month') {
        incomeSeriesFuture = repo.totalsByDay(
            ledgerId: ledgerId, type: 'income', start: start, end: end);
        expenseSeriesFuture = repo.totalsByDay(
            ledgerId: ledgerId, type: 'expense', start: start, end: end);
        seriesFuture = Future.value([]); // 占位
      } else if (_scope == 'year') {
        incomeSeriesFuture = repo.totalsByMonth(
            ledgerId: ledgerId, type: 'income', year: selMonth.year);
        expenseSeriesFuture = repo.totalsByMonth(
            ledgerId: ledgerId, type: 'expense', year: selMonth.year);
        seriesFuture = Future.value([]);
      } else {
        incomeSeriesFuture = repo.totalsByYearSeries(ledgerId: ledgerId, type: 'income');
        expenseSeriesFuture = repo.totalsByYearSeries(ledgerId: ledgerId, type: 'expense');
        seriesFuture = Future.value([]);
      }
    } else {
      // 收入或支出模式
      seriesFuture = _scope == 'month'
          ? repo.totalsByDay(
              ledgerId: ledgerId, type: _type, start: start, end: end)
          : _scope == 'year'
              ? repo.totalsByMonth(
                  ledgerId: ledgerId, type: _type, year: selMonth.year)
              : repo.totalsByYearSeries(ledgerId: ledgerId, type: _type);
    }

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: _currentPeriodLabel(_scope, selMonth, context),
            leadingIcon: Icons.bar_chart_outlined,
            leadingPlain: true,
            compact: true,
            showTitleSection: false,
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.bar_chart_outlined, color: Colors.black87),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _scope != 'all' ? _showPeriodPicker : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPeriodLabel(_scope, selMonth, context),
                          style: AppTextTokens.title(context),
                        ),
                        if (_scope != 'all')
                          Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                            color: Colors.black87,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: _showTypeMenu,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _type == 'expense'
                              ? AppLocalizations.of(context).homeExpense
                              : _type == 'income'
                                  ? AppLocalizations.of(context).homeIncome
                                  : AppLocalizations.of(context).homeBalance,
                          style: AppTextTokens.title(context),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (kDebugMode)
                    IconButton(
                      icon: const Icon(Icons.analytics_outlined,
                          color: Colors.black87),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Analytics2Page(),
                          ),
                        );
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.black87),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(AppLocalizations.of(context).commonHelp),
                          content: SingleChildScrollView(
                            child: Text(
                              AppLocalizations.of(context).analyticsTipContent.replaceAll('\\n', '\n'),
                              style: const TextStyle(height: 1.5),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(AppLocalizations.of(context).commonOk),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            padding: EdgeInsets.zero,
            bottom: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: CapsuleSwitcher<String>(
                selectedValue: _scope,
                options: [
                  CapsuleOption(
                    value: 'month',
                    label: AppLocalizations.of(context).analyticsMonth,
                  ),
                  CapsuleOption(
                    value: 'year',
                    label: AppLocalizations.of(context).analyticsYear,
                  ),
                  CapsuleOption(
                    value: 'all',
                    label: AppLocalizations.of(context).analyticsAll,
                  ),
                ],
                onChanged: (value) => setState(() => _scope = value),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              key: ValueKey('analytics_$_type'),
              future: _type == 'balance'
                  ? Future.wait([
                      repo.totalsByCategory(
                          ledgerId: ledgerId, type: 'expense', start: start, end: end),
                      seriesFuture,
                      repo.countByTypeInRange(
                          ledgerId: ledgerId, type: 'expense', start: start, end: end),
                      incomeSeriesFuture!,
                      expenseSeriesFuture!,
                      repo.countByTypeInRange(
                          ledgerId: ledgerId, type: 'income', start: start, end: end),
                    ])
                  : Future.wait([
                      repo.totalsByCategory(
                          ledgerId: ledgerId, type: _type, start: start, end: end),
                      seriesFuture,
                      repo.countByTypeInRange(
                          ledgerId: ledgerId, type: _type, start: start, end: end),
                    ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = snapshot.data as List<dynamic>;

                // 在balance模式下，需要计算结余数据
                dynamic seriesRaw;
                List<({int? id, String name, String? icon, double total})> catData;
                int txCount;
                double sum;

                if (_type == 'balance') {
                  // balance模式：list[3]是收入数据，list[4]是支出数据，list[5]是收入交易数量
                  final incomeData = list[3];
                  final expenseData = list[4];

                  // 计算结余序列
                  seriesRaw = _calculateBalanceSeries(incomeData, expenseData);

                  // 分类数据显示支出分类（但结余模式下不显示排行榜）
                  catData = (list[0] as List<({int? id, String name, String? icon, double total})>);

                  // 获取收入和支出的交易数量
                  final expenseCount = list[2] as int;
                  final incomeCount = list[5] as int;
                  txCount = expenseCount + incomeCount;

                  // 计算总结余（收入总额 - 支出总额）
                  final incomeSum = _getSumFromSeries(incomeData);
                  final expenseSum = _getSumFromSeries(expenseData);
                  sum = incomeSum - expenseSum;
                } else {
                  catData = (list[0] as List<({int? id, String name, String? icon, double total})>);
                  seriesRaw = list[1];
                  txCount = list[2] as int;
                  sum = catData.fold<double>(0, (a, b) => a + b.total);
                }

                // 统一取数列的数值数组
                List<double> valuesOnly() {
                  if (seriesRaw is List<({DateTime day, double total})>) {
                    return seriesRaw.map((e) => e.total).toList();
                  }
                  if (seriesRaw is List<({DateTime month, double total})>) {
                    return seriesRaw.map((e) => e.total).toList();
                  }
                  if (seriesRaw is List<({int year, double total})>) {
                    return seriesRaw.map((e) => e.total).toList();
                  }
                  return const <double>[];
                }

                final vals = valuesOnly();
                final allZero = vals.isEmpty || vals.every((v) => v == 0);
                if (txCount == 0 || (sum == 0 && allZero)) {
                  final headerDismissed = (ref
                              .watch(analyticsHeaderHintDismissedProvider)
                              .asData
                              ?.value ??
                          false) ||
                      _localHeaderDismissed;
                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      // 左右滑动切换周期（月份/年份）
                      if (details.primaryVelocity! > 0) {
                        _onChartSwipeRight(); // 向右滑动 -> 上一个周期
                      } else {
                        _onChartSwipeLeft(); // 向左滑动 -> 下一个周期
                      }
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        AppEmpty(
                          text: AppLocalizations.of(context).commonEmpty,
                          subtext: AppLocalizations.of(context).analyticsNoDataSubtext,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.center,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.swap_horiz),
                            label: Text(AppLocalizations.of(context).analyticsSwitchTo(
                                _type == "expense"
                                    ? AppLocalizations.of(context).homeIncome
                                    : _type == "income"
                                        ? AppLocalizations.of(context).homeBalance
                                        : AppLocalizations.of(context).homeExpense)),
                            onPressed: _cycleTypeForward,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (!headerDismissed)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline,
                                  size: 14, color: BeeColors.secondaryText),
                              const SizedBox(width: 6),
                              Text(AppLocalizations.of(context).analyticsTipHeader,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: BeeColors.secondaryText)),
                            ],
                          ),
                      ],
                    ),
                  );
                }

                // 注意：sum 非 0 或曲线存在非零值则继续渲染

                // 过滤数据：只显示到当前时间的数据
                final filteredSeriesRaw = () {
                  if (seriesRaw is List<({DateTime day, double total})>) {
                    // 天数据：已经通过时间范围过滤了
                    return seriesRaw;
                  }
                  if (seriesRaw is List<({DateTime month, double total})>) {
                    // 月数据：过滤到当前月份
                    final isCurrentYear = selMonth.year == now.year;
                    if (isCurrentYear) {
                      return seriesRaw
                          .where((e) => e.month.month <= now.month)
                          .toList();
                    }
                    return seriesRaw;
                  }
                  if (seriesRaw is List<({int year, double total})>) {
                    // 年数据：过滤到当前年份
                    return seriesRaw.where((e) => e.year <= now.year).toList();
                  }
                  return seriesRaw;
                }();

                // 转换为折线值数组 + x 轴标签
                final values = () {
                  if (filteredSeriesRaw
                      is List<({DateTime day, double total})>) {
                    return filteredSeriesRaw.map((e) => e.total).toList();
                  }
                  if (filteredSeriesRaw
                      is List<({DateTime month, double total})>) {
                    return filteredSeriesRaw.map((e) => e.total).toList();
                  }
                  if (filteredSeriesRaw is List<({int year, double total})>) {
                    return filteredSeriesRaw.map((e) => e.total).toList();
                  }
                  return const <double>[];
                }();

                final xLabels = () {
                  if (filteredSeriesRaw
                      is List<({DateTime day, double total})>) {
                    return filteredSeriesRaw
                        .map((e) => e.day.day.toString())
                        .toList(growable: false);
                  }
                  if (filteredSeriesRaw
                      is List<({DateTime month, double total})>) {
                    return filteredSeriesRaw
                        .map((e) => AppLocalizations.of(context).homeMonth(e.month.month.toString().padLeft(2, '0')))
                        .toList(growable: false);
                  }
                  if (filteredSeriesRaw is List<({int year, double total})>) {
                    return filteredSeriesRaw
                        .map((e) => e.year.toString())
                        .toList(growable: false);
                  }
                  return const <String>[];
                }();

                int? highlightIndex;
                if (_scope == 'month' &&
                    filteredSeriesRaw is List<({DateTime day, double total})>) {
                  final today = DateTime.now();
                  if (today.year == selMonth.year &&
                      today.month == selMonth.month) {
                    highlightIndex = today.day - 1; // 从 0 开始
                    if (highlightIndex >= 0 &&
                        highlightIndex < xLabels.length) {
                      xLabels[highlightIndex] = AppLocalizations.of(context).analyticsToday;
                    }
                  }
                }

                // 提示是否已被持久化关闭
                final headerDismissed = (ref
                            .watch(analyticsHeaderHintDismissedProvider)
                            .asData
                            ?.value ??
                        false) ||
                    _localHeaderDismissed;
                final chartDismissed = (ref
                            .watch(analyticsChartHintDismissedProvider)
                            .asData
                            ?.value ??
                        false) ||
                    _localChartDismissed;

                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (_chartSwiped) {
                      setState(() => _chartSwiped = false);
                      return;
                    }
                    // 左右滑动切换类型
                    if (details.primaryVelocity! > 0) {
                      _cycleTypeBackward();
                    } else {
                      _cycleTypeForward();
                    }
                  },
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      AnalyticsSummary(
                        scope: _scope,
                        isExpense: _type == 'expense',
                        isBalance: _type == 'balance',
                        total: sum,
                        avg: _computeAverage(filteredSeriesRaw, _scope),
                        expenseColor: Theme.of(context).colorScheme.primary,
                        incomeColor: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 240,
                        child: LineChart(
                          values: values,
                          xLabels: xLabels,
                          highlightIndex: highlightIndex,
                          themeColor: Theme.of(context).colorScheme.primary,
                          // 使用统一图表令牌
                          lineWidth: AppChartTokens.lineWidth,
                          dotRadius: AppChartTokens.dotRadius,
                          cornerRadius: AppChartTokens.cornerRadius,
                          xLabelFontSize: AppChartTokens.xLabelFontSize,
                          yLabelFontSize: AppChartTokens.yLabelFontSize,
                          onSwipeLeft: () {
                            // 根据scope切换周期
                            _onChartSwipeLeft();
                            setState(() => _chartSwiped = true);
                          },
                          onSwipeRight: () {
                            // 根据scope切换周期
                            _onChartSwipeRight();
                            setState(() => _chartSwiped = true);
                          },
                          showHint: !chartDismissed,
                          hintText: AppLocalizations.of(context).analyticsSwipeHint,
                          onCloseHint: () async {
                            final setter =
                                ref.read(analyticsHintsSetterProvider);
                            await setter.dismissChart();
                            if (mounted) {
                              setState(() => _localChartDismissed = true);
                            }
                          },
                          whiteBg: true,
                          showGrid: false,
                          showDots: true,
                          annotate: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 结余视角不显示分类排行榜标题和内容
                      if (_type != 'balance')
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context).analyticsCategoryRanking,
                              style: AppTextTokens.title(context),
                            ),
                            const Spacer(),
                            if (!headerDismissed)
                              InkWell(
                                onTap: () async {
                                  final setter =
                                      ref.read(analyticsHintsSetterProvider);
                                  await setter.dismissHeader();
                                  if (mounted) {
                                    setState(() => _localHeaderDismissed = true);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.swipe,
                                        size: 14, color: BeeColors.secondaryText),
                                    const SizedBox(width: 4),
                                    Text(AppLocalizations.of(context).analyticsSwipeToSwitch,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: BeeColors.secondaryText)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.close,
                                        size: 14, color: BeeColors.hintText),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (_type != 'balance')
                        const SizedBox(height: 8),
                      if (_type != 'balance')
                        for (final item in catData)
                          InkWell(
                            onTap: () => _openCategoryDetail(
                                context, item.id, item.name, start, end, _type),
                            child: CategoryRankRow(
                              name: item.name,
                              iconName: item.icon,
                              value: item.total,
                              percent: sum == 0 ? 0 : item.total / sum,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// 顶部类型下拉已移除

// 自定义选择器：月份（年+月）
// 旧的自定义年月选择器已移除，统一使用 showWheelDatePicker。

String _currentPeriodLabel(String scope, DateTime selMonth, BuildContext context) {
  switch (scope) {
    case 'year':
      return '${selMonth.year}';
    case 'all':
      return AppLocalizations.of(context).analyticsAllYears;
    case 'month':
    default:
      return '${selMonth.year}-${selMonth.month.toString().padLeft(2, '0')}';
  }
}

double _computeAverage(dynamic seriesRaw, String scope) {
  final now = DateTime.now();

  if (seriesRaw is List<({DateTime day, double total})>) {
    if (seriesRaw.isEmpty) return 0;
    final sum = seriesRaw.fold<double>(0, (a, b) => a + b.total);

    // 月度视角：计算已经过去的天数
    if (seriesRaw.isNotEmpty) {
      final firstDay = seriesRaw.first.day;
      final isCurrentMonth =
          firstDay.year == now.year && firstDay.month == now.month;

      if (isCurrentMonth) {
        // 当前月份：使用今天的日期作为分母
        return sum / now.day;
      } else {
        // 历史月份：使用该月的总天数
        final lastDay = DateTime(firstDay.year, firstDay.month + 1, 0).day;
        return sum / lastDay;
      }
    }
    return sum / seriesRaw.length;
  }

  if (seriesRaw is List<({DateTime month, double total})>) {
    if (seriesRaw.isEmpty) return 0;
    final sum = seriesRaw.fold<double>(0, (a, b) => a + b.total);

    // 年度视角：计算已经过去的月份
    if (seriesRaw.isNotEmpty) {
      final firstMonth = seriesRaw.first.month;
      final isCurrentYear = firstMonth.year == now.year;

      if (isCurrentYear) {
        // 当前年份：使用当前月份作为分母
        return sum / now.month;
      } else {
        // 历史年份：使用12个月
        return sum / 12;
      }
    }
    return sum / seriesRaw.length;
  }

  if (seriesRaw is List<({int year, double total})>) {
    if (seriesRaw.isEmpty) return 0;
    final sum = seriesRaw.fold<double>(0, (a, b) => a + b.total);
    // 全部视角：按实际年份数量计算
    return sum / seriesRaw.length;
  }

  return 0;
}

// 打开分类详情页面
void _openCategoryDetail(BuildContext context, int? categoryId,
    String categoryName, DateTime start, DateTime end, String type) {
  if (categoryId == null) return;

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => CategoryDetailPage(
        categoryId: categoryId,
        categoryName: categoryName,
      ),
    ),
  );
}
