/// # PIN Keyboard
///
/// ## Description
/// 安全的数字键盘组件，用于输入 PIN 码。
/// 仅包含 0-9 数字键和退格键，无系统键盘调用。
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PinKeyboard extends StatelessWidget {
  final void Function(String) onInput;
  final VoidCallback onDelete;
  final Color? textColor;
  final Color? buttonBackgroundColor;

  const PinKeyboard({
    super.key,
    required this.onInput,
    required this.onDelete,
    this.textColor,
    this.buttonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 16),
          _buildRow([null, '0', 'delete']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String?> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((key) {
        if (key == null) {
          return const SizedBox(width: 72, height: 72);
        }
        if (key == 'delete') {
          return _buildKey(
            child: Icon(Icons.backspace_outlined, color: textColor),
            onTap: onDelete,
            isFunction: true,
          );
        }
        return _buildKey(
          child: Text(
            key,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          onTap: () => onInput(key),
        );
      }).toList(),
    );
  }

  Widget _buildKey({
    required Widget child,
    required VoidCallback onTap,
    bool isFunction = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: isFunction
              ? null
              : BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonBackgroundColor ?? AppTheme.bgGray,
                ),
          child: child,
        ),
      ),
    );
  }
}
