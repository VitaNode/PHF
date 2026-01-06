/// # Enhanced OCR View
///
/// ## Description
/// 增强型 OCR 展示组件，支持语义高亮、结构化分段及原文/增强模式切换。
///
/// ## Features
/// - **Structured List**: 渲染 Page -> Block -> Line 结构。
/// - **Semantic Highlighting**: Section Title 使用加粗主题色样式。
/// - **Tokenized Tokens**: Line/Elements 使用 Wrap 渲染，支持标签/数值的视觉区分。
/// - **Dual Mode**: 支持一键切换纯文本与结构化视图。
/// - **Performance**: 支持传入 ScrollController，利用 ListView 优化长文档性能。
///
/// ## Repair Logs
/// [2026-01-06] 修复：优化语义渲染逻辑，将 Line/Elements 改为 Wrap 结构以支持更好的 Token 展示；统一 Monospace 字体应用；增加对多页（Pages）的完整支持；增加 ScrollController 支持以优化长文档滚动流畅度。
library;

import 'package:flutter/material.dart';
import '../../../../data/models/ocr_result.dart';
import '../../../theme/app_theme.dart';

class EnhancedOcrView extends StatelessWidget {
  final OcrResult result;
  final bool isEnhancedMode;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const EnhancedOcrView({
    super.key,
    required this.result,
    this.isEnhancedMode = true,
    this.scrollController,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppTheme.monoStyle.copyWith(
      fontSize: 14,
      height: 1.6,
      color: AppTheme.textPrimary,
    );

    if (!isEnhancedMode || result.pages.isEmpty) {
      return SelectableText(result.text, style: style, scrollPhysics: physics);
    }

    // 扁平化所有 Block 以便在 ListView 中渲染
    final List<Widget> items = [];

    for (var i = 0; i < result.pages.length; i++) {
      final page = result.pages[i];
      // 页面分隔（多页时显示）
      if (result.pages.length > 1) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '第 ${page.pageNumber + 1} 页',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),
        );
      }

      for (var block in page.blocks) {
        items.add(_buildBlock(block));
      }
    }

    // 如果没有传入 scrollController 且不需要 shrinkWrap，默认使用 Column
    // 这种模式适合在 SingleChildScrollView 内部或者作为折叠卡片的一部分
    if (scrollController == null && shrinkWrap) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: items,
      );
    }

    // 性能优化模式：使用 ListView
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => items[index],
    );
  }

  Widget _buildBlock(OcrBlock block) {
    final bool isSectionTitle = block.type == OcrSemanticType.sectionTitle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSectionTitle)
            Container(
              margin: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppTheme.primaryTeal, width: 4),
                ),
              ),
              child: Text(
                block.text,
                style: AppTheme.monoStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.primaryTeal,
                ),
              ),
            )
          else ...[
            ...block.lines.map(_buildLine),
          ],
        ],
      ),
    );
  }

  Widget _buildLine(OcrLine line) {
    final trimmedText = line.text.trim();
    if (trimmedText.isEmpty) return const SizedBox.shrink();

    // 如果 Line 本身被标记为 sectionTitle
    if (line.type == OcrSemanticType.sectionTitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          trimmedText,
          style: AppTheme.monoStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppTheme.primaryTeal,
          ),
        ),
      );
    }

    // 如果 Line 有语义元素 (Elements)
    if (line.elements.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: line.elements.map(_buildElementWidget).toList(),
        ),
      );
    }

    // 普通行
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: SelectableText(
        line.text,
        style: AppTheme.monoStyle.copyWith(
          fontSize: 14,
          height: 1.6,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildElementWidget(OcrElement element) {
    Color textColor = AppTheme.textPrimary;
    Color? bgColor;
    FontWeight fontWeight = FontWeight.normal;

    if (element.type == OcrSemanticType.label) {
      textColor = AppTheme.textSecondary;
      fontWeight = FontWeight.w600;
      bgColor = AppTheme.bgGrey;
    } else if (element.type == OcrSemanticType.value) {
      textColor = AppTheme.primaryTeal;
      fontWeight = FontWeight.bold;
      bgColor = AppTheme.primaryTeal.withValues(alpha: 0.08);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        element.text,
        style: AppTheme.monoStyle.copyWith(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: 14,
        ),
      ),
    );
  }
}
