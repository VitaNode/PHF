import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';

void main() {
  group('OcrResult V2 Tests', () {
    test('OcrBlock Schema V2 serialization (x, y, w, h)', () {
      const block = OcrBlock(
        text: 'Hello',
        x: 0.1,
        y: 0.2,
        w: 0.5,
        h: 0.1,
        lines: [
          OcrLine(
            text: 'Hello',
            x: 0.1,
            y: 0.2,
            w: 0.5,
            h: 0.1,
            confidence: 0.99,
            elements: [
              OcrElement(
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

      final fromJson = OcrBlock.fromJson(json);
      expect(fromJson.x, 0.1);
      expect(fromJson.lines.first.elements.first.text, 'H');
    });

    test('OcrBlock Schema V1 Compatibility (left, top, width, height)', () {
      final legacyJson = {
        'text': 'Legacy Block',
        'left': 10.0,
        'top': 20.0,
        'width': 100.0,
        'height': 50.0,
      };

      final block = OcrBlock.fromJson(legacyJson);
      expect(block.text, 'Legacy Block');
      expect(block.x, 10.0);
      expect(block.y, 20.0);
      expect(block.w, 100.0);
      expect(block.h, 50.0);
    });

    test('OcrPage serialization', () {
      const page = OcrPage(
        pageNumber: 1,
        width: 1000,
        height: 2000,
        blocks: [OcrBlock(text: 'Page Block', x: 0, y: 0, w: 1, h: 1)],
      );

      final json = page.toJson();
      expect(json['pageNumber'], 1);
      expect(json['width'], 1000);
      expect(json['blocks'], isNotEmpty);

      final fromJson = OcrPage.fromJson(json);
      expect(fromJson.pageNumber, 1);
      expect(fromJson.blocks.first.text, 'Page Block');
    });

    test('OcrResult V2 serialization with Metadata', () {
      final now = DateTime.now();
      final result = OcrResult(
        text: 'Full Text',
        source: 'ios_vision',
        language: 'zh-Hans',
        timestamp: now,
        version: 2,
        pages: [
          const OcrPage(blocks: [OcrBlock(text: 'B1', x: 0, y: 0, w: 1, h: 1)]),
        ],
      );

      final json = result.toJson();
      expect(json['source'], 'ios_vision');
      expect(json['language'], 'zh-Hans');
      expect(json['version'], 2);
      expect(json['timestamp'], isNotNull);
      expect(json['pages'], isList);

      final fromJson = OcrResult.fromJson(json);
      expect(fromJson.source, 'ios_vision');
      expect(fromJson.version, 2);
      expect(fromJson.pages.first.blocks.first.text, 'B1');
      // DateTime might lose precision in JSON or have string format
      expect(
        fromJson.timestamp?.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
      );
    });

    test('OcrResult Legacy Compatibility', () {
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

      final result = OcrResult.fromJson(legacyJson);
      expect(result.text, 'Old Result');
      expect(result.confidence, 0.8);
      expect(result.source, 'unknown'); // Default
      expect(result.pages, isNotEmpty);
      expect(result.pages.first.blocks.first.x, 0.1);
      // Test the compatibility getter
      expect(result.blocks.first.x, 0.1);
    });
  });
}
