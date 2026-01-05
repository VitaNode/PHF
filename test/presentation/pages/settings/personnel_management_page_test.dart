import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/models/person.dart';
import 'package:phf/data/repositories/interfaces/person_repository.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/pages/settings/personnel_management_page.dart';

@GenerateNiceMocks([
  MockSpec<IPersonRepository>(),
  MockSpec<AppMetaRepository>(),
])
import 'personnel_management_page_test.mocks.dart';

void main() {
  late MockIPersonRepository mockPersonRepo;
  late MockAppMetaRepository mockMetaRepo;

  final testPersons = [
    Person(
      id: '1',
      nickname: 'Me',
      isDefault: true,
      orderIndex: 0,
      createdAt: DateTime.now(),
    ),
    Person(
      id: '2',
      nickname: 'Mom',
      isDefault: false,
      orderIndex: 1,
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockPersonRepo = MockIPersonRepository();
    mockMetaRepo = MockAppMetaRepository();

    when(mockPersonRepo.getAllPersons()).thenAnswer((_) async => testPersons);
    when(mockMetaRepo.getCurrentPersonId()).thenAnswer((_) async => '1');
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        personRepositoryProvider.overrideWithValue(mockPersonRepo),
        appMetaRepositoryProvider.overrideWithValue(mockMetaRepo),
      ],
      child: const MaterialApp(home: PersonnelManagementPage()),
    );
  }

  testWidgets('PersonnelManagementPage displays list of persons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Start loading
    await tester.pump(); // Finish loading

    expect(find.text('管理档案'), findsOneWidget);
    expect(find.text('Me'), findsOneWidget);
    expect(find.text('Mom'), findsOneWidget);
    expect(find.text('默认档案'), findsOneWidget);
  });

  testWidgets('Clicking delete on non-default person shows dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    final deleteButtons = find.byIcon(Icons.delete);
    expect(deleteButtons, findsOneWidget); // Only 'Mom' has a delete button

    await tester.tap(deleteButtons);
    await tester.pumpAndSettle();

    expect(find.text('删除档案'), findsOneWidget);
    expect(find.textContaining('确定要删除 "Mom" 吗？'), findsOneWidget);
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

    verify(mockPersonRepo.deletePerson('2')).called(1);
  });

  testWidgets('Clicking add fab shows dialog', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('新建档案'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
