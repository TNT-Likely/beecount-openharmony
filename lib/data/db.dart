import 'dart:io';

import 'package:drift/drift.dart';
import '../services/category_service.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

// --- Tables ---

class Ledgers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ledgerId => integer()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('cash'))();
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get kind => text()(); // expense / income
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))(); // 排序顺序，数字越小越靠前
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ledgerId => integer()();
  TextColumn get type => text()(); // expense / income / transfer
  RealColumn get amount => real()();
  IntColumn get categoryId => integer().nullable()();
  IntColumn get accountId => integer().nullable()();
  IntColumn get toAccountId => integer().nullable()();
  DateTimeColumn get happenedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  IntColumn get recurringId => integer().nullable()(); // 关联到重复交易模板
}

class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ledgerId => integer()();
  TextColumn get type => text()(); // expense / income
  RealColumn get amount => real()();
  IntColumn get categoryId => integer()();
  IntColumn get accountId => integer().nullable()();
  TextColumn get note => text().nullable()();

  // 重复规则
  TextColumn get frequency => text()(); // daily / weekly / monthly / yearly
  IntColumn get interval => integer().withDefault(const Constant(1))(); // 间隔（每1天、每2周等）
  IntColumn get dayOfMonth => integer().nullable()(); // 月的第几天（1-31）
  IntColumn get dayOfWeek => integer().nullable()(); // 周几（1=周一, 7=周日）
  IntColumn get monthOfYear => integer().nullable()(); // 哪个月（1-12，用于yearly）

  // 时间范围
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()(); // 为空表示永久
  DateTimeColumn get lastGeneratedDate => dateTime().nullable()(); // 最后一次生成交易的日期

  // 状态
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Ledgers, Accounts, Categories, Transactions, RecurringTransactions])
class BeeDatabase extends _$BeeDatabase {
  BeeDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        // 添加 sortOrder 字段（使用原始 SQL，因为此时代码还未生成）
        await customStatement('ALTER TABLE categories ADD COLUMN sort_order INTEGER NOT NULL DEFAULT 0;');

