import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/pages/settings/backup_page.dart';

@GenerateNiceMocks([MockSpec<AppMetaRepository>()])
import 'backup_page_test.mocks.dart';

void main() {
  late MockAppMetaRepository mockMetaRepo;

  setUp(() {
    mockMetaRepo = MockAppMetaRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [appMetaRepositoryProvider.overrideWithValue(mockMetaRepo)],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('zh'),
        home: BackupPage(),
      ),
    );
  }

  testWidgets('BackupPage renders correctly', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('备份与恢复'), findsOneWidget);
    expect(find.text('安全加密备份'), findsOneWidget);
    expect(find.text('导出当前数据'), findsOneWidget);
    expect(find.text('恢复备份数据'), findsOneWidget);
  });

  testWidgets('Export button shows PIN dialog', (tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('导出当前数据'));
    await tester.pumpAndSettle();

    expect(find.text('确认 PIN 码以加密导出'), findsOneWidget);
  });

  testWidgets('Import button shows warning dialog', (tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('恢复备份数据'));
    await tester.pumpAndSettle();

    expect(find.text('确认恢复备份？'), findsOneWidget);
    expect(find.text('确认覆盖'), findsOneWidget);
  });
}
