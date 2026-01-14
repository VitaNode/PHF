import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';
import 'package:phf/logic/services/slm/layout_parser.dart';

void main() {
  group('LayoutParser', () {
    test('should sort lines by Y then X', () {
      // Mock data: 2 lines, 2 columns
      // Row 1: (0,0) "A", (10,0) "B"
      // Row 2: (0,10) "C", (10,10) "D"
      // Input order: D, A, C, B (Mixed)

      final lines = [
        const OcrLine(
          text: 'D',
          x: 0.5,
          y: 0.5,
          w: 0.4,
          h: 0.1,
        ), // Row 2, Col 2
        const OcrLine(
          text: 'A',
          x: 0.0,
          y: 0.0,
          w: 0.4,
          h: 0.1,
        ), // Row 1, Col 1
        const OcrLine(
          text: 'C',
          x: 0.0,
          y: 0.5,
          w: 0.4,
          h: 0.1,
        ), // Row 2, Col 1
        const OcrLine(
          text: 'B',
          x: 0.5,
          y: 0.0,
          w: 0.4,
          h: 0.1,
        ), // Row 1, Col 2
      ];

      final block = OcrBlock(text: '', x: 0, y: 0, w: 1, h: 1, lines: lines);

      final page = OcrPage(blocks: [block]);
      final result = OcrResult(text: '', pages: [page]);

      final parser = LayoutParser();
      final blocks = parser.parse(result);

      expect(blocks.length, 4);
      expect(blocks[0].rawText, 'A');
      expect(blocks[1].rawText, 'B');
      expect(blocks[2].rawText, 'C');
      expect(blocks[3].rawText, 'D');
    });

    test('should handle slightly misaligned rows', () {
      // Row 1: y=0.0
      // Row 1 (misaligned): y=0.02 (height=0.1, threshold=0.05)
      // Should be grouped together

      final lines = [
        const OcrLine(text: 'Aligned', x: 0.0, y: 0.0, w: 0.4, h: 0.1),
        const OcrLine(text: 'Misaligned', x: 0.5, y: 0.02, w: 0.4, h: 0.1),
      ];

      final block = OcrBlock(text: '', x: 0, y: 0, w: 1, h: 1, lines: lines);
      final page = OcrPage(blocks: [block]);
      final result = OcrResult(text: '', pages: [page]);

      final parser = LayoutParser();
      final blocks = parser.parse(result);

      // Should be 1 row, so order depends on X
      expect(blocks.length, 2);
      expect(blocks[0].rawText, 'Aligned');
      expect(blocks[1].rawText, 'Misaligned');
    });
  });
}
