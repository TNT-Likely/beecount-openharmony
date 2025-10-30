import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// 通用滚轮选择器
class WheelPicker<T> extends StatefulWidget {
  final T initial;
  final List<T> items;
  final String Function(T) labelBuilder;
  final String title;

  const WheelPicker({
    super.key,
    required this.initial,
    required this.items,
    required this.labelBuilder,
    required this.title,
  });

  @override
  State<WheelPicker<T>> createState() => _WheelPickerState<T>();
}

class _WheelPickerState<T> extends State<WheelPicker<T>> {
  late T selected;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
    final index = widget.items.indexOf(selected);
    _controller = FixedExtentScrollController(initialItem: index >= 0 ? index : 0);
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.commonCancel,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context, selected),
                  child: Text(
                    AppLocalizations.of(context)!.commonOk,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 156,
            child: CupertinoPicker(
              itemExtent: 52,
              scrollController: _controller,
              onSelectedItemChanged: (i) => setState(() {
                selected = items[i];
              }),
              children: [
                for (final item in items)
                  Center(
                    child: Text(
                      widget.labelBuilder(item),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 显示滚轮选择器
Future<T?> showWheelPicker<T>(
  BuildContext context, {
  required T initial,
  required List<T> items,
  required String Function(T) labelBuilder,
  required String title,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (_) => WheelPicker<T>(
      initial: initial,
      items: items,
      labelBuilder: labelBuilder,
      title: title,
    ),
  );
}
