import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../widgets/ui/ui.dart';
import '../data/db.dart' as db;
import '../l10n/app_localizations.dart';
import 'account_edit_page.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'cash':
        return Icons.payments_outlined;
      case 'bank_card':
        return Icons.credit_card;
      case 'credit_card':
        return Icons.credit_score;
      case 'alipay':
        return Icons.currency_yuan;
      case 'wechat':
        return Icons.chat;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ledgerId = ref.watch(currentLedgerIdProvider);
    final accountsAsync = ref.watch(accountsStreamProvider(ledgerId));
    final accountFeatureAsync = ref.watch(accountFeatureEnabledProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.accountsTitle,
            showBack: true,
            actions: [
              IconButton(
                onPressed: () => _addAccount(context, ledgerId),
                icon: const Icon(Icons.add),
                tooltip: l10n.accountAddTooltip,
              ),
            ],
          ),
          Expanded(
            child: accountsAsync.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.accountsEmptyMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _addAccount(context, ledgerId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.accountAddButton),
                        ),
                      ],
                    ),
                  );
                }

                return FutureBuilder<Map<int, double>>(
                  future: ref.read(repositoryProvider).getAllAccountBalances(ledgerId),
                  builder: (context, balanceSnapshot) {
                    final balances = balanceSnapshot.data ?? {};

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: accounts.length + 1, // +1 for the switch tile
                      itemBuilder: (context, index) {
                        // 第一项显示功能开关
                        if (index == 0) {
                          return accountFeatureAsync.when(
                            data: (enabled) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: SwitchListTile(
                                  title: Text(
                                    l10n.accountsEnableFeature,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(l10n.accountsFeatureDescription),
                                  value: enabled,
                                  activeColor: primaryColor,
                                  onChanged: (value) async {
                                    await ref.read(accountFeatureSetterProvider).setEnabled(value);
                                    ref.invalidate(accountFeatureEnabledProvider);
                                  },
                                ),
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          );
                        }

                        // 账户列表项
                        final account = accounts[index - 1];
                        final balance = balances[account.id] ?? 0.0;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: primaryColor.withValues(alpha: 0.12),
                              child: Icon(
                                _getIconForType(account.type),
                                color: primaryColor,
                              ),
                            ),
                            title: Text(
                              account.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(_getTypeLabel(context, account.type)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '¥${balance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: balance >= 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                                Text(
                                  l10n.accountBalance,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _editAccount(context, account, ledgerId),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('${l10n.commonError}: $err'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addAccount(BuildContext context, int ledgerId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccountEditPage(ledgerId: ledgerId),
      ),
    );
  }

  void _editAccount(BuildContext context, db.Account account, int ledgerId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AccountEditPage(
          account: account,
          ledgerId: ledgerId,
        ),
      ),
    );
  }
}
