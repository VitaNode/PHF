import 'package:flutter_test/flutter_test.dart';
import 'package:phf/logic/services/slm/context_compression_service.dart';

void main() {
  late ContextCompressionService service;

  setUp(() {
    service = ContextCompressionService();
  });

  group('ContextCompressionService', () {
    test('should remove page numbers', () {
      const input = '''
Header info
Page 1 of 5
Medical Content
- 1 -
Footer info
''';
      final result = service.compress(input);
      expect(result, contains('Header info'));
      expect(result, contains('Medical Content'));
      expect(result, contains('Footer info'));
      expect(result, isNot(contains('Page 1 of 5')));
      expect(result, isNot(contains('- 1 -')));
    });

    test('should remove disclaimer noise', () {
      const input = '''
Diagnosis: Flu
This report is for Reference only.
Treatment: Rest
Disclaimer: Not for diagnostic use.
''';
      final result = service.compress(input);
      expect(result, contains('Diagnosis: Flu'));
      expect(result, contains('Treatment: Rest'));
      expect(result, isNot(contains('Reference only')));
      expect(result, isNot(contains('Disclaimer')));
    });

    test('should preserve valid medical content', () {
      const input = '''
Blood Test Result
Hemoglobin: 130 g/L
WBC: 6.0
''';
      final result = service.compress(input);
      expect(result, equals(input.trim()));
    });

    test('should handle empty input', () {
      final result = service.compress('');
      expect(result, isEmpty);
    });

     test('should handle input with only noise', () {
      const input = '''
Page 1
Reference only
''';
      final result = service.compress(input);
      expect(result, isEmpty);
    });
  });
}
