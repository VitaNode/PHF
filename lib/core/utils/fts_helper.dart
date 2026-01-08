/// # FTS Helper
///
/// ## Description
/// 提供 FTS5 搜索相关的工具函数，包括 CJK 分段和查询脱敏。
library;

class FtsHelper {
  /// 为 CJK 字符插入空格以支持 FTS5 分词
  static String segmentCJK(String text) {
    if (text.isEmpty) return text;
    // 匹配 CJK 字符区间
    final regExp = RegExp(r'([\u4e00-\u9fa5])');
    return text
        .replaceAllMapped(regExp, (match) => ' ${match.group(0)} ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// 移除为了 FTS5 分词而人工插入的 CJK 空格
  static String desegmentCJK(String text) {
    if (text.isEmpty) return text;
    // 移除所有与 CJK 字符相邻的空格
    return text
        .replaceAll(RegExp(r'\s+(?=[\u4e00-\u9fa5])'), '')
        .replaceAll(RegExp(r'(?<=[\u4e00-\u9fa5])\s+'), '')
        .trim();
  }

  /// 脱敏并格式化 FTS5 查询语句
  static String sanitizeQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return '';

    // 先按空格分词，对每个原始词内部进行 CJK 分段并包裹引号，确保 CJK 连续词作为 Phrase 匹配
    return trimmed
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) {
          final segmented = segmentCJK(t);
          final escaped = segmented.replaceAll('"', '""');
          return '"$escaped"';
        })
        .join(' ');
  }
}
