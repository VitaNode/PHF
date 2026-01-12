import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/pages/onboarding/medical_disclaimer_page.dart';

@GenerateNiceMocks([MockSpec<AppMetaRepository>()])
import 'medical_disclaimer_page_test.mocks.dart';

void main() {
  late MockAppMetaRepository mockRepo;

  setUp(() {
    mockRepo = MockAppMetaRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [appMetaRepositoryProvider.overrideWithValue(mockRepo)],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('zh'),
        home: MedicalDisclaimerPage(),
      ),
    );
  }

  testWidgets(
    'MedicalDisclaimerPage shows disclaimer and button is disabled by default',
    (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('医疗免责声明'), findsOneWidget);
      expect(find.textContaining('欢迎使用 PaperHealth.'), findsOneWidget);
      expect(find.text('同意并继续'), findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    },
  );

  testWidgets('Enabling checkbox enables the button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.enabled, isTrue);
  });

  testWidgets('Clicking Accept calls repository and invalidates provider', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(mockRepo.setDisclaimerAccepted(true)).called(1);
  });
}
