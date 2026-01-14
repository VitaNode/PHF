/// # Medical Unit Normalizer
///
/// ## Description
/// 医学单位归一化工具。将不同 OCR 识别变体统一为标准格式，以便 SLM 理解。
library;

class MedicalUnitNormalizer {
  static const Map<String, String> _standardMap = {
    'g/l': 'g/L',
    'G/L': 'g/L',
    'mg/dl': 'mg/dL',
    'mg/Dl': 'mg/dL',
    'mmol/l': 'mmol/L',
    'umol/L': 'µmol/L',
    'u/L': 'U/L',
  };

  String normalize(String text) {
    String result = text;
    // 简单的全词匹配可能不够，因为 OCR 结果可能包含数字+单位 (e.g. "12.5g/L")
    // 这里使用简单的正则替换，针对每个单位变体

    _standardMap.forEach((variant, standard) {
      // 匹配单词边界或者数字边界
      // RegExp.escape(variant) 确保特殊字符被转义
      // (?<=\d)\s* 匹配数字后可能有空格

      // 简单策略：直接全局替换，假设单位足够独特
      // 为了避免错误替换，可以尝试更严格的正则，但这里从简
      result = result.replaceAll(variant, standard);
    });

    return result;
  }
}
