import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../providers.dart';
import '../providers/database_providers.dart';
import '../widgets/ui/ui.dart';
import '../data/db.dart' as db;
import '../services/category_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/category_utils.dart';
import 'category_edit_page.dart';

class CategoryManagePage extends ConsumerStatefulWidget {
  const CategoryManagePage({super.key});
  
  @override
  ConsumerState<CategoryManagePage> createState() => _CategoryManagePageState();
}

class _CategoryManagePageState extends ConsumerState<CategoryManagePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 重新构建以更新按钮状态
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesWithCountAsync = ref.watch(categoriesWithCountProvider);

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: AppLocalizations.of(context)!.categoryTitle,
            showBack: true,
            actions: [
              IconButton(
                onPressed: () => _addCategory(),
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context)!.categoryNew,
              ),
            ],
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.categoryExpense),
              Tab(text: AppLocalizations.of(context)!.categoryIncome),
            ],
          ),
          Expanded(
            child: categoriesWithCountAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text(AppLocalizations.of(context)!.categoryLoadFailed(error.toString()))),
              data: (categoriesWithCount) {
                return Column(
                  children: [
                    // 提示信息
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.blue[50],
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.categoryReorderTip,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _CategoryGridView(
                            categoriesWithCount: categoriesWithCount,
                            kind: 'expense',
                          ),
                          _CategoryGridView(
                            categoriesWithCount: categoriesWithCount,
                            kind: 'income',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _addCategory() async {
    final kind = _tabController.index == 0 ? 'expense' : 'income';
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryEditPage(kind: kind),
      ),
    );

    // 响应式provider会自动更新，无需手动刷新
  }
}

class _CategoryGridView extends ConsumerStatefulWidget {
  final List<({db.Category category, int transactionCount})> categoriesWithCount;
  final String kind;

  const _CategoryGridView({
    required this.categoriesWithCount,
    required this.kind,
  });

  @override
  ConsumerState<_CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends ConsumerState<_CategoryGridView> {
  late List<({db.Category category, int transactionCount, bool isDefault})> _categories;

  @override
  void initState() {
    super.initState();
    _buildCategories();
  }

  @override
  void didUpdateWidget(_CategoryGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categoriesWithCount != oldWidget.categoriesWithCount ||
        widget.kind != oldWidget.kind) {
      _buildCategories();
    }
  }

  void _buildCategories() {
    // 获取默认分类名单
    final defaultNames = CategoryService.getDefaultCategoryNames(widget.kind);

    // 获取当前类型的所有分类
    final dbCategories = widget.categoriesWithCount
        .where((item) => item.category.kind == widget.kind)
        .toList();

    final allCategoryItems = <({db.Category category, int transactionCount, bool isDefault})>[];

    // 添加数据库中的分类
    for (final item in dbCategories) {
      allCategoryItems.add((
        category: item.category,
        transactionCount: item.transactionCount,
        isDefault: defaultNames.contains(item.category.name),
      ));
    }

    // 按 sortOrder 排序
    allCategoryItems.sort((a, b) => a.category.sortOrder.compareTo(b.category.sortOrder));

    _categories = allCategoryItems;
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    setState(() {
      final item = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, item);
    });

    // 保存新的排序到数据库（批量更新）
    final database = ref.read(databaseProvider);
    await database.transaction(() async {
      for (var i = 0; i < _categories.length; i++) {
        final category = _categories[i].category;
        await (database.update(database.categories)
              ..where((c) => c.id.equals(category.id)))
            .write(db.CategoriesCompanion(sortOrder: drift.Value(i)));
      }
    });

    // 刷新数据
    ref.invalidate(categoriesWithCountProvider);
  }
  
  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.categoryEmpty,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // 使用可拖拽的网格视图
    return ReorderableGridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _categories.length,
      onReorder: _onReorder,
      dragWidgetBuilder: (index, child) {
        final item = _categories[index];
        return Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CategoryService.getCategoryIcon(item.category.icon),
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          CategoryUtils.getDisplayName(item.category.name, context),
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppLocalizations.of(context)!.categoryMigrationTransactionLabel(item.transactionCount),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemBuilder: (context, index) {
        final item = _categories[index];
        return _CategoryCard(
          key: ValueKey(item.category.id != -1 ? item.category.id : 'virtual_${item.category.name}'),
          category: item.category,
          transactionCount: item.transactionCount,
          isDefault: item.isDefault,
        );
      },
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  final db.Category category;
  final int transactionCount;
  final bool isDefault;

  const _CategoryCard({
    super.key,
    required this.category,
    required this.transactionCount,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CategoryEditPage(
              category: category,
              kind: category.kind,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CategoryService.getCategoryIcon(category.icon),
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      CategoryUtils.getDisplayName(category.name, context),
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.categoryMigrationTransactionLabel(transactionCount),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
