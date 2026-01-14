import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';
import 'package:phf/logic/services/slm/layout_parser.dart';
import 'package:phf/logic/services/slm/privacy_masker.dart';

void main() {
  group('LayoutParser Hardening', () {
    test('should process pages independently', () {
      // Page 1: (0, 0.5) "P1"
      // Page 2: (0, 0.5) "P2"
      // If not independent, they might cluster.
      // But they should be separate blocks in order.

      final page1 = const OcrPage(
        pageNumber: 1,
        blocks: [
          OcrBlock(
            text: 'P1',
            x: 0,
            y: 0.5,
            w: 0.1,
            h: 0.1,
            lines: [OcrLine(text: 'P1', x: 0, y: 0.5, w: 0.1, h: 0.1)],
          ),
        ],
      );

      final page2 = const OcrPage(
        pageNumber: 2,
        blocks: [
          OcrBlock(
            text: 'P2',
            x: 0,
            y: 0.5,
            w: 0.1,
            h: 0.1,
            lines: [OcrLine(text: 'P2', x: 0, y: 0.5, w: 0.1, h: 0.1)],
          ),
        ],
      );

      final result = OcrResult(text: '', pages: [page1, page2]);
      final parser = LayoutParser();
      final blocks = parser.parse(result);

      expect(blocks.length, 2);
      expect(blocks[0].rawText, 'P1');
      expect(blocks[1].rawText, 'P2');
    });
  });

  group('PrivacyMasker Hardening', () {
    final masker = PrivacyMasker();

    test('should mask mobile numbers', () {
      expect(
        masker.mask('My number is 13812345678'),
        'My number is 1**********',
      );
    });

    test('should mask ID cards', () {
      expect(masker.mask('ID: 110101199001011234'), 'ID: ******************');
    });

    test('should mask common names (heuristic)', () {
      expect(masker.mask('姓名：张三'), '姓名：张*');
      expect(masker.mask('患者李小龙'), '患者李**');
      expect(masker.mask('医生王五'), '医生王*');
    });

    test('should not mask non-common names or short text', () {
      // 这里的逻辑是只匹配预定义的 20 个大姓
      expect(masker.mask('某个不知名人士'), '某个不知名人士');
    });
  });
}
