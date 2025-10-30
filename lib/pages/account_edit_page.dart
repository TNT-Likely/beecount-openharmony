import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../data/repository.dart';
import '../widgets/ui/ui.dart';
import '../data/db.dart' as db;
import '../l10n/app_localizations.dart';

class AccountEditPage extends ConsumerStatefulWidget {
  final db.Account? account; // null表示新建
  final int ledgerId;

  const AccountEditPage({
    super.key,
    this.account,
    required this.ledgerId,
  });

  @override
  ConsumerState<AccountEditPage> createState() => _AccountEditPageState();
}

class _AccountEditPageState extends ConsumerState<AccountEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _initialBalanceController;
  late String _selectedType;
  bool _saving = false;

  // 预设账户类型
  static const List<String> accountTypes = [
    'cash',
    'bank_card',
    'credit_card',
    'alipay',
    'wechat',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _initialBalanceController = TextEditingController(
      text: widget.account?.initialBalance != null && widget.account!.initialBalance != 0.0
          ? widget.account!.initialBalance.toStringAsFixed(2)
          : '',
    );
    _selectedType = widget.account?.type ?? 'cash';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.account != null;

  IconData _getIconForType(String type) {
    switch (type) {
      case 'cash':
        return Icons.payments_outlined;
      case 'bank_card':
        return Icons.credit_card;
      case 'credit_card':
        return Icons.credit_score;
      case 'alipay':
        return Icons.currency_yuan;  // 使用￥符号代表支付宝
      case 'wechat':
        return Icons.chat;  // 使用聊天图标代表微信
      case 'other':
        return Icons.account_balance_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  String _getTypeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case 'cash':
        return l10n.accountTypeCash;
      case 'bank_card':
        return l10n.accountTypeBankCard;
      case 'credit_card':
        return l10n.accountTypeCreditCard;
      case 'alipay':
        return l10n.accountTypeAlipay;
      case 'wechat':
        return l10n.accountTypeWechat;
      case 'other':
        return l10n.accountTypeOther;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: isEditing ? l10n.accountEditTitle : l10n.accountNewTitle,
            showBack: true,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 账户名称
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accountNameLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: l10n.accountNameHint,
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.accountNameRequired;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 账户类型
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accountTypeLabel,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: accountTypes.map((type) {
                              final isSelected = _selectedType == type;
                              final primaryColor = Theme.of(context).primaryColor;
                              return ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getIconForType(type),
                                      size: 18,
                                      color: isSelected ? Colors.white : primaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(_getTypeLabel(context, type)),
                                  ],
                                ),
                                selected: isSelected,
                                selectedColor: primaryColor,
                                backgroundColor: primaryColor.withValues(alpha: 0.08),
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.white : primaryColor,
                                ),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedType = type;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 初始资金
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accountInitialBalance,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _initialBalanceController,
                            decoration: InputDecoration(
                              hintText: l10n.accountInitialBalanceHint,
                              prefixText: '¥ ',
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value != null && value.trim().isNotEmpty) {
                                final parsed = double.tryParse(value.trim());
                                if (parsed == null) {
                                  return '请输入有效的金额';
                                }
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 保存按钮
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(l10n.commonSave),
                    ),
                  ),

                  // 删除按钮（仅编辑时显示）
                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _saving ? null : _delete,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: Text(l10n.commonDelete),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final repo = ref.read(repositoryProvider);
      final name = _nameController.text.trim();
      final initialBalanceText = _initialBalanceController.text.trim();
      final initialBalance = initialBalanceText.isEmpty ? 0.0 : double.parse(initialBalanceText);

      if (isEditing) {
        await repo.updateAccount(
          widget.account!.id,
          name: name,
          type: _selectedType,
          initialBalance: initialBalance,
        );
      } else {
        await repo.createAccount(
          ledgerId: widget.ledgerId,
          name: name,
          type: _selectedType,
          initialBalance: initialBalance,
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).commonError}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);

    // 检查是否有关联交易
    final repo = ref.read(repositoryProvider);
    final txCount = await repo.getTransactionCountByAccount(widget.account!.id);

    if (txCount > 0) {
      // 有关联交易，提示用户
      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.accountDeleteWarningTitle),
          content: Text(l10n.accountDeleteWarningMessage(txCount)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.commonDelete),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    } else {
      // 没有关联交易，简单确认
      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.commonConfirm),
          content: Text(l10n.accountDeleteConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.commonDelete),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    setState(() => _saving = true);

    try {
      await repo.deleteAccount(widget.account!.id);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.commonError}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
