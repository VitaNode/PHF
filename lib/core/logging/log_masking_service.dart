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
    // Add more rules as needed
    return output;
  }

  // Mask China ID: 18 digits or 17 digits + X
  // Simple regex: \d{17}[\dXx] -> \d{6}********\d{4}
  // Be careful not to match random long numbers unless they look like IDs.
  static String _maskChinaID(String text) {
    final RegExp idRegex = RegExp(r'(?<!\d)\d{6}(\d{8})\d{3}[\dXx](?!\d)');
    return text.replaceAllMapped(idRegex, (match) {
      final full = match.group(0)!;
      // Keep first 6, last 4. Mask 8 in middle?
      // Standard ID is 18 chars. 6(area) + 8(dob) + 4(seq).
      // We mask the DOB.
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
}
