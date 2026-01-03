import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';

void main() {
  group('OCRResult Tests', () {
    test('OCRBlock serialization', () {
      const block = OCRBlock(
        text: 'Hello',
        left: 10.0,
        top: 20.0,
        width: 100.0,
        height: 50.0,
      );

      final json = block.toJson();
      expect(json['text'], 'Hello');
      expect(json['left'], 10.0);
      expect(json['top'], 20.0);

      final fromJson = OCRBlock.fromJson(json);
      expect(fromJson, block);
    });

    test('OCRResult serialization', () {
      const block = OCRBlock(
        text: 'Hello',
        left: 10.0,
        top: 20.0,
        width: 100.0,
        height: 50.0,
      );

      final result = OCRResult(
        text: 'Hello World',
        blocks: [block],
        confidence: 0.95,
      );

      final json = result.toJson();
      print('JSON Output: $json');
      expect(json['text'], 'Hello World');
      expect(json['confidence'], 0.95);
      expect((json['blocks'] as List).length, 1);

      final fromJson = OCRResult.fromJson(json);
      expect(fromJson, result);
    });

    test('OCRResult defaults', () {
      const result = OCRResult(text: 'No Blocks');
      expect(result.blocks, isEmpty);
      expect(result.confidence, 0.0);
    });
  });
}
