import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';

void main() {
  group('OCRResult V2 Tests', () {
    test('OCRBlock Schema V2 serialization (x, y, w, h)', () {
      const block = OCRBlock(
        text: 'Hello',
        x: 0.1,
        y: 0.2,
        w: 0.5,
        h: 0.1,
        lines: [
          OCRLine(
            text: 'Hello',
            x: 0.1,
            y: 0.2,
            w: 0.5,
            h: 0.1,
            confidence: 0.99,
            elements: [
              OCRTextElement(
                text: 'H',
                x: 0.1,
                y: 0.2,
                w: 0.1,
                h: 0.1,
                confidence: 0.99,
              ),
            ],
          ),
        ],
      );

      final json = block.toJson();
      expect(json['text'], 'Hello');
      expect(json['x'], 0.1);
      expect(json['y'], 0.2);
      expect(json['w'], 0.5);
      expect(json['h'], 0.1);
      expect(json['lines'], isNotEmpty);

      final fromJson = OCRBlock.fromJson(json);
      expect(fromJson.x, 0.1);
      expect(fromJson.lines.first.elements.first.text, 'H');
    });

    test('OCRBlock Schema V1 Compatibility (left, top, width, height)', () {
      final legacyJson = {
        'text': 'Legacy Block',
        'left': 10.0,
        'top': 20.0,
        'width': 100.0,
        'height': 50.0,
      };

      final block = OCRBlock.fromJson(legacyJson);
      expect(block.text, 'Legacy Block');
      expect(block.x, 10.0);
      expect(block.y, 20.0);
      expect(block.w, 100.0);
      expect(block.h, 50.0);
    });

    test('OCRResult V2 serialization with Metadata', () {
      final now = DateTime.now();
      final result = OCRResult(
        text: 'Full Text',
        source: 'ios_vision',
        language: 'zh-Hans',
        timestamp: now,
        version: 2,
        blocks: [const OCRBlock(text: 'B1', x: 0, y: 0, w: 1, h: 1)],
      );

      final json = result.toJson();
      expect(json['source'], 'ios_vision');
      expect(json['language'], 'zh-Hans');
      expect(json['version'], 2);
      expect(json['timestamp'], isNotNull);

      final fromJson = OCRResult.fromJson(json);
      expect(fromJson.source, 'ios_vision');
      expect(fromJson.version, 2);
      // DateTime might lose precision in JSON or have string format
      expect(
        fromJson.timestamp?.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );
    });

    test('OCRResult Legacy Compatibility', () {
      final legacyJson = {
        'text': 'Old Result',
        'confidence': 0.8,
        'blocks': [
          {
            'text': 'Old Block',
            'left': 0.1,
            'top': 0.1,
            'width': 0.8,
            'height': 0.2,
          },
        ],
      };

      final result = OCRResult.fromJson(legacyJson);
      expect(result.text, 'Old Result');
      expect(result.confidence, 0.8);
      expect(result.source, 'unknown'); // Default
      expect(result.version, 1); // Default
      expect(result.blocks.first.x, 0.1);
    });
  });
}
