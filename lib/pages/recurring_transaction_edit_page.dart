import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../providers.dart';
import '../widgets/ui/ui.dart';
import '../data/db.dart';
import '../l10n/app_localizations.dart';
import '../services/recurring_transaction_service.dart';
import '../utils/category_utils.dart';

class RecurringTransactionEditPage extends ConsumerStatefulWidget {
  final RecurringTransaction? recurring;

  const RecurringTransactionEditPage({super.key, this.recurring});

  @override
  ConsumerState<RecurringTransactionEditPage> createState() => _RecurringTransactionEditPageState();
}

class _RecurringTransactionEditPageState extends ConsumerState<RecurringTransactionEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late String _type;
  late RecurringFrequency _frequency;
  late int _interval;
  late DateTime _startDate;
  DateTime? _endDate;
  int? _dayOfMonth;
  Category? _selectedCategory;
  late bool _enabled;

  bool get _isEditing => widget.recurring != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _type = widget.recurring!.type;
      _frequency = RecurringFrequency.fromString(widget.recurring!.frequency);
      _interval = widget.recurring!.interval;
      _startDate = widget.recurring!.startDate;
      _endDate = widget.recurring!.endDate;
      _dayOfMonth = widget.recurring!.dayOfMonth;
      _enabled = widget.recurring!.enabled;
      _amountController.text = widget.recurring!.amount.toStringAsFixed(2);
      _noteController.text = widget.recurring!.note ?? '';
      _loadCategoryAndAccount();
    } else {
      _type = 'expense';
      _frequency = RecurringFrequency.monthly;
      _interval = 1;
      _startDate = DateTime.now();
      _dayOfMonth = DateTime.now().day;
      _enabled = true;
    }
  }

  Future<void> _loadCategoryAndAccount() async {
    if (_isEditing) {
      final db = ref.read(databaseProvider);

      final category = await (db.select(db.categories)
            ..where((c) => c.id.equals(widget.recurring!.categoryId)))
          .getSingleOrNull();

      setState(() {
        _selectedCategory = category;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: _isEditing
                ? l10n.recurringTransactionEdit
                : l10n.recurringTransactionAdd,
            showBack: true,
            actions: _isEditing ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteRecurringTransaction,
              ),
            ] : null,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Type selection
                  _buildTypeSelector(l10n),
                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: l10n.homeExpense,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.commonError;
                      }
                      if (double.tryParse(value) == null) {
                        return l10n.commonError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category selection
                  _buildCategorySelector(l10n),
                  const SizedBox(height: 16),

                  // Frequency
                  _buildFrequencySelector(l10n),
                  const SizedBox(height: 16),

                  // Interval
                  if (_frequency != RecurringFrequency.daily)
                    _buildIntervalSelector(l10n),
                  if (_frequency != RecurringFrequency.daily)
                    const SizedBox(height: 16),

                  // Day of month (for monthly)
                  if (_frequency == RecurringFrequency.monthly)
                    _buildDayOfMonthSelector(l10n),
                  if (_frequency == RecurringFrequency.monthly)
                    const SizedBox(height: 16),

                  // Start date
                  _buildDateField(
                    label: l10n.recurringTransactionStartDate,
                    date: _startDate,
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(height: 16),

                  // End date
                  _buildDateField(
                    label: l10n.recurringTransactionEndDate,
                    date: _endDate,
                    onTap: () => _selectDate(context, false),
                    allowClear: true,
                    onClear: () => setState(() => _endDate = null),
                  ),
                  const SizedBox(height: 16),

                  // Note
                  TextFormField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: l10n.commonNoteHint,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Enabled switch
                  Card(
                    child: SwitchListTile(
                      title: Text(l10n.recurringTransactionEnabled),
                      subtitle: Text(_enabled
                        ? l10n.recurringTransactionEnabled
                        : l10n.recurringTransactionDisabled),
                      value: _enabled,
                      onChanged: (value) {
                        setState(() {
                          _enabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 底部保存按钮
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _saveRecurringTransaction,
              child: Text(l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: Text(l10n.categoryExpense),
            value: 'expense',
            groupValue: _type,
            onChanged: (value) {
              setState(() {
                _type = value!;
                _selectedCategory = null; // Reset category when type changes
              });
            },
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: Text(l10n.categoryIncome),
            value: 'income',
            groupValue: _type,
            onChanged: (value) {
              setState(() {
                _type = value!;
                _selectedCategory = null; // Reset category when type changes
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(AppLocalizations l10n) {
    return InkWell(
      onTap: () => _selectCategory(),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.categoryTitle,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          _selectedCategory != null
              ? CategoryUtils.getDisplayName(_selectedCategory!.name, context)
              : l10n.commonSearch,
        ),
      ),
    );
  }

  Widget _buildFrequencySelector(AppLocalizations l10n) {
    String frequencyLabel;
    switch (_frequency) {
      case RecurringFrequency.daily:
        frequencyLabel = l10n.recurringTransactionDaily;
        break;
      case RecurringFrequency.weekly:
        frequencyLabel = l10n.recurringTransactionWeekly;
        break;
      case RecurringFrequency.monthly:
        frequencyLabel = l10n.recurringTransactionMonthly;
        break;
      case RecurringFrequency.yearly:
        frequencyLabel = l10n.recurringTransactionYearly;
        break;
    }

    return InkWell(
      onTap: () async {
        final result = await showWheelPicker<RecurringFrequency>(
          context,
          initial: _frequency,
          items: RecurringFrequency.values,
          labelBuilder: (freq) {
            switch (freq) {
              case RecurringFrequency.daily:
                return l10n.recurringTransactionDaily;
              case RecurringFrequency.weekly:
                return l10n.recurringTransactionWeekly;
              case RecurringFrequency.monthly:
                return l10n.recurringTransactionMonthly;
              case RecurringFrequency.yearly:
                return l10n.recurringTransactionYearly;
            }
          },
          title: l10n.recurringTransactionFrequency,
        );

        if (result != null) {
          setState(() {
            _frequency = result;
            if (_frequency == RecurringFrequency.daily) {
              _interval = 1;
            }
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.recurringTransactionFrequency,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(frequencyLabel),
            const Icon(Icons.arrow_drop_down, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalSelector(AppLocalizations l10n) {
    String intervalLabel;
    switch (_frequency) {
      case RecurringFrequency.daily:
        intervalLabel = l10n.recurringTransactionEveryNDays(_interval);
        break;
      case RecurringFrequency.weekly:
        intervalLabel = l10n.recurringTransactionEveryNWeeks(_interval);
        break;
      case RecurringFrequency.monthly:
        intervalLabel = l10n.recurringTransactionEveryNMonths(_interval);
        break;
      case RecurringFrequency.yearly:
        intervalLabel = l10n.recurringTransactionEveryNYears(_interval);
        break;
    }

    return InkWell(
      onTap: () async {
        final result = await showWheelPicker<int>(
          context,
          initial: _interval,
          items: List.generate(12, (index) => index + 1),
          labelBuilder: (i) {
            switch (_frequency) {
              case RecurringFrequency.daily:
                return l10n.recurringTransactionEveryNDays(i);
              case RecurringFrequency.weekly:
                return l10n.recurringTransactionEveryNWeeks(i);
              case RecurringFrequency.monthly:
                return l10n.recurringTransactionEveryNMonths(i);
              case RecurringFrequency.yearly:
                return l10n.recurringTransactionEveryNYears(i);
            }
          },
          title: l10n.recurringTransactionInterval,
        );

        if (result != null) {
          setState(() {
            _interval = result;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.recurringTransactionInterval,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(intervalLabel),
            const Icon(Icons.arrow_drop_down, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDayOfMonthSelector(AppLocalizations l10n) {
    return InkWell(
      onTap: () async {
        final result = await showWheelPicker<int>(
          context,
          initial: _dayOfMonth ?? 1,
          items: List.generate(31, (index) => index + 1),
          labelBuilder: (day) => '$day',
          title: l10n.recurringTransactionDayOfMonth,
        );

        if (result != null) {
          setState(() {
            _dayOfMonth = result;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.recurringTransactionDayOfMonth,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_dayOfMonth ?? 1}'),
            const Icon(Icons.arrow_drop_down, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    bool allowClear = false,
    VoidCallback? onClear,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: allowClear && date != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
        ),
        child: Text(
          date != null
              ? DateFormat.yMd().format(date)
              : AppLocalizations.of(context)!.recurringTransactionNoEndDate,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final date = await showWheelDatePicker(
      context,
      initial: isStartDate ? _startDate : (_endDate ?? DateTime.now()),
      minDate: DateTime(2000),
      maxDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        if (isStartDate) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  Future<void> _selectCategory() async {
    final db = ref.read(databaseProvider);
    final categories = await (db.select(db.categories)
          ..where((c) => c.kind.equals(_type)))
        .get();

    if (!mounted) return;

    final selected = await showDialog<Category>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.categoryTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(CategoryUtils.getDisplayName(category.name, context)),
                onTap: () => Navigator.of(context).pop(category),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedCategory = selected;
      });
    }
  }

  Future<void> _saveRecurringTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.commonError)),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    final service = RecurringTransactionService(db);
    final ledgerId = ref.read(currentLedgerIdProvider);

    final companion = RecurringTransactionsCompanion(
      ledgerId: drift.Value(ledgerId),
      type: drift.Value(_type),
      amount: drift.Value(double.parse(_amountController.text)),
      categoryId: drift.Value(_selectedCategory!.id),
      accountId: const drift.Value(null),
      note: drift.Value(_noteController.text.isEmpty ? null : _noteController.text),
      frequency: drift.Value(_frequency.value),
      interval: drift.Value(_interval),
      dayOfMonth: drift.Value(_dayOfMonth),
      startDate: drift.Value(_startDate),
      endDate: drift.Value(_endDate),
      enabled: drift.Value(_enabled),
      updatedAt: drift.Value(DateTime.now()),
    );

    try {
      if (_isEditing) {
        await service.updateRecurringTransaction(widget.recurring!.id, companion);
      } else {
        await service.createRecurringTransaction(companion);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.commonError}: $e')),
        );
      }
    }
  }

  Future<void> _deleteRecurringTransaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.commonDelete),
        content: Text(AppLocalizations.of(context)!.recurringTransactionDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final db = ref.read(databaseProvider);
      final service = RecurringTransactionService(db);
      await service.deleteRecurringTransaction(widget.recurring!.id);

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
