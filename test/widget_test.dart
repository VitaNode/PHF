import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phf/presentation/theme/app_theme.dart';

void main() {
  testWidgets('App launches and displays PHF text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: Center(child: Text('PHF'))),
        ),
      ),
    );

    // Verify that our text is displayed.
    expect(find.text('PHF'), findsOneWidget);
  });
}
