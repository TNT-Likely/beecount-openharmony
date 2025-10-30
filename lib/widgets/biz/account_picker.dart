import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import '../../data/db.dart';
import '../../l10n/app_localizations.dart';

/// 账户选择器数据模型
class AccountOption {
  final int? id;
  final String name;
  final String type;
  final IconData icon;

  AccountOption({
    this.id,
    required this.name,
    required this.type,
    required this.icon,
  });
}

/// 账户选择器组件（使用滚轮样式）
class AccountPicker extends ConsumerStatefulWidget {
  final int? selectedAccountId;
  final bool allowNull;

  const AccountPicker({
    super.key,
    this.selectedAccountId,
    this.allowNull = true,
  });

  @override
  ConsumerState<AccountPicker> createState() => _AccountPickerState();

  /// 显示账户选择器底部弹窗
  static Future<int?> show(
    BuildContext context, {
    int? selectedAccountId,
    bool allowNull = true,
  }) async {
    return showModalBottomSheet<int?>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => AccountPicker(
        selectedAccountId: selectedAccountId,
        allowNull: allowNull,
      ),
    );
  }
}

class _AccountPickerState extends ConsumerState<AccountPicker> {
  FixedExtentScrollController? _controller;
  int _selectedIndex = 0;
  List<AccountOption> _options = [];
  bool _initialized = false;

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

  void _buildOptions(List<Account> accounts) {
    if (_initialized) return;

    _options = [];

    // 添加"不选择账户"选项
    if (widget.allowNull) {
      _options.add(AccountOption(
        id: null,
        name: AppLocalizations.of(context).accountNone,
        type: 'none',
        icon: Icons.remove,
      ));
    }

    // 添加账户列表
    for (final account in accounts) {
      _options.add(AccountOption(
        id: account.id,
        name: account.name,
        type: account.type,
        icon: _getIconForType(account.type),
      ));
    }

    // 查找选中项的索引
    _selectedIndex = _options.indexWhere(
      (option) => option.id == widget.selectedAccountId,
    );
    if (_selectedIndex < 0) _selectedIndex = 0;

    // 初始化滚动控制器
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
    _initialized = true;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ledgerId = ref.watch(currentLedgerIdProvider);
    final accountsAsync = ref.watch(accountsStreamProvider(ledgerId));
    final primaryColor = Theme.of(context).primaryColor;

    return accountsAsync.when(
      data: (accounts) {
        _buildOptions(accounts);

        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 顶部操作栏
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        l10n.commonCancel,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.accountSelectTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        final selected = _options[_selectedIndex];
                        Navigator.pop(context, selected.id);
                      },
                      child: Text(
                        l10n.commonOk,
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 滚轮选择器
              if (_controller != null)
                SizedBox(
                  height: 216,
                  child: CupertinoPicker(
                    itemExtent: 72,
                    scrollController: _controller!,
                    selectionOverlay: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: _options.map((option) {
                      return _buildAccountItem(option, primaryColor);
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        height: 200,
        child: Center(
          child: Text('${l10n.commonError}: $err'),
        ),
      ),
    );
  }

  Widget _buildAccountItem(AccountOption option, Color primaryColor) {
    final isNone = option.id == null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isNone
                  ? Colors.grey[300]
                  : primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              option.icon,
              color: isNone ? Colors.grey[600] : primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // 账户名称和类型
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  option.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isNone) ...[
                  const SizedBox(height: 4),
                  Text(
                    _getTypeLabel(context, option.type),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
