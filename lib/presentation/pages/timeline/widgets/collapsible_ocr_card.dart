/// # Collapsible OCR Card
///
/// ## Description
/// 用于在详情页展示 OCR 识别文本的折叠组件。
/// 默认展示 4 行，支持点击展开全文。
///
/// ## Repair Logs
/// - [issue#24] 初始化实现 T3.5.1 可折叠 OCR 全文组件。
library;

import 'package:flutter/material.dart';
import 'package:phf/presentation/theme/app_theme.dart';

class CollapsibleOcrCard extends StatefulWidget {
  final String text;

  const CollapsibleOcrCard({super.key, required this.text});

  @override
  State<CollapsibleOcrCard> createState() => _CollapsibleOcrCardState();
}

class _CollapsibleOcrCardState extends State<CollapsibleOcrCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgGrey,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: const Color(0xFFE5E5EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'OCR 识别文本',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textHint,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    _isExpanded ? '收起' : '展开全文',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.text,
            maxLines: _isExpanded ? null : 4,
            overflow: _isExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            style: AppTheme.monoStyle.copyWith(
              fontSize: 14,
              height: 1.5,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
