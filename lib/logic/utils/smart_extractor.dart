/// # SmartExtractor Utility
///
/// ## Description
/// 用于从 OCR 原始文本中提取结构化医疗元数据（日期、医院名称）。
/// 采用轻量级的正则表达式和关键词匹配方案，确保 100% 离线运行。
///
/// ## Implementation Details
/// - **Date Extraction**: 匹配 YYYY-MM-DD, YYYY/MM/DD, YYYY年MM月DD日 等格式。
/// - **Hospital Extraction**: 查找包含“医院”、“中心”、“卫生站”等关键词的行，并进行清洗。
/// - **Confidence Scoring**: 
///   - 初始分 = OCR 平均置信度。
///   - 惩罚项：未提取到有效日期 (-0.3)，未提取到有效医院 (-0.1)。
///
/// ## Security
/// - 纯函数设计，不涉及敏感资产或持久化操作。
/// - 零网络请求，数据处理仅限内存。
library;

import '../../data/models/extracted_medical_data.dart';

class SmartExtractor {
  // 日期提取正则
  static final List<RegExp> _dateRegexes = [
    // YYYY-MM-DD
    RegExp(r'(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})'),
    // YYYY年MM月DD日
    RegExp(r'(\d{4})\s*年\s*(\d{1,2})\s*月\s*(\d{1,2})\s*日'),
    // 简写: YY-MM-DD
    RegExp(r'(\d{2})[-/.](\d{1,2})[-/.](\d{1,2})'),
  ];

  // 医院名称关键词
  static const List<String> _hospitalKeywords = [
    '医院',
    '卫生院',
    '医疗中心',
    '诊所',
    '门诊部',
    '卫生站',
    '社区卫生',
    'Hospital',
    'Clinic',
    'Medical Center',
  ];

  // 排除词（如果行中包含这些词，通常不是医院名称行）
  static const List<String> _excludeKeywords = [
    '地址',
    '电话',
    '科室',
    '收费',
    '打印',
    '日期',
    '病人',
    '姓名',
  ];

  /// 执行智能提取
  /// [fullText]: OCR 识别出的全文
  /// [baseConfidence]: OCR 引擎返回的平均置信度 (0.0 - 1.0)
  static ExtractedMedicalData extract(String fullText, double baseConfidence) {
    if (fullText.isEmpty) {
      return const ExtractedMedicalData(confidenceScore: 0.0);
    }

    final sanitizedText = fullText.replaceAll('\r', '').trim();
    final visitDate = _extractDate(sanitizedText);
    final hospitalName = _extractHospital(sanitizedText);

    // 计算置信度得分 (FR-203)
    double score = baseConfidence;
    if (visitDate == null) score -= 0.3;
    if (hospitalName == null || hospitalName.isEmpty) score -= 0.1;

    // 确保得分在 0.0 - 1.0 之间
    score = score.clamp(0.0, 1.0);

    return ExtractedMedicalData(
      visitDate: visitDate,
      hospitalName: hospitalName,
      confidenceScore: score,
    );
  }

  static DateTime? _extractDate(String text) {
    for (final regex in _dateRegexes) {
      final match = regex.firstMatch(text);
      if (match != null) {
        try {
          int year = int.parse(match.group(1)!);
          final month = int.parse(match.group(2)!);
          final day = int.parse(match.group(3)!);

          // 处理 YY 简写（假设 20xx）
          if (year < 100) {
            year += 2000;
          }

          if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
            return DateTime(year, month, day);
          }
        } catch (_) {
          continue;
        }
      }
    }
    return null;
  }

  static String? _extractHospital(String text) {
    final lines = text.split('\n');
    
    // 策略：寻找包含关键词的最早的行
    for (var line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.length < 4 || trimmedLine.length > 50) continue;

      // 检查是否包含医院关键词
      final hasHospitalKw = _hospitalKeywords.any((kw) => trimmedLine.contains(kw));
      if (hasHospitalKw) {
        // 排除掉不相关的行（如“科室：内科一病房”）
        final shouldExclude = _excludeKeywords.any((kw) => trimmedLine.contains(kw));
        if (!shouldExclude) {
          // 清洗：去除行首尾可能的非文字干扰
          return _sanitizeHospitalName(trimmedLine);
        }
      }
    }
    return null;
  }

  static String _sanitizeHospitalName(String name) {
    // 处理常见的 OCR 误识别前缀或特殊字符
    final sanitized = name
        .replaceAll(RegExp(r'^[:：.\s]+'), '')
        .replaceAll(RegExp(r'[#*]$'), '');
    return sanitized.trim();
  }
}
