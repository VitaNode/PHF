/// # Markdown Converter
///
/// ## Description
/// 将结构化的 SLM 数据块序列化为 Markdown 格式，优化 SLM 的输入 Token。
///
/// ## Repair Logs
/// - [2026-01-09] 修复：优化了分行逻辑。现在利用 Y 轴坐标和高度动态判断行切换，并使用标准的 Markdown 表格分隔符。
library;

import '../../../data/models/slm/slm_data_block.dart';

class MarkdownConverter {
  String convert(List<SLMDataBlock> blocks) {
    if (blocks.isEmpty) return '';

    final buffer = StringBuffer();
    double? lastRowY;
    double? lastRowH;

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final currentY = block.boundingBox[1];
      final currentH = block.boundingBox[3];

      if (lastRowY == null) {
        // 第一行开始
        buffer.write('| ');
      } else {
        // 判断是否换行
        // 使用 0.5 * 高度作为阈值
        final diff = (currentY - lastRowY).abs();
        if (diff > lastRowH! * 0.5) {
          buffer.writeln(' |'); // 结束上一行
          buffer.write('| '); // 开始新一行
        } else {
          buffer.write(' | '); // 同行分隔
        }
      }

      buffer.write(block.normalizedText ?? block.rawText);
      lastRowY = currentY;
      lastRowH = currentH;
    }

    // 闭合最后一行
    if (blocks.isNotEmpty) {
      buffer.write(' |');
    }

    return buffer.toString();
  }
}
