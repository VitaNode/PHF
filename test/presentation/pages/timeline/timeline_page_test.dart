
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/data/repositories/interfaces/image_repository.dart';
import 'package:phf/data/repositories/interfaces/record_repository.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/pages/timeline/timeline_page.dart';
import 'package:phf/presentation/widgets/event_card.dart';

@GenerateNiceMocks([
  MockSpec<IRecordRepository>(),
  MockSpec<IImageRepository>(),
])
import 'timeline_page_test.mocks.dart';

void main() {
  late MockIRecordRepository mockRecordRepo;
  late MockIImageRepository mockImageRepo;

  setUp(() {
    mockRecordRepo = MockIRecordRepository();
    mockImageRepo = MockIImageRepository();
  });

  Widget createSubject() {
    return ProviderScope(
      overrides: [
        recordRepositoryProvider.overrideWithValue(mockRecordRepo),
        imageRepositoryProvider.overrideWithValue(mockImageRepo),
      ],
      child: const MaterialApp(
        home: Scaffold(body: TimelinePage()),
      ),
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

    when(mockRecordRepo.getRecordsByPerson(any))
        .thenAnswer((_) async => [record]);
    when(mockRecordRepo.getPendingCount(any))
        .thenAnswer((_) async => 0);
    when(mockImageRepo.getImagesForRecord(any))
        .thenAnswer((_) async => []);

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle(); // Wait for FutureBuilder

    expect(find.byType(EventCard), findsOneWidget);
    expect(find.text('Test Hospital'), findsOneWidget);
  });

  testWidgets('Timeline displays empty state when no records', (tester) async {
    when(mockRecordRepo.getRecordsByPerson(any))
        .thenAnswer((_) async => []);
    when(mockRecordRepo.getPendingCount(any))
        .thenAnswer((_) async => 0);

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.textContaining('暂无记录'), findsOneWidget);
  });

  testWidgets('Timeline displays pending banner when pendingCount > 0', (tester) async {
    when(mockRecordRepo.getRecordsByPerson(any))
        .thenAnswer((_) async => []);
    when(mockRecordRepo.getPendingCount(any))
        .thenAnswer((_) async => 5);

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('有 5 项病历待确认'), findsOneWidget);
  });
}
