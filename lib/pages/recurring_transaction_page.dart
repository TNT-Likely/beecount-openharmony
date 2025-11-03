import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers.dart';
import '../widgets/ui/ui.dart';
import '../widgets/biz/amount_text.dart';
import '../data/db.dart';
import '../l10n/app_localizations.dart';
import '../services/recurring_transaction_service.dart';
import '../utils/category_utils.dart';
import 'recurring_transaction_edit_page.dart';

class RecurringTransactionPage extends ConsumerWidget {
  const RecurringTransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerId = ref.watch(currentLedgerIdProvider);
    final recurringTransactionsAsync = ref.watch(recurringTransactionsProvider(ledgerId));

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: AppLocalizations.of(context)!.recurringTransactionTitle,
            showBack: true,
            actions: [
              IconButton(
                onPressed: () => _addRecurringTransaction(context, ref),
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context)!.recurringTransactionAdd,
              ),
            ],
          ),
          Expanded(
            child: recurringTransactionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
              data: (recurringTransactions) {
                if (recurringTransactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.repeat,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.recurringTransactionEmpty,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.recurringTransactionEmptyHint,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recurringTransactions.length,
                  itemBuilder: (context, index) {
                    final recurring = recurringTransactions[index];
                    return _RecurringTransactionCard(recurring: recurring);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addRecurringTransaction(BuildContext context, WidgetRef ref) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const RecurringTransactionEditPage(),
      ),
    );
    // Refresh the list
    ref.invalidate(recurringTransactionsProvider);
  }
}

class _RecurringTransactionCard extends ConsumerWidget {
  final RecurringTransaction recurring;

  const _RecurringTransactionCard({required this.recurring});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final service = RecurringTransactionService(db);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecurringTransactionEditPage(recurring: recurring),
            ),
          );
          // Refresh the list
          ref.invalidate(recurringTransactionsProvider);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Type icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: recurring.type == 'expense'
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      recurring.type == 'expense'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: recurring.type == 'expense' ? Colors.red : Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Category and amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<Category?>(
                          future: _getCategory(ref, recurring.categoryId),
                          builder: (context, snapshot) {
                            final categoryName = snapshot.data?.name ?? '';
                            return Text(
                              CategoryUtils.getDisplayName(categoryName, context),
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getFrequencyDescription(context, service),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AmountText(
                        value: recurring.type == 'expense' ? -recurring.amount : recurring.amount,
                        signed: true,
                        decimals: 2,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: recurring.type == 'expense' ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: recurring.enabled
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recurring.enabled
                              ? AppLocalizations.of(context)!.recurringTransactionEnabled
                              : AppLocalizations.of(context)!.recurringTransactionDisabled,
                          style: TextStyle(
                            fontSize: 10,
                            color: recurring.enabled ? Colors.green[700] : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (recurring.note != null && recurring.note!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  recurring.note!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${AppLocalizations.of(context)!.recurringTransactionStartDate}: ${DateFormat.yMd().format(recurring.startDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (recurring.endDate != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      '→ ${DateFormat.yMd().format(recurring.endDate!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
              if (recurring.lastGeneratedDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.history, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${AppLocalizations.of(context)!.recurringTransactionNextGeneration}: ${DateFormat.yMd().format(recurring.lastGeneratedDate!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getFrequencyDescription(BuildContext context, RecurringTransactionService service) {
    final l10n = AppLocalizations.of(context)!;
    final frequency = RecurringFrequency.fromString(recurring.frequency);
    final interval = recurring.interval;

    if (interval == 1) {
      switch (frequency) {
        case RecurringFrequency.daily:
          return l10n.recurringTransactionDaily;
        case RecurringFrequency.weekly:
          return l10n.recurringTransactionWeekly;
        case RecurringFrequency.monthly:
          return l10n.recurringTransactionMonthly;
        case RecurringFrequency.yearly:
          return l10n.recurringTransactionYearly;
      }
    } else {
      switch (frequency) {
        case RecurringFrequency.daily:
          return l10n.recurringTransactionEveryNDays(interval);
        case RecurringFrequency.weekly:
          return l10n.recurringTransactionEveryNWeeks(interval);
        case RecurringFrequency.monthly:
          return l10n.recurringTransactionEveryNMonths(interval);
        case RecurringFrequency.yearly:
          return l10n.recurringTransactionEveryNYears(interval);
      }
    }
  }

  Future<Category?> _getCategory(WidgetRef ref, int categoryId) async {
    final db = ref.read(databaseProvider);
    final result = await (db.select(db.categories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();
    return result;
  }
}
