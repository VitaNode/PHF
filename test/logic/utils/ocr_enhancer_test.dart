import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';
import 'package:phf/logic/utils/ocr_enhancer.dart';

void main() {
  group('OcrEnhancer Tests', () {
    test('Key-Value Splitting (Chinese Colon)', () {
      const line = OcrLine(text: '姓名：张三', x: 0.1, y: 0.1, w: 0.5, h: 0.05);
      const block = OcrBlock(
        text: '姓名：张三',
        x: 0.1,
        y: 0.1,
        w: 0.5,
        h: 0.05,
        lines: [line],
      );
      const result = OcrResult(
        text: '姓名：张三',
        pages: [
          OcrPage(blocks: [block]),
        ],
      );

      final enhanced = OcrEnhancer.enhance(result);
      final enhancedLine = enhanced.blocks.first.lines.first;

      expect(enhancedLine.elements.length, 2);
      expect(enhancedLine.elements[0].text, '姓名');
      expect(enhancedLine.elements[0].type, OcrSemanticType.label);
      expect(enhancedLine.elements[1].text, '张三');
      expect(enhancedLine.elements[1].type, OcrSemanticType.value);
    });

    test('Key-Value Splitting (English Colon)', () {
      const line = OcrLine(text: 'Age: 25', x: 0.1, y: 0.1, w: 0.5, h: 0.05);
      const block = OcrBlock(
        text: 'Age: 25',
        x: 0.1,
        y: 0.1,
        w: 0.5,
        h: 0.05,
        lines: [line],
      );
      const result = OcrResult(
        text: 'Age: 25',
        pages: [
          OcrPage(blocks: [block]),
        ],
      );

      final enhanced = OcrEnhancer.enhance(result);
      final enhancedLine = enhanced.blocks.first.lines.first;

      expect(enhancedLine.elements[0].text, 'Age');
      expect(enhancedLine.elements[1].text, '25');
    });

    test('Section Title Identification', () {
      const line = OcrLine(text: '病理诊断', x: 0.1, y: 0.1, w: 0.2, h: 0.05);
      const block = OcrBlock(
        text: '病理诊断',
        x: 0.1,
        y: 0.1,
        w: 0.2,
        h: 0.05,
        lines: [line],
      );
      const result = OcrResult(
        text: '病理诊断',
        pages: [
          OcrPage(blocks: [block]),
        ],
      );

      final enhanced = OcrEnhancer.enhance(result);
      expect(enhanced.blocks.first.type, OcrSemanticType.sectionTitle);
      expect(
        enhanced.blocks.first.lines.first.type,
        OcrSemanticType.sectionTitle,
      );
    });

    test('Noise Cleaning (Horizontal Lines)', () {
      const line = OcrLine(
        text: '________________',
        x: 0.1,
        y: 0.1,
        w: 0.8,
        h: 0.01,
      );
      const block = OcrBlock(
        text: '________________',
        x: 0.1,
        y: 0.1,
        w: 0.8,
        h: 0.01,
        lines: [line],
      );
      const result = OcrResult(
        text: '...',
        pages: [
          OcrPage(blocks: [block]),
        ],
      );

      final enhanced = OcrEnhancer.enhance(result);
      expect(enhanced.blocks.first.text, isEmpty);
      expect(enhanced.blocks.first.lines.first.text, isEmpty);
    });

    test('Noise Cleaning (Prefix/Suffix)', () {
      const line = OcrLine(text: '|结果：正常~', x: 0.1, y: 0.1, w: 0.5, h: 0.05);
      const block = OcrBlock(
        text: '|结果：正常~',
        x: 0.1,
        y: 0.1,
        w: 0.5,
        h: 0.05,
        lines: [line],
      );
      const result = OcrResult(
        text: '...',
        pages: [
          OcrPage(blocks: [block]),
        ],
      );

      final enhanced = OcrEnhancer.enhance(result);
      final enhancedLine = enhanced.blocks.first.lines.first;
      expect(enhancedLine.text, '结果：正常');
      expect(enhancedLine.elements[0].text, '结果');
      expect(enhancedLine.elements[1].text, '正常');
    });

    test('Normal text remains normal', () {
      const line = OcrLine(
        text: '这是一段普通的医疗描述文本，没有冒号。',
        x: 0.1,
        y: 0.1,
        w: 0.8,
        h: 0.05,
      );
      const block = OcrBlock(
        text: '这是一段普通的医疗描述文本，没有冒号。',
        x: 0.1,
        y: 0.1,
        w: 0.8,
        h: 0.05,
        lines: [line],
      );
      const result = OcrResult(
        text: '...',
        pages: [
          OcrPage(blocks: [block]),
        ],
      );

      final enhanced = OcrEnhancer.enhance(result);
      expect(enhanced.blocks.first.type, OcrSemanticType.normal);
      expect(enhanced.blocks.first.lines.first.elements, isEmpty);
    });
  });
}
