/// # LogMaskingService
///
/// ## Description
/// Sanitizes log messages by masking sensitive information.
///
/// ## Rules
/// - Passwords/Keys: Should not be logged, but if present, replace with ***.
/// - ID Card (身份证): Mask middle digits.
/// - Phone: Mask middle digits.
/// - Name: Mask names (hard to detect perfectly, but can try heuristic or just rely on manual masking in code).
///
/// For this automated service, we focus on pattern matching for common sensitive formats.
class LogMaskingService {
  /// Masks sensitive patterns in the input text.
  static String mask(String input) {
    String output = input;
    output = _maskChinaID(output);
    output = _maskChinaPhone(output);
    output = _maskNames(output);
    output = _maskKeywords(output);
    return output;
  }

  // Mask China ID: 18 digits or 17 digits + X
  static String _maskChinaID(String text) {
    final RegExp idRegex = RegExp(r'(?<!\d)\d{6}(\d{8})\d{3}[\dXx](?!\d)');
    return text.replaceAllMapped(idRegex, (match) {
      final full = match.group(0)!;
      if (full.length == 18) {
        return '${full.substring(0, 6)}********${full.substring(14)}';
      }
      return full;
    });
  }

  // Mask Phone: 11 digits starting with 1
  static String _maskChinaPhone(String text) {
    final RegExp phoneRegex = RegExp(r'(?<!\d)(1\d{2})(\d{4})(\d{4})(?!\d)');
    return text.replaceAllMapped(phoneRegex, (match) {
      return '${match.group(1)}****${match.group(3)}';
    });
  }

  // Mask Names: Heuristic for "姓名：xxx" or "Name: xxx"
  static String _maskNames(String text) {
    return text.replaceAllMapped(
      RegExp(r'([姓名Name]{2}[:：]\s*)([\u4e00-\u9fa5]{2,4})'),
      (match) {
        final prefix = match.group(1)!;
        final name = match.group(2)!;
        if (name.length == 2) return '$prefix${name[0]}*';
        if (name.length == 3) return '$prefix${name[0]}*${name[2]}';
        return '$prefix${name[0]}**${name[name.length - 1]}';
      },
    );
  }

  // Mask Keywords: Forbidden tokens
  static String _maskKeywords(String text) {
    final forbiddenKeywords = [
      'password',
      'secret',
      'mnemonic',
      'master_key',
    ];
    String output = text;
    for (final kw in forbiddenKeywords) {
      final regex = RegExp(kw, caseSensitive: false);
      output = output.replaceAll(regex, '***');
    }
    return output;
  }
}

/// ## Repair Logs
/// - [2026-01-08] 修复：增强脱敏逻辑，支持姓名脱敏及敏感关键字过滤（Issue #113 加固）。

