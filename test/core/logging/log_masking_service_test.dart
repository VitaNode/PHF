import 'package:flutter_test/flutter_test.dart';
import 'package:phf/core/logging/log_masking_service.dart';

void main() {
  group('LogMaskingService', () {
    test('masks China ID card', () {
      const input = 'User ID is 11010119900101123X.';
      const expected = 'User ID is 110101********123X.';
      expect(LogMaskingService.mask(input), expected);
    });

    test('masks China Phone number', () {
      const input = 'Call 13812345678 for help.';
      const expected = 'Call 138****5678 for help.';
      expect(LogMaskingService.mask(input), expected);
    });

    test('does not mask safe text', () {
      const input = 'Hello World 12345';
      expect(LogMaskingService.mask(input), input);
    });
  });
}
