/// # OCR Enhancer Utility
///
/// ## Description
/// 对原始 OCR 结果进行语义增强。包括键值对拆分、章节识别及文本清洗。
///
/// ## Heuristics
/// - **Key-Value Splitting**: 识别冒号（: 或 ：），将一行拆分为 `label` 和 `value`。
/// - **Section Identification**: 识别可能是章节标题的行（短行、无末尾标点、独立区块）。
/// - **Fragment Cleaning**: 处理因 OCR 引擎导致的单词或短语碎片化。
///
/// ## Security
/// - 纯函数设计，不涉及敏感资产或持久化操作。
/// - 符合 `Constitution#IV. Security & Privacy`。
///
/// ## Repair Logs
/// [2026-01-06] 修复：支持 OcrResult V2 (Pages) 结构，统一 PascalCase 命名。
library;

import '../../data/models/ocr_result.dart';

class OcrEnhancer {
  /// 增强 OCR 结果
  static OcrResult enhance(OcrResult original) {
    if (original.pages.isEmpty) return original;

    final enhancedPages = original.pages.map(_enhancePage).toList();
    return original.copyWith(pages: enhancedPages);
  }

  static OcrPage _enhancePage(OcrPage page) {
    final enhancedBlocks = page.blocks.map(_enhanceBlock).toList();
    return page.copyWith(blocks: enhancedBlocks);
  }

  static OcrBlock _enhanceBlock(OcrBlock block) {
    var enhancedLines = block.lines.map(_enhanceLine).toList();

    // Heuristic: 如果 Block 只有一行且符合标题特征，标记为 sectionTitle
    OcrSemanticType blockType = OcrSemanticType.normal;
    if (enhancedLines.length == 1) {
      final line = enhancedLines.first;
      if (_isPotentialSectionTitle(line.text)) {
        blockType = OcrSemanticType.sectionTitle;
        enhancedLines = [line.copyWith(type: OcrSemanticType.sectionTitle)];
      }
    }

    return block.copyWith(lines: enhancedLines, type: blockType);
  }

  static OcrLine _enhanceLine(OcrLine line) {
    final text = line.text.trim();

    // 1. Key-Value Splitting
    final colonIndex = _findColonIndex(text);
    if (colonIndex != -1 && colonIndex > 0 && colonIndex < text.length - 1) {
      final keyText = text.substring(0, colonIndex).trim();
      final valueText = text.substring(colonIndex + 1).trim();

      // 创建新的 Elements
      // 注意：这里由于缺乏原始 Element 的精确坐标，我们通过比例估算
      final totalWidth = line.w;
      final splitRatio = colonIndex / text.length;

      final keyElement = OcrElement(
        text: keyText,
        x: line.x,
        y: line.y,
        w: totalWidth * splitRatio,
        h: line.h,
        type: OcrSemanticType.label,
      );

      final valueElement = OcrElement(
        text: valueText,
        x: line.x + totalWidth * splitRatio,
        y: line.y,
        w: totalWidth * (1 - splitRatio),
        h: line.h,
        type: OcrSemanticType.value,
      );

      return line.copyWith(
        elements: [keyElement, valueElement],
        type: OcrSemanticType.normal, // 这一行包含了 KV，整体仍标记为 normal 或根据需求调整
      );
    }

    // 2. Section Title Check (Line level)
    if (_isPotentialSectionTitle(text)) {
      return line.copyWith(type: OcrSemanticType.sectionTitle);
    }

    return line;
  }

  static int _findColonIndex(String text) {
    final idx1 = text.indexOf(':');
    final idx2 = text.indexOf('：');
    if (idx1 != -1 && idx2 != -1) return idx1 < idx2 ? idx1 : idx2;
    return idx1 != -1 ? idx1 : idx2;
  }

  static bool _isPotentialSectionTitle(String text) {
    if (text.isEmpty) return false;
    // 医疗报告标题通常较短 (2-10个字符)
    if (text.length < 2 || text.length > 15) return false;

    // 不应以标点结尾
    final lastChar = text[text.length - 1];
    if (RegExp(r'[。，,！？!；;：:]').hasMatch(lastChar)) return false;

    // 常见章节关键字
    final keywords = [
      '诊断',
      '印象',
      '建议',
      '表现',
      '描述',
      '病史',
      '结论',
      '结果',
      '报告单',
      '项目',
      '指标',
    ];

    return keywords.any((k) => text.contains(k));
  }
}