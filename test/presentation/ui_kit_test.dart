import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phf/presentation/theme/app_theme.dart';
import 'package:phf/presentation/widgets/active_button.dart';
import 'package:phf/presentation/widgets/security_indicator.dart';

void main() {
  // Helper to pump widget with Theme
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('ActiveButton Tests', () {
    testWidgets('renders text and responds to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(createTestWidget(
        ActiveButton(
          text: 'Click Me',
          onPressed: () => tapped = true,
        ),
      ));

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.byType(ActiveButton));
      expect(tapped, isTrue);
    });

    testWidgets('shows loading indicator and ignores tap when loading', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(createTestWidget(
        ActiveButton(
          text: 'Loading',
          onPressed: () => tapped = true,
          isLoading: true,
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing); // Text is replaced by spinner in current impl
      
      await tester.tap(find.byType(ActiveButton));
      expect(tapped, isFalse);
    });
  });

  group('SecurityIndicator Tests', () {
    testWidgets('displays secure status correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const SecurityIndicator(isSecure: true),
      ));

      expect(find.text('AES-256 Encrypted On-Device'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('displays unverified status correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(
        const SecurityIndicator(isSecure: false),
      ));

      expect(find.text('Encryption Not Verified'), findsOneWidget);
      expect(find.byIcon(Icons.lock_open), findsOneWidget);
    });
  });
}
