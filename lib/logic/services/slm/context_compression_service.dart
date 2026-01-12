/// # Context Compression Service
///
/// ## Description
/// 负责在将 OCR 文本送入 SLM 之前进行上下文压缩。
/// 主要去除页眉页脚、免责声明等冗余信息，仅保留医疗核心语义。
library;

class ContextCompressionService {
  /// 压缩 OCR 文本
  ///
  /// 移除：
  /// - 页码 (Page x of y)
  /// - 常见免责声明
  /// - 扫描仪自动添加的水印
  String compress(String fullText) {
    if (fullText.isEmpty) return fullText;

    final lines = fullText.split('\n');
    final cleanedLines = <String>[];

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      // 1. 去除页码 (e.g., "Page 1 of 2", "1/5", "- 1 -")
      if (_isPageNumber(trimmed)) continue;

      // 2. 去除常见免责声明与噪音
      if (_isNoise(trimmed)) continue;

      cleanedLines.add(line);
    }

    return cleanedLines.join('\n');
  }

  bool _isPageNumber(String line) {
    // 匹配 "Page 1", "Page 1 of 5", "1 / 5", "- 1 -", "第 1 页"
    final pageRegex = RegExp(
      r'^(Page\s*\d+(\s*of\s*\d+)?|第\s*\d+\s*页|\d+\s*\/\s*\d+|-\s*\d+\s*-)$',
      caseSensitive: false,
    );
    return pageRegex.hasMatch(line);
  }

  bool _isNoise(String line) {
    final noiseKeywords = [
      '仅供参考',
      'Not for diagnostic use',
      'Disclaimer',
      '此报告仅对',
      'Reference only',
      'Powered by',
      'Scanned by',
    ];

    for (var keyword in noiseKeywords) {
      if (line.contains(keyword)) return true;
    }
    return false;
  }
}