        // 为现有分类设置默认的 sortOrder（按 id 顺序）
        await customStatement('''
          UPDATE categories
          SET sort_order = (
            SELECT COUNT(*)
            FROM categories AS c2
            WHERE c2.id <= categories.id
          ) - 1;
        ''');
      }
      if (from < 3) {
        // 创建重复交易表
        await migrator.createTable(recurringTransactions);

        // 为 transactions 表添加 recurring_id 字段
        await customStatement('ALTER TABLE transactions ADD COLUMN recurring_id INTEGER;');
      }
      if (from < 4) {
        // 为 accounts 表添加 initial_balance 字段
        await customStatement('ALTER TABLE accounts ADD COLUMN initial_balance REAL NOT NULL DEFAULT 0.0;');
      }
    },
  );

  // Seed minimal data
  Future<void> ensureSeed() async {
    final count = await (select(ledgers).get()).then((v) => v.length);
    if (count == 0) {
      final ledgerId =
          await into(ledgers).insert(LedgersCompanion.insert(name: 'Default Ledger')); // Will be displayed with localization in UI
      await into(accounts)
          .insert(AccountsCompanion.insert(ledgerId: ledgerId, name: 'Cash')); // Will be displayed with localization in UI
    }
    // 总是确保默认分类存在
    const expense = 'expense';
    const income = 'income';
    final defaultExpense = CategoryService.defaultExpenseCategories;
    final defaultIncome = CategoryService.defaultIncomeCategories;

    // 轻量迁移：将历史 "房租" 重命名为 "住房"（仅当不存在同名"住房"时）
    try {
      final old = await (select(categories)
            ..where((c) => c.name.equals('房租') & c.kind.equals(expense)))
          .getSingleOrNull();
      final hasNew = await (select(categories)
            ..where((c) => c.name.equals('住房') & c.kind.equals(expense)))
          .getSingleOrNull();
      if (old != null && hasNew == null) {
        await (update(categories)..where((c) => c.id.equals(old.id)))
            .write(CategoriesCompanion(name: const Value('住房')));
      }
    } catch (_) {}

    // 去重：合并历史相似分类到统一分类
    try {
      // 定义合并策略：目标分类 -> 需要合并的旧分类列表
      final mergeStrategies = <String, List<String>>{
        '通讯': ['话费', '宽带', '流量', '电话', '网络', '通信', '手机'],
        '旅行': ['旅游', '出行'],
        '服装': ['服饰', '衣服', '衣物'],
        '购物': ['网购', '网络购物'],
        '饮料': ['奶茶', '茶饮'],
        '水果': ['奶茶水果'], // 特殊处理：奶茶水果需要拆分
      };

      for (final targetName in mergeStrategies.keys) {
        final oldNames = mergeStrategies[targetName]!;

        // 查找是否已存在目标分类
        final targetCategory = await (select(categories)
              ..where((c) => c.name.equals(targetName) & c.kind.equals(expense)))
            .getSingleOrNull();

        if (targetCategory != null) {
          // 如果存在目标分类，将其他相关分类的交易迁移过来，然后删除重复分类
          for (final oldName in oldNames) {
            final oldCategory = await (select(categories)
                  ..where((c) => c.name.equals(oldName) & c.kind.equals(expense)))
                .getSingleOrNull();

            if (oldCategory != null) {
              // 迁移交易记录
              await (update(transactions)
                    ..where((t) => t.categoryId.equals(oldCategory.id)))
                  .write(TransactionsCompanion(
                      categoryId: Value(targetCategory.id)));

              // 删除旧分类
              await (delete(categories)..where((c) => c.id.equals(oldCategory.id))).go();
            }
          }
        }
      }

      // 特殊处理：奶茶水果 -> 分别合并到 饮料 和 水果
      final milkTeaFruitCategory = await (select(categories)
            ..where((c) => c.name.equals('奶茶水果') & c.kind.equals(expense)))
          .getSingleOrNull();

      if (milkTeaFruitCategory != null) {
        // 查找饮料分类
        final drinkCategory = await (select(categories)
              ..where((c) => c.name.equals('饮料') & c.kind.equals(expense)))
            .getSingleOrNull();

        if (drinkCategory != null) {
          // 将奶茶水果的交易迁移到饮料分类（默认策略）
          await (update(transactions)
                ..where((t) => t.categoryId.equals(milkTeaFruitCategory.id)))
              .write(TransactionsCompanion(
                  categoryId: Value(drinkCategory.id)));

          // 删除奶茶水果分类
          await (delete(categories)..where((c) => c.id.equals(milkTeaFruitCategory.id))).go();
        }
      }
    } catch (_) {}

    // 为分类名称分配默认图标和排序顺序

    // 处理支出分类
    for (var i = 0; i < defaultExpense.length; i++) {
      final name = defaultExpense[i];
      final existingCategories = await (select(categories)
            ..where((c) => c.name.equals(name) & c.kind.equals(expense)))
          .get();
      if (existingCategories.isEmpty) {
        // 新增默认分类，使用列表索引作为 sortOrder
        await into(categories).insert(CategoriesCompanion.insert(
            name: name,
            kind: expense,
            icon: Value(CategoryService.getDefaultCategoryIcon(name, expense)),
            sortOrder: Value(i)));
      } else {
        // 更新现有分类的图标（但不覆盖用户自定义的 sortOrder）
        for (final category in existingCategories) {
          final correctIcon = CategoryService.getDefaultCategoryIcon(name, expense);
          // 只有当图标不正确时才更新
          if (category.icon != correctIcon) {
            await (update(categories)..where((c) => c.id.equals(category.id)))
                .write(CategoriesCompanion(icon: Value(correctIcon)));
          }
          // 如果 sortOrder 是 0，可能是初次创建，更新为正确的顺序
          if (category.sortOrder == 0) {
            await (update(categories)..where((c) => c.id.equals(category.id)))
                .write(CategoriesCompanion(sortOrder: Value(i)));
          }
        }
      }
    }

    // 处理收入分类
    for (var i = 0; i < defaultIncome.length; i++) {
      final name = defaultIncome[i];
      final existingCategories = await (select(categories)
            ..where((c) => c.name.equals(name) & c.kind.equals(income)))
          .get();
      if (existingCategories.isEmpty) {
        // 新增默认分类，使用列表索引作为 sortOrder
        await into(categories).insert(CategoriesCompanion.insert(
            name: name,
            kind: income,
            icon: Value(CategoryService.getDefaultCategoryIcon(name, income)),
            sortOrder: Value(i)));
      } else {
        // 更新现有分类的图标（但不覆盖用户自定义的 sortOrder）
        for (final category in existingCategories) {
          final correctIcon = CategoryService.getDefaultCategoryIcon(name, income);
          // 只有当图标不正确时才更新
          if (category.icon != correctIcon) {
            await (update(categories)..where((c) => c.id.equals(category.id)))
                .write(CategoriesCompanion(icon: Value(correctIcon)));
          }
          // 如果 sortOrder 是 0，可能是初次创建，更新为正确的顺序
          if (category.sortOrder == 0) {
            await (update(categories)..where((c) => c.id.equals(category.id)))
                .write(CategoriesCompanion(sortOrder: Value(i)));
          }
        }
      }
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'beecount.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
