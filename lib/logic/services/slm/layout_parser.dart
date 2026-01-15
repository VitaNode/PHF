/// # Layout Parser
///
/// ## Description
/// 基于坐标聚类算法，将 OCR 识别出的分散 Line 重组为符合人类阅读顺序（从上到下，从左到右）的结构。
/// 特别针对化验单等表格结构进行优化，尝试恢复行列关系。
///
/// ## Algorithm
/// 1. **Flatten**: 提取所有 `OcrLine`。
/// 2. **Row Clustering**: 基于 Y 轴坐标和高度，将 Lines 聚类为逻辑行。
/// 3. **Column Sorting**: 在每一行内，基于 X 轴坐标对 Lines 进行排序。
/// 4. **Transformation**: 将排序后的 Lines 转换为 `SLMDataBlock`。
///
/// ## Repair Logs
/// - [2026-01-09] 修复：实现了按页隔离的聚类逻辑，防止多页文档内容在 Y 轴坐标接近时发生混淆。
library;

import '../../../data/models/ocr_result.dart';
import '../../../data/models/slm/slm_data_block.dart';

class LayoutParser {
  /// 将 OCR 结果解析为有序的 SLM 数据块列表
  List<SLMDataBlock> parse(OcrResult ocrResult) {
    final result = <SLMDataBlock>[];

    // 按页处理，防止多页混淆
    for (final page in ocrResult.pages) {
      final pageLines = <OcrLine>[];
      for (final block in page.blocks) {
        for (final line in block.lines) {
          pageLines.add(line);
        }
      }

      if (pageLines.isEmpty) continue;

      // 1. Row Clustering for this page
      // Sort by Y first to make clustering easier
      pageLines.sort((a, b) => a.y.compareTo(b.y));

      final rows = <List<OcrLine>>[];

      for (final line in pageLines) {
        bool added = false;

        // Try to add to an existing row
        for (int i = rows.length - 1; i >= 0; i--) {
          final row = rows[i];
          final rowY = _calculateRowY(row);
          final rowH = _calculateRowHeight(row);

          // Threshold: 垂直中心距离小于行高的一半
          final centerDiff = (line.y + line.h / 2) - (rowY + rowH / 2);
          if (centerDiff.abs() < rowH * 0.5) {
            row.add(line);
            added = true;
            break;
          }
        }

        if (!added) {
          rows.add([line]);
        }
      }

      // 2. Column Sorting & Transformation
      for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
        final row = rows[rowIndex];
        // Sort lines in row by X coordinate
        row.sort((a, b) => a.x.compareTo(b.x));

        for (final line in row) {
          result.add(
            SLMDataBlock(
              rawText: line.text,
              confidence: line.confidence,
              boundingBox: [line.x, line.y, line.w, line.h],
              // 我们在这里暂存 row_index 信息，如果模型支持
              // 虽然 SLMDataBlock 实体中目前没有 rowIndex，但有序列表已足够
            ),
          );
        }
      }
    }

    return result;
  }

  /// 智能查找关键字段的坐标
  /// 用于编辑模式下的精准对焦
  List<double>? findFieldCoordinates(
    List<SLMDataBlock> blocks,
    String fieldType,
  ) {
    if (blocks.isEmpty) return null;

    final hospitalKeywords = [
      '医院',
      '中心',
      '诊所',
      'Health',
      'Hospital',
      'Medical',
    ];
    final dateKeywords = ['日期', '时间', 'Date', 'Time', '20', '19'];

    for (var block in blocks) {
      final text = block.rawText.toLowerCase();

      if (fieldType == 'hospital') {
        if (hospitalKeywords.any((k) => text.contains(k.toLowerCase()))) {
          return block.boundingBox;
        }
      } else if (fieldType == 'date') {
        // 简单的日期正则检查: YYYY-MM-DD 或类似
        if (dateKeywords.any((k) => text.contains(k.toLowerCase())) ||
            RegExp(r'\d{4}[\-\/\.年]\d{1,2}[\-\/\.月]\d{1,2}').hasMatch(text)) {
          return block.boundingBox;
        }
      }
    }

    // Fallback: 医院通常在顶部，日期通常在顶部或底部
    if (blocks.isNotEmpty) {
      if (fieldType == 'hospital') return blocks.first.boundingBox;
    }

    return null;
  }

  double _calculateRowY(List<OcrLine> row) {
    if (row.isEmpty) return 0.0;
    double sum = 0.0;
    for (var line in row) {
      sum += line.y;
    }
    return sum / row.length;
  }

  double _calculateRowHeight(List<OcrLine> row) {
    if (row.isEmpty) return 0.0;
    double sum = 0.0;
    for (var line in row) {
      sum += line.h;
    }
    return sum / row.length;
  }
}
