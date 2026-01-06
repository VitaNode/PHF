import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/data/models/person.dart';
import 'package:phf/data/repositories/interfaces/image_repository.dart';
import 'package:phf/data/repositories/interfaces/record_repository.dart';
import 'package:phf/data/repositories/interfaces/tag_repository.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/logic/providers/ocr_status_provider.dart';
import 'package:phf/logic/providers/person_provider.dart';
import 'package:phf/logic/providers/timeline_provider.dart';
import 'package:phf/presentation/pages/timeline/timeline_page.dart';
import 'package:phf/presentation/widgets/event_card.dart';

@GenerateNiceMocks([
  MockSpec<IRecordRepository>(),
  MockSpec<IImageRepository>(),
  MockSpec<ITagRepository>(),
])
import 'timeline_page_test.mocks.dart';

class MockCurrentPersonIdController extends CurrentPersonIdController {
  final String id;
  MockCurrentPersonIdController(this.id);
  @override
  Future<String?> build() async => id;
}

void main() {
  late MockIRecordRepository mockRecordRepo;
  late MockIImageRepository mockImageRepo;
  late MockITagRepository mockTagRepo;

  setUp(() {
    mockRecordRepo = MockIRecordRepository();
    mockImageRepo = MockIImageRepository();
    mockTagRepo = MockITagRepository();

    when(
      mockTagRepo.getAllTags(personId: anyNamed('personId')),
    ).thenAnswer((_) async => []);
  });

  Widget createSubject({int pendingCount = 0}) {
    return ProviderScope(
      overrides: [
        recordRepositoryProvider.overrideWithValue(mockRecordRepo),
        imageRepositoryProvider.overrideWithValue(mockImageRepo),
        tagRepositoryProvider.overrideWithValue(mockTagRepo),
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
        ocrPendingCountProvider.overrideWith(
          (ref) => Stream.value(pendingCount),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: TimelinePage())),
    );
  }

  testWidgets('Timeline displays records', (tester) async {
    final record = MedicalRecord(
      id: 'r1',
      personId: 'p1',
      hospitalName: 'Test Hospital',
      notedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: RecordStatus.archived,
    );

    when(
      mockRecordRepo.searchRecords(
        personId: anyNamed('personId'),
        query: anyNamed('query'),
        tags: anyNamed('tags'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ),
    ).thenAnswer((_) async => [record]);
    when(mockRecordRepo.getPendingCount(any)).thenAnswer((_) async => 0);
    when(mockImageRepo.getImagesForRecord(any)).thenAnswer((_) async => []);

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.byType(EventCard), findsOneWidget);
    expect(find.text('Test Hospital'), findsOneWidget);
  });

  testWidgets('Timeline displays empty state when no records', (tester) async {
    when(
      mockRecordRepo.searchRecords(
        personId: anyNamed('personId'),
        query: anyNamed('query'),
        tags: anyNamed('tags'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ),
    ).thenAnswer((_) async => []);
    when(mockRecordRepo.getPendingCount(any)).thenAnswer((_) async => 0);

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('暂无记录'), findsOneWidget);
  });

  testWidgets('Timeline displays pending banner when pendingCount > 0', (
    tester,
  ) async {
    when(
      mockRecordRepo.searchRecords(
        personId: anyNamed('personId'),
        query: anyNamed('query'),
        tags: anyNamed('tags'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ),
    ).thenAnswer((_) async => []);
    when(mockRecordRepo.getPendingCount(any)).thenAnswer((_) async => 5);

    await tester.pumpWidget(createSubject(pendingCount: 5));
    await tester.pumpAndSettle();

    expect(find.text('有 5 项病历待确认'), findsOneWidget);
  });

  testWidgets('Timeline search/filter calls repository with correct args', (
    tester,
  ) async {
    final record = MedicalRecord(
      id: 'r1',
      personId: 'p1',
      hospitalName: 'Filtered Hospital',
      notedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: RecordStatus.archived,
    );

    when(
      mockRecordRepo.searchRecords(
        personId: anyNamed('personId'),
        query: anyNamed('query'),
        tags: anyNamed('tags'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      ),
    ).thenAnswer((_) async => [record]);
    when(mockRecordRepo.getPendingCount(any)).thenAnswer((_) async => 0);
    when(mockImageRepo.getImagesForRecord(any)).thenAnswer((_) async => []);

    final container = ProviderContainer(
      overrides: [
        recordRepositoryProvider.overrideWithValue(mockRecordRepo),
        imageRepositoryProvider.overrideWithValue(mockImageRepo),
        tagRepositoryProvider.overrideWithValue(mockTagRepo),
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
        ocrPendingCountProvider.overrideWith((ref) => Stream.value(0)),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: TimelinePage())),
      ),
    );
    await tester.pumpAndSettle();

    // Call search manually
    final start = DateTime(2023, 1, 1);
    final end = DateTime(2023, 12, 31);
    final tags = ['blood'];

    await container
        .read(timelineControllerProvider.notifier)
        .search(query: 'test', tags: tags, startDate: start, endDate: end);
    await tester.pump();

    verify(
      mockRecordRepo.searchRecords(
        personId: 'p1',
        query: 'test',
        tags: tags,
        startDate: start,
        endDate: end,
      ),
    ).called(1);
  });
}
