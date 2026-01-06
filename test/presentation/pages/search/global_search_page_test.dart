import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/data/models/search_result.dart';
import 'package:phf/data/models/person.dart';
import 'package:phf/data/repositories/app_meta_repository.dart';
import 'package:phf/data/repositories/interfaces/search_repository.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/logic/providers/person_provider.dart';
import 'package:phf/presentation/pages/search/global_search_page.dart';

@GenerateNiceMocks([
  MockSpec<ISearchRepository>(),
  MockSpec<AppMetaRepository>(),
])
import 'global_search_page_test.mocks.dart';

class MockCurrentPersonIdController extends CurrentPersonIdController {
  final String id;
  MockCurrentPersonIdController(this.id);
  @override
  Future<String?> build() async => id;
}

void main() {
  late MockISearchRepository mockSearchRepo;
  late MockAppMetaRepository mockMetaRepo;

  setUp(() {
    mockSearchRepo = MockISearchRepository();
    mockMetaRepo = MockAppMetaRepository();

    // Default mock behavior for reindexing check
    when(mockMetaRepo.get(any)).thenAnswer((_) async => 'true');
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [
        searchRepositoryProvider.overrideWithValue(mockSearchRepo),
        appMetaRepositoryProvider.overrideWithValue(mockMetaRepo),
        currentPersonIdControllerProvider.overrideWith(
          () => MockCurrentPersonIdController('p1'),
        ),
        currentPersonProvider.overrideWith(
          (ref) => Future.value(
            Person(
              id: 'p1',
              nickname: 'Me',
              isDefault: true,
              createdAt: DateTime.now(),
            ),
          ),
        ),
      ],
      child: const MaterialApp(home: GlobalSearchPage()),
    );
  }

  testWidgets('GlobalSearchPage triggers search on input', (tester) async {
    // Arrange
    final record = MedicalRecord(
      id: 'r1',
      personId: 'p1',
      hospitalName: 'Result Hospital',
      notedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final result = SearchResult(
      record: record,
      snippet: 'Found <b>Hospital</b>',
    );

    when(mockSearchRepo.search(any, any)).thenAnswer((_) async => [result]);

    // Act
    await tester.pumpWidget(createSubject());

    // Find text field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);

    // Enter text
    await tester.enterText(textField, 'Hos');
    await tester.pump(const Duration(milliseconds: 600)); // Wait for debounce

    // Assert
    verify(mockSearchRepo.search('Hos', any)).called(1);
    await tester.pumpAndSettle();

    // Check results
    expect(find.text('Result Hospital'), findsOneWidget);
  });

  testWidgets('GlobalSearchPage shows empty state', (tester) async {
    when(mockSearchRepo.search(any, any)).thenAnswer((_) async => []);

    await tester.pumpWidget(createSubject());
    await tester.enterText(find.byType(TextField), 'Nothing');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.textContaining('未找到相关内容', findRichText: true), findsOneWidget);
  });
}
