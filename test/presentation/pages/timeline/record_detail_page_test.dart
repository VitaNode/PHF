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
import 'package:phf/logic/providers/ocr_status_provider.dart';
import 'package:phf/logic/providers/person_provider.dart';
import 'package:phf/presentation/widgets/secure_image.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phf/generated/l10n/app_localizations.dart';

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

class MockCurrentPersonIdController extends CurrentPersonIdController {
  final String id;
  MockCurrentPersonIdController(this.id);
  @override
  Future<String?> build() async => id;
}

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
    final validPng = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==',
    );
    when(
      mockFileHelper.decryptDataFromFile(any, any),
    ).thenAnswer((_) async => validPng);
  });

  Widget createSubject(String recordId) {
    return ProviderScope(
      overrides: [
        recordRepositoryProvider.overrideWithValue(mockRecordRepo),
        imageRepositoryProvider.overrideWithValue(mockImageRepo),
        fileSecurityHelperProvider.overrideWithValue(mockFileHelper),
        pathProviderServiceProvider.overrideWithValue(mockPathService),
        currentPersonIdControllerProvider.overrideWith(
          () => MockCurrentPersonIdController('p1'),
        ),
        ocrPendingCountProvider.overrideWith((ref) => Stream.value(0)),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh'),
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

    when(
      mockRecordRepo.getRecordById(recordId),
    ).thenAnswer((_) async => record);
    when(
      mockImageRepo.getImagesForRecord(recordId),
    ).thenAnswer((_) async => [image]);

    await tester.pumpWidget(createSubject(recordId));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Metadata
    expect(find.text('Detail Hospital'), findsOneWidget);
    expect(
      find.text('2023-10-01'),
      findsOneWidget,
    ); // DateFormat changed to yyyy-MM-dd
    expect(
      find.text('Some notes'),
      findsNothing,
    ); // Notes removed from detail view in T16
    expect(
      find.text('Tag1'),
      findsNothing,
    ); // Record-level Tags removed from split-view detail
    expect(find.text('Tag2'), findsNothing);

    // Verify Image Grid
    expect(find.byType(SecureImage), findsOneWidget);
  });

  testWidgets('RecordDetailPage shows error if record not found', (
    tester,
  ) async {
    const recordId = 'r_missing';
    when(mockRecordRepo.getRecordById(recordId)).thenAnswer((_) async => null);
    when(
      mockImageRepo.getImagesForRecord(recordId),
    ).thenAnswer((_) async => []);

    await tester.pumpWidget(createSubject(recordId));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('记录不存在'), findsOneWidget);
  });

  testWidgets('RecordDetailPage allows viewing OCR text', (tester) async {
    const recordId = 'r1';
    final record = MedicalRecord(
      id: recordId,
      personId: 'p1',
      notedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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
      ocrText: 'Recognized Text Content',
    );

    when(
      mockRecordRepo.getRecordById(recordId),
    ).thenAnswer((_) async => record);
    when(
      mockImageRepo.getImagesForRecord(recordId),
    ).thenAnswer((_) async => [image]);

    await tester.pumpWidget(createSubject(recordId));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Collapsible card is present
    // Note: CollapsibleOcrCard might still use hardcoded text internally,
    // but the tooltip and BottomSheet should be localized.
    expect(find.text('OCR 识别文本'), findsOneWidget);

    // Find OCR button and tap
    await tester.tap(find.byIcon(Icons.description_outlined));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Bottom Sheet content
    expect(find.text('识别结果'), findsOneWidget);
    // There are now 2 instances: one in CollapsibleOcrCard and one in Bottom Sheet
    expect(find.text('Recognized Text Content'), findsNWidgets(2));
  });

  testWidgets('RecordDetailPage allows editing and saving metadata', (
    tester,
  ) async {
    const recordId = 'r1';
    final image = MedicalImage(
      id: 'i1',
      recordId: recordId,
      encryptionKey: 'key',
      thumbnailEncryptionKey: 'thumb_key',
      filePath: 'path/to/img.enc',
      thumbnailPath: 'path/to/thumb.enc',
      createdAt: DateTime.now(),
      hospitalName: 'Old Hospital',
      visitDate: DateTime(2023, 10, 1),
    );

    final record = MedicalRecord(
      id: recordId,
      personId: 'p1',
      hospitalName: 'Old Hospital',
      notedAt: DateTime(2023, 10, 1),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: RecordStatus.archived,
      images: [image],
    );

    when(
      mockRecordRepo.getRecordById(recordId),
    ).thenAnswer((_) async => record);
    when(
      mockImageRepo.getImagesForRecord(recordId),
    ).thenAnswer((_) async => [image]);
    when(
      mockImageRepo.updateImageMetadata(
        'i1',
        hospitalName: anyNamed('hospitalName'),
        visitDate: anyNamed('visitDate'),
      ),
    ).thenAnswer((_) async {});
    when(
      mockRecordRepo.updateRecordMetadata(
        recordId,
        hospitalName: anyNamed('hospitalName'),
        visitDate: anyNamed('visitDate'),
      ),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(createSubject(recordId));
    await tester.pump(const Duration(milliseconds: 500));

    final BuildContext context = tester.element(find.byType(RecordDetailPage));
    final l10n = AppLocalizations.of(context)!;

    // 1. Enter edit mode
    await tester.tap(find.text(l10n.detail_edit_page));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // 2. Change hospital name
    // Find the first TextField (Hospital)
    expect(find.byType(TextField), findsAtLeastNWidgets(1));
    await tester.enterText(find.byType(TextField).first, 'New Hospital');

    // 3. Save
    await tester.tap(find.text(l10n.common_save));
    await tester.pumpAndSettle();

    // Verify repository calls
    verify(
      mockImageRepo.updateImageMetadata(
        'i1',
        hospitalName: 'New Hospital',
        visitDate: anyNamed('visitDate'),
      ),
    ).called(1);

    verify(
      mockRecordRepo.updateRecordMetadata(
        recordId,
        hospitalName: anyNamed('hospitalName'),
        visitDate: anyNamed('visitDate'),
      ),
    ).called(1);

    expect(find.text(l10n.detail_edit_page), findsOneWidget);
  });
}
