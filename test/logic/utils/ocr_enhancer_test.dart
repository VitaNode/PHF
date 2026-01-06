import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';
import 'package:phf/logic/utils/ocr_enhancer.dart';

void main() {
  group('OCREnhancer Tests', () {
    test('Key-Value Splitting (Chinese Colon)', () {
      const line = OCRLine(text: '姓名：张三', x: 0.1, y: 0.1, w: 0.5, h: 0.05);
      const block = OCRBlock(
        text: '姓名：张三',
        x: 0.1,
        y: 0.1,
        w: 0.5,
        h: 0.05,
        lines: [line],
      );
      const result = OCRResult(text: '姓名：张三', blocks: [block]);

      final enhanced = OCREnhancer.enhance(result);
      final enhancedLine = enhanced.blocks.first.lines.first;

      expect(enhancedLine.elements.length, 2);
      expect(enhancedLine.elements[0].text, '姓名');
      expect(enhancedLine.elements[0].type, OCRSemanticType.label);
      expect(enhancedLine.elements[1].text, '张三');
      expect(enhancedLine.elements[1].type, OCRSemanticType.value);
    });

    test('Key-Value Splitting (English Colon)', () {
      const line = OCRLine(text: 'Age: 25', x: 0.1, y: 0.1, w: 0.5, h: 0.05);
      const block = OCRBlock(
        text: 'Age: 25',
        x: 0.1,
        y: 0.1,
        w: 0.5,
        h: 0.05,
        lines: [line],
      );
      const result = OCRResult(text: 'Age: 25', blocks: [block]);

      final enhanced = OCREnhancer.enhance(result);
      final enhancedLine = enhanced.blocks.first.lines.first;

      expect(enhancedLine.elements[0].text, 'Age');
      expect(enhancedLine.elements[1].text, '25');
    });

    test('Section Title Identification', () {
      const line = OCRLine(text: '病理诊断', x: 0.1, y: 0.1, w: 0.2, h: 0.05);
      const block = OCRBlock(
        text: '病理诊断',
        x: 0.1,
        y: 0.1,
        w: 0.2,
        h: 0.05,
        lines: [line],
      );
      const result = OCRResult(text: '病理诊断', blocks: [block]);

      final enhanced = OCREnhancer.enhance(result);
      expect(enhanced.blocks.first.type, OCRSemanticType.sectionTitle);
      expect(
        enhanced.blocks.first.lines.first.type,
        OCRSemanticType.sectionTitle,
      );
    });

    test('Normal text remains normal', () {
      const line = OCRLine(
        text: '这是一段普通的医疗描述文本，没有冒号。',
        x: 0.1,
        y: 0.1,
        w: 0.8,
        h: 0.05,
      );
      const block = OCRBlock(
        text: '这是一段普通的医疗描述文本，没有冒号。',
        x: 0.1,
        y: 0.1,
        w: 0.8,
        h: 0.05,
        lines: [line],
      );
      const result = OCRResult(text: '...', blocks: [block]);

      final enhanced = OCREnhancer.enhance(result);
      expect(enhanced.blocks.first.type, OCRSemanticType.normal);
      expect(enhanced.blocks.first.lines.first.elements, isEmpty);
    });
  });
}
