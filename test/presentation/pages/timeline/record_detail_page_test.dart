
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/data/models/image.dart';
import 'package:phf/data/models/record.dart';
import 'package:phf/data/repositories/interfaces/image_repository.dart';
import 'package:phf/data/repositories/interfaces/record_repository.dart';
import 'package:phf/presentation/pages/timeline/record_detail_page.dart';
import 'package:phf/logic/providers/core_providers.dart';
import 'package:phf/presentation/widgets/secure_image.dart';

import 'package:phf/core/security/file_security_helper.dart';
import 'package:phf/core/services/path_provider_service.dart';
import 'dart:convert';

@GenerateNiceMocks([
  MockSpec<IRecordRepository>(),
  MockSpec<IImageRepository>(),
  MockSpec<FileSecurityHelper>(),
  MockSpec<PathProviderService>(),
])
import 'record_detail_page_test.mocks.dart';

void main() {
  late MockIRecordRepository mockRecordRepo;
  late MockIImageRepository mockImageRepo;
  late MockFileSecurityHelper mockFileHelper;
  late MockPathProviderService mockPathService;

  setUp(() {
    mockRecordRepo = MockIRecordRepository();
    mockImageRepo = MockIImageRepository();
    mockFileHelper = MockFileSecurityHelper();
    mockPathService = MockPathProviderService();
    
    when(mockPathService.sandboxRoot).thenReturn('/tmp');
    final validPng = base64Decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==');
    when(mockFileHelper.decryptDataFromFile(any, any))
        .thenAnswer((_) async => validPng);
  });

  Widget createSubject(String recordId) {
    return ProviderScope(
      overrides: [
        recordRepositoryProvider.overrideWithValue(mockRecordRepo),
        imageRepositoryProvider.overrideWithValue(mockImageRepo),
        fileSecurityHelperProvider.overrideWithValue(mockFileHelper),
        pathProviderServiceProvider.overrideWithValue(mockPathService),
      ],
      child: MaterialApp(
        home: RecordDetailPage(recordId: recordId),
      ),
    );
  }

  testWidgets('RecordDetailPage displays metadata and images', (tester) async {
    const recordId = 'r1';
    final record = MedicalRecord(
      id: recordId,
      personId: 'p1',
      hospitalName: 'Detail Hospital',
      notedAt: DateTime(2023, 10, 1, 10, 0),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      notes: 'Some notes',
      tagsCache: '["Tag1", "Tag2"]',
      status: RecordStatus.archived,
    );

    final image = MedicalImage(
      id: 'i1',
      recordId: recordId,
      encryptionKey: 'key',
      thumbnailEncryptionKey: 'thumb_key',
      filePath: 'path/to/img.enc',
      thumbnailPath: 'path/to/thumb.enc',
      createdAt: DateTime.now(),
    );

    when(mockRecordRepo.getRecordById(recordId))
        .thenAnswer((_) async => record);
    when(mockImageRepo.getImagesForRecord(recordId))
        .thenAnswer((_) async => [image]);

    await tester.pumpWidget(createSubject(recordId));
    await tester.pumpAndSettle();

    // Verify Metadata
    expect(find.text('Detail Hospital'), findsOneWidget);
    expect(find.text('2023-10-01'), findsOneWidget); // DateFormat changed to yyyy-MM-dd
    expect(find.text('Some notes'), findsNothing); // Notes removed from detail view in T16
    expect(find.text('Tag1'), findsNothing); // Record-level Tags removed from split-view detail
    expect(find.text('Tag2'), findsNothing);

    // Verify Image Grid
    expect(find.byType(SecureImage), findsOneWidget);
  });

  testWidgets('RecordDetailPage shows error if record not found', (tester) async {
    const recordId = 'r_missing';
    when(mockRecordRepo.getRecordById(recordId))
        .thenAnswer((_) async => null);
    when(mockImageRepo.getImagesForRecord(recordId))
        .thenAnswer((_) async => []);

    await tester.pumpWidget(createSubject(recordId));
    await tester.pumpAndSettle();

    expect(find.text('记录不存在'), findsOneWidget);
  });
}
