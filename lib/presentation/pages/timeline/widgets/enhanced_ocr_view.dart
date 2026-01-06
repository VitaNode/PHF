/// # Enhanced OCR View
///
/// ## Description
/// 增强型 OCR 展示组件，支持语义高亮、结构化分段及原文/增强模式切换。
///
/// ## Features
/// - **Structured List**: 渲染 Block -> Line 结构。
/// - **Semantic Highlighting**: Section Title 加粗，Label/Value 主题色区分。
/// - **Dual Mode**: 支持一键切换纯文本与结构化视图。
/// - **Performance**: 使用精简的组件树确保长文本滚动流畅。
library;

import 'package:flutter/material.dart';
import '../../../../data/models/ocr_result.dart';
import '../../../theme/app_theme.dart';

class EnhancedOcrView extends StatelessWidget {
  final OcrResult result;
  final bool isEnhancedMode;

  const EnhancedOcrView({
    super.key,
    required this.result,
    this.isEnhancedMode = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEnhancedMode || result.pages.isEmpty) {
      return Text(
        result.text,
        style: AppTheme.monoStyle.copyWith(
          fontSize: 14,
          height: 1.5,
          color: AppTheme.textPrimary,
        ),
      );
    }

    // Enhanced Mode: 结构化渲染
    final List<Widget> children = [];

    for (var page in result.pages) {
      for (var block in page.blocks) {
        children.add(_buildBlock(block));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildBlock(OcrBlock block) {
    final bool isSectionTitle = block.type == OcrSemanticType.sectionTitle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSectionTitle)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text(
                block.text,
                style: AppTheme.monoStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppTheme.primaryTeal,
                ),
              ),
            )
          else
            ...block.lines.map(_buildLine),
        ],
      ),
    );
  }

  Widget _buildLine(OcrLine line) {
    // 如果 Line 本身被标记为 sectionTitle
    if (line.type == OcrSemanticType.sectionTitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          line.text,
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
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: RichText(
          text: TextSpan(children: line.elements.map(_buildElement).toList()),
        ),
      );
    }

    // 普通行
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        line.text,
        style: AppTheme.monoStyle.copyWith(
          fontSize: 14,
          height: 1.4,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  TextSpan _buildElement(OcrElement element) {
    Color textColor = AppTheme.textPrimary;
    FontWeight fontWeight = FontWeight.normal;

    if (element.type == OcrSemanticType.label) {
      textColor = AppTheme.textSecondary;
      fontWeight = FontWeight.w600;
    } else if (element.type == OcrSemanticType.value) {
      textColor = AppTheme.primaryTeal;
      fontWeight = FontWeight.bold;
    }

    return TextSpan(
      text: element.text,
      style: AppTheme.monoStyle.copyWith(
        color: textColor,
        fontWeight: fontWeight,
        fontSize: 14,
      ),
    );
  }
}
