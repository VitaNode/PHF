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
import '../../../../data/models/ocr_result.dart';
import 'enhanced_ocr_view.dart';

class CollapsibleOcrCard extends StatefulWidget {
  final String text;
  final OcrResult? ocrResult;

  const CollapsibleOcrCard({super.key, required this.text, this.ocrResult});

  @override
  State<CollapsibleOcrCard> createState() => _CollapsibleOcrCardState();
}

class _CollapsibleOcrCardState extends State<CollapsibleOcrCard> {
  bool _isExpanded = false;
  bool _isEnhanced = true;

  @override
  Widget build(BuildContext context) {
    if (widget.text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final hasResult = widget.ocrResult != null;

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
              Row(
                children: [
                  if (hasResult)
                    GestureDetector(
                      onTap: () => setState(() => _isEnhanced = !_isEnhanced),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          _isEnhanced ? '查看原文' : '智能增强',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (hasResult)
                    const SizedBox(
                      height: 12,
                      child: VerticalDivider(
                        width: 1,
                        color: AppTheme.textHint,
                      ),
                    ),
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
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
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: _isExpanded
                ? const BoxConstraints()
                : const BoxConstraints(maxHeight: 120),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                if (_isExpanded) {
                  return const LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ).createShader(bounds);
                }
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white.withValues(alpha: 0.0)],
                  stops: const [0.7, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: widget.ocrResult != null
                  ? EnhancedOcrView(
                      result: widget.ocrResult!,
                      isEnhancedMode: _isEnhanced,
                    )
                  : Text(
                      widget.text,
                      style: AppTheme.monoStyle.copyWith(
                        fontSize: 14,
                        height: 1.5,
                        color: AppTheme.textPrimary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
