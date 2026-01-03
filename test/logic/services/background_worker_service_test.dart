import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phf/logic/services/background_worker_service.dart';
import 'package:workmanager/workmanager.dart';

// Mock Workmanager? 
// Workmanager is a static/singleton wrapper mostly. We can't easily mock the static calls directly 
// without a wrapper or using a mocking library that supports statics (not standard Mockito).
// However, we can check if initialization logic runs.

// For Integration testing of callbackDispatcher, it's harder as it runs in isolate.
// We will focus on the Service class logic.

void main() {
  group('BackgroundWorkerService', () {
    test('Singleton check', () {
      final s1 = BackgroundWorkerService();
      final s2 = BackgroundWorkerService();
      expect(s1, same(s2));
    });

    // Note: Testing actual Workmanager calls requires flutter_test binding 
    // and potentially platform channel mocking.
    
    testWidgets('initialize registers dispatcher on Android', (tester) async {
       // Platform overriding for test
       debugDefaultTargetPlatformOverride = TargetPlatform.android;
       
       final service = BackgroundWorkerService();
       
       // We can't easily verify Workmanager().initialize was called without mocking the plugin channel.
       // Standard Flutter test practice for plugins: Mock the MethodChannel.
       
       final log = <MethodCall>[];
       TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
           .setMockMethodCallHandler(const MethodChannel('be.tramckrijte.workmanager/foreground_channel_work_manager'), (methodCall) async {
         log.add(methodCall);
         return true;
       });

       await service.initialize();
       
       expect(log, isNotEmpty);
       expect(log.first.method, 'initialize');
       
       debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('triggerProcessing registers task on Android', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      
      final service = BackgroundWorkerService();
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('be.tramckrijte.workmanager/foreground_channel_work_manager'), (methodCall) async {
        log.add(methodCall);
        return true;
      });

      await service.triggerProcessing();
      
      expect(log, isNotEmpty);
      expect(log.first.method, 'registerOneOffTask');
      final args = log.first.arguments as Map;
      expect(args['uniqueName'], contains('PHF_OCR_WORKER'));
      expect(args['taskName'], 'com.example.phf.ocr.processing_task');
      
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('initialize registers dispatcher on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      
      final service = BackgroundWorkerService();
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('be.tramckrijte.workmanager/foreground_channel_work_manager'), (methodCall) async {
        log.add(methodCall);
        return true;
      });

      await service.initialize();
      
      expect(log, isNotEmpty);
      expect(log.first.method, 'initialize');
      
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('triggerProcessing registers task on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      
      final service = BackgroundWorkerService();
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('be.tramckrijte.workmanager/foreground_channel_work_manager'), (methodCall) async {
        log.add(methodCall);
        return true;
      });

      await service.triggerProcessing();
      
      expect(log, isNotEmpty);
      expect(log.first.method, 'registerOneOffTask');
      final args = log.first.arguments as Map;
      // iOS doesn't use uniqueWorkName in the same way, but registerOneOffTask maps to BGTask
      expect(args['taskName'], 'com.example.phf.ocr.processing_task'); 
      
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
