/// # PIN Keyboard
///
/// ## Description
/// 安全的数字键盘组件，用于输入 PIN 码。
/// 仅包含 0-9 数字键和退格键，无系统键盘调用。
library;

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PinKeyboard extends StatelessWidget {
  final Function(String) onInput;
  final VoidCallback onDelete;

  const PinKeyboard({
    super.key,
    required this.onInput,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 20),
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
            child: const Icon(Icons.backspace_outlined),
            onTap: onDelete,
            isFunction: true,
          );
        }
        return _buildKey(
          child: Text(
            key,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
              : const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.bgGray,
                ),
          child: child,
        ),
      ),
    );
  }
}
