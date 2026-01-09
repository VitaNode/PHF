/// # Privacy Masker
///
/// ## Description
/// 本地隐私脱敏服务。在数据发送给 SLM 之前，识别并掩盖 PII (Personally Identifiable Information)。
///
/// ## Rules
/// - **Mobile**: `1[3-9]\d{9}` -> `1**********`
/// - **ID Card**: `\d{15}(\d|X|x)` -> `******************`
/// - **Names**: 启发式识别常见姓氏开头的 2-3 字文本。
///
/// ## Repair Logs
/// - [2026-01-09] 修复：增加了基于常见姓氏的启发式姓名脱敏逻辑，进一步降低隐私泄露风险。
/// - [2026-01-09] 修复：优化了手机号和身份证正则，增加单词边界 `\b` 以防止身份证号码中的数字串被误认为手机号。
library;

class PrivacyMasker {
  // 增加 \b 防止误伤长数字串
  static final _mobileRegex = RegExp(r'\b(1[3-9]\d{9})\b');
  // 简单的身份证正则
  static final _idCardRegex = RegExp(r'\b(\d{15}(\d|X|x)?|\d{17}(\d|X|x))\b');

  // 常见姓氏（前 20 大姓）
  static const _commonSurnames = '王李张刘陈杨黄吴赵周徐孙马朱胡林郭何高罗';
  static final _nameRegex = RegExp('([$_commonSurnames][\u4e00-\u9fa5]{1,2})');

  String mask(String text) {
    if (text.isEmpty) return text;
    String masked = text;

    // 1. Mask ID Card: 优先匹配长串，且全部掩盖
    masked = masked.replaceAllMapped(_idCardRegex, (match) {
      return '*' * match.group(0)!.length;
    });

    // 2. Mask Mobile: 保留首位
    masked = masked.replaceAllMapped(_mobileRegex, (match) {
      return '1**********';
    });

    // 3. Mask Names (Heuristic)
    masked = masked.replaceAllMapped(_nameRegex, (match) {
      final name = match.group(0)!;
      return '${name[0]}${'*' * (name.length - 1)}';
    });

    return masked;
  }
}
