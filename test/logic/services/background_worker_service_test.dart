import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phf/logic/services/background_worker_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanager_platform_interface/workmanager_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakeWorkmanagerPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements WorkmanagerPlatform {
  bool initialized = false;
  String? registeredTaskName;

  @override
  Future<void> initialize(
    Function callbackDispatcher, {
    bool isInDebugMode = false,
  }) async {
    initialized = true;
  }

  @override
  Future<void> registerOneOffTask(
    String uniqueName,
    String taskName, {
    Map<String, dynamic>? inputData,
    Duration? initialDelay,
    Constraints? constraints,
    ExistingWorkPolicy? existingWorkPolicy,
    BackoffPolicy? backoffPolicy,
    Duration? backoffPolicyDelay,
    String? tag,
    OutOfQuotaPolicy? outOfQuotaPolicy,
  }) async {
    registeredTaskName = taskName;
  }
}

void main() {
  late FakeWorkmanagerPlatform fakePlatform;

  setUp(() {
    fakePlatform = FakeWorkmanagerPlatform();
    WorkmanagerPlatform.instance = fakePlatform;
  });

  group('BackgroundWorkerService', () {
    test('Singleton check', () {
      final s1 = BackgroundWorkerService();
      final s2 = BackgroundWorkerService();
      expect(s1, same(s2));
    });

    testWidgets('initialize registers dispatcher on Android', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final service = BackgroundWorkerService();

      await service.initialize();

      expect(fakePlatform.initialized, isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('triggerProcessing registers task on Android', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final service = BackgroundWorkerService();

      await service.triggerProcessing();

      expect(fakePlatform.registeredTaskName,
          'com.example.phf.ocr.processing_task');

      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('initialize registers dispatcher on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final service = BackgroundWorkerService();

      await service.initialize();

      expect(fakePlatform.initialized, isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('triggerProcessing registers task on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final service = BackgroundWorkerService();

      await service.triggerProcessing();

      expect(fakePlatform.registeredTaskName,
          'com.example.phf.ocr.processing_task');

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
