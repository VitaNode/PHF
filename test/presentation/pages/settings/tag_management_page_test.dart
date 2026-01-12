import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/models/person.dart';
import 'package:phf/data/models/tag.dart';
import 'package:phf/data/repositories/interfaces/person_repository.dart';
import 'package:phf/data/repositories/interfaces/tag_repository.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/generated/l10n/app_localizations.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/pages/settings/tag_management_page.dart';

@GenerateNiceMocks([
  MockSpec<ITagRepository>(),
  MockSpec<IPersonRepository>(),
  MockSpec<AppMetaRepository>(),
])
import 'tag_management_page_test.mocks.dart';

void main() {
  late MockITagRepository mockTagRepo;
  late MockIPersonRepository mockPersonRepo;
  late MockAppMetaRepository mockMetaRepo;

  final testPersons = [
    Person(
      id: 'p1',
      nickname: 'Me',
      isDefault: true,
      orderIndex: 0,
      createdAt: DateTime.now(),
    ),
  ];

  final testTags = [
    Tag(
      id: 't1',
      name: 'Prescription',
      color: '#008080',
      isCustom: false,
      createdAt: DateTime.now(),
    ),
    Tag(
      id: 't2',
      name: 'My Report',
      color: '#FF0000',
      personId: 'p1',
      isCustom: true,
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockTagRepo = MockITagRepository();
    mockPersonRepo = MockIPersonRepository();
    mockMetaRepo = MockAppMetaRepository();

    when(mockPersonRepo.getAllPersons()).thenAnswer((_) async => testPersons);
    when(mockMetaRepo.getCurrentPersonId()).thenAnswer((_) async => 'p1');
    when(
      mockTagRepo.getAllTags(personId: anyNamed('personId')),
    ).thenAnswer((_) async => testTags);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        tagRepositoryProvider.overrideWithValue(mockTagRepo),
        personRepositoryProvider.overrideWithValue(mockPersonRepo),
        appMetaRepositoryProvider.overrideWithValue(mockMetaRepo),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('zh'),
        home: TagManagementPage(),
      ),
    );
  }

  testWidgets('TagManagementPage displays list of tags', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Start loading
    await tester.pump(); // Finish loading

    expect(find.text('标签库管理'), findsOneWidget);
    expect(find.text('Prescription'), findsOneWidget);
    expect(find.text('My Report'), findsOneWidget);
    expect(find.text('系统内置'), findsOneWidget);
    expect(find.text('自定义标签'), findsOneWidget);
  });

  testWidgets('System tags do not show edit/delete buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Prescription is system tag, My Report is custom.
    // There should be only 1 edit and 1 delete button (for 'My Report')
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });

  testWidgets('Clicking delete on custom tag shows dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.text('删除标签'), findsOneWidget);
    expect(find.textContaining('确定要删除标签 My Report 吗？'), findsOneWidget);
  });

  testWidgets('Confirming delete calls repository', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    verify(mockTagRepo.deleteTag('t2')).called(1);
  });

  testWidgets('Clicking add fab shows dialog', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('新建标签'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
