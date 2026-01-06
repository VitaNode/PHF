import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phf/data/models/ocr_result.dart';
import 'package:phf/presentation/pages/timeline/widgets/enhanced_ocr_view.dart';

void main() {
  group('EnhancedOcrView Widget Tests', () {
    const mockResult = OcrResult(
      text: 'Header: Value\nNormal Line',
      pages: [
        OcrPage(
          blocks: [
            OcrBlock(
              text: 'Header: Value',
              x: 0,
              y: 0,
              w: 1,
              h: 0.1,
              lines: [
                OcrLine(
                  text: 'Header: Value',
                  x: 0,
                  y: 0,
                  w: 1,
                  h: 0.1,
                  elements: [
                    OcrElement(
                      text: 'Header',
                      x: 0,
                      y: 0,
                      w: 0.4,
                      h: 0.1,
                      type: OcrSemanticType.label,
                    ),
                    OcrElement(
                      text: 'Value',
                      x: 0.4,
                      y: 0,
                      w: 0.6,
                      h: 0.1,
                      type: OcrSemanticType.value,
                    ),
                  ],
                ),
              ],
            ),
            OcrBlock(
              text: 'Normal Line',
              x: 0,
              y: 0.1,
              w: 1,
              h: 0.1,
              lines: [OcrLine(text: 'Normal Line', x: 0, y: 0.1, w: 1, h: 0.1)],
            ),
          ],
        ),
      ],
    );

    testWidgets('Renders structured elements in enhanced mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EnhancedOcrView(result: mockResult, isEnhancedMode: true),
          ),
        ),
      );

      expect(find.textContaining('Header', findRichText: true), findsOneWidget);
      expect(find.textContaining('Value', findRichText: true), findsOneWidget);
      expect(find.text('Normal Line'), findsOneWidget);
    });

    testWidgets('Renders plain text in original mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EnhancedOcrView(result: mockResult, isEnhancedMode: false),
          ),
        ),
      );

      // In original mode, it renders result.text as a single Text widget
      expect(find.text(mockResult.text), findsOneWidget);
    });

    testWidgets('Renders Section Title correctly', (tester) async {
      const sectionResult = OcrResult(
        text: 'SECTION TITLE',
        pages: [
          OcrPage(
            blocks: [
              OcrBlock(
                text: 'SECTION TITLE',
                type: OcrSemanticType.sectionTitle,
                x: 0,
                y: 0,
                w: 1,
                h: 0.1,
                lines: [
                  OcrLine(text: 'SECTION TITLE', x: 0, y: 0, w: 1, h: 0.1),
                ],
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EnhancedOcrView(result: sectionResult, isEnhancedMode: true),
          ),
        ),
      );

      expect(find.text('SECTION TITLE'), findsOneWidget);
    });
  });
}
