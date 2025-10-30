import 'package:drift/drift.dart';
import '../data/db.dart';

/// 重复交易频率枚举
enum RecurringFrequency {
  daily('daily'),      // 每天
  weekly('weekly'),    // 每周
  monthly('monthly'),  // 每月
  yearly('yearly');    // 每年

  final String value;
  const RecurringFrequency(this.value);

  static RecurringFrequency fromString(String value) {
    return RecurringFrequency.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RecurringFrequency.monthly,
    );
  }
}

/// 重复交易服务
class RecurringTransactionService {
  final BeeDatabase db;

  RecurringTransactionService(this.db);

  /// 获取指定账本的所有重复交易
  Future<List<RecurringTransaction>> getRecurringTransactions(int ledgerId) {
    return (db.select(db.recurringTransactions)
          ..where((t) => t.ledgerId.equals(ledgerId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// 获取指定账本的启用的重复交易
  Future<List<RecurringTransaction>> getEnabledRecurringTransactions(int ledgerId) {
    return (db.select(db.recurringTransactions)
          ..where((t) => t.ledgerId.equals(ledgerId) & t.enabled.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// 创建重复交易
  Future<int> createRecurringTransaction(RecurringTransactionsCompanion data) {
    return db.into(db.recurringTransactions).insert(data);
  }

  /// 更新重复交易
  Future<int> updateRecurringTransaction(int id, RecurringTransactionsCompanion data) {
    return (db.update(db.recurringTransactions)..where((t) => t.id.equals(id)))
        .write(data);
  }

  /// 删除重复交易
  Future<int> deleteRecurringTransaction(int id) {
    return (db.delete(db.recurringTransactions)..where((t) => t.id.equals(id)))
        .go();
  }

  /// 启用/禁用重复交易
  Future<int> toggleRecurringTransaction(int id, bool enabled) {
    return (db.update(db.recurringTransactions)..where((t) => t.id.equals(id)))
        .write(RecurringTransactionsCompanion(enabled: Value(enabled)));
  }

  /// 计算下一次应该生成交易的日期
  DateTime? calculateNextDate(RecurringTransaction recurring) {
    final now = DateTime.now();
    final lastGenerated = recurring.lastGeneratedDate;
    final frequency = RecurringFrequency.fromString(recurring.frequency);
    final interval = recurring.interval;

    // 如果有结束日期且已过期，返回null
    if (recurring.endDate != null && now.isAfter(recurring.endDate!)) {
      return null;
    }

    // 基准日期：最后生成日期 或 开始日期
    final baseDate = lastGenerated ?? recurring.startDate;

    DateTime nextDate;
    switch (frequency) {
      case RecurringFrequency.daily:
        nextDate = baseDate.add(Duration(days: interval));
        break;

      case RecurringFrequency.weekly:
        nextDate = baseDate.add(Duration(days: 7 * interval));
        break;

      case RecurringFrequency.monthly:
        // 月度重复：使用指定的日期
        final targetDay = recurring.dayOfMonth ?? baseDate.day;
        var year = baseDate.year;
        var month = baseDate.month + interval;

        // 处理月份溢出
        while (month > 12) {
          month -= 12;
          year += 1;
        }

        // 处理不存在的日期（如2月30日）
        final daysInMonth = DateTime(year, month + 1, 0).day;
        final day = targetDay > daysInMonth ? daysInMonth : targetDay;

        nextDate = DateTime(year, month, day);
        break;

      case RecurringFrequency.yearly:
        // 年度重复
        final targetMonth = recurring.monthOfYear ?? baseDate.month;
        final targetDay = recurring.dayOfMonth ?? baseDate.day;
        var year = baseDate.year + interval;

        // 处理闰年2月29日
        final daysInMonth = DateTime(year, targetMonth + 1, 0).day;
        final day = targetDay > daysInMonth ? daysInMonth : targetDay;

        nextDate = DateTime(year, targetMonth, day);
        break;
    }

    // 如果下一次日期还没到，返回null
    if (nextDate.isAfter(now)) {
      return null;
    }

    // 如果超过结束日期，返回null
    if (recurring.endDate != null && nextDate.isAfter(recurring.endDate!)) {
      return null;
    }

    return nextDate;
  }

  /// 生成待处理的交易记录
  Future<List<Transaction>> generatePendingTransactions() async {
    final ledgers = await db.select(db.ledgers).get();
    final generatedTransactions = <Transaction>[];

    for (final ledger in ledgers) {
      final recurringList = await getEnabledRecurringTransactions(ledger.id);

      for (final recurring in recurringList) {
        // 循环生成所有缺失的交易记录
        var currentRecurring = recurring;
        while (true) {
          final nextDate = calculateNextDate(currentRecurring);
          if (nextDate == null) break;

          // 生成交易记录
          final transactionId = await db.into(db.transactions).insert(
                TransactionsCompanion.insert(
                  ledgerId: currentRecurring.ledgerId,
                  type: currentRecurring.type,
                  amount: currentRecurring.amount,
                  categoryId: Value(currentRecurring.categoryId),
                  accountId: Value(currentRecurring.accountId),
                  happenedAt: Value(nextDate),
                  note: Value(currentRecurring.note),
                  recurringId: Value(currentRecurring.id),
                ),
              );

          // 更新最后生成日期
          await (db.update(db.recurringTransactions)
                ..where((t) => t.id.equals(currentRecurring.id)))
              .write(RecurringTransactionsCompanion(
            lastGeneratedDate: Value(nextDate),
            updatedAt: Value(DateTime.now()),
          ));

          // 获取生成的交易
          final transaction = await (db.select(db.transactions)
                ..where((t) => t.id.equals(transactionId)))
              .getSingle();
          generatedTransactions.add(transaction);

          // 重新读取更新后的重复交易记录，用于下一次循环
          currentRecurring = await (db.select(db.recurringTransactions)
                ..where((t) => t.id.equals(currentRecurring.id)))
              .getSingle();
        }
      }
    }

    return generatedTransactions;
  }

  /// 获取重复交易的描述文字
  String getFrequencyDescription(
    RecurringTransaction recurring,
    String Function(RecurringFrequency, int) translator,
  ) {
    final frequency = RecurringFrequency.fromString(recurring.frequency);
    return translator(frequency, recurring.interval);
  }

  /// 获取下一次生成时间的描述
  String? getNextGenerationDescription(
    RecurringTransaction recurring,
    String Function(DateTime) formatter,
  ) {
    final nextDate = calculateNextDate(recurring);
    if (nextDate == null) return null;
    return formatter(nextDate);
  }
}
