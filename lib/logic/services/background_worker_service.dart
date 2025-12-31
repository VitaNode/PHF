/// # BackgroundWorkerService
///
/// ## Description
/// 管理 Android 端的后台任务调度 (基于 `workmanager`).
/// 负责在应用切后台或被杀进程后，继续执行队列中的 OCR 任务。
///
/// ## Mechanics
/// - **Dispatcher**: `callbackDispatcher` 运行在独立 Isolate。
/// - **Dependency Injection**: 必须在 Isolate 内部手动重建所有依赖服务 (DB, Repo, OCRService)。
/// - **Task**: `ocr_processing_task`。
///
/// ## Security
/// - 依赖 `MasterKeyManager` 获取密钥。如果设备锁定导致 Keychain 不可读，任务将捕获异常并返回重试状态。
library;

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

// Imports for DI reconstruction
import '../../core/security/master_key_manager.dart';
import '../../core/security/file_security_helper.dart';
import '../../core/services/path_provider_service.dart';
import '../../data/datasources/local/database_service.dart';
import '../../data/repositories/image_repository.dart';
import '../../data/repositories/ocr_queue_repository.dart';
import '../../data/repositories/record_repository.dart';
import '../../data/repositories/search_repository.dart';
import '../services/android_ocr_service.dart';
import '../services/ocr_processor.dart';

// CryptoService implementation for DI
import '../services/crypto_service.dart';

const String _ocrTaskName = 'com.example.phf.ocr.processing_task';
const String _uniqueWorkName = 'PHF_OCR_WORKER';

/// Top-level function for background execution.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == _ocrTaskName) {
        log('Background OCR Worker Started', name: 'BackgroundWorker');
        
        // 1. Rebuild Dependencies
        // SecureStorage is handled internally by MasterKeyManager default constructor
        // PathProvider needed only for standard paths if MasterKeyManager needed? 
        // No, MasterKeyManager uses storage. PathProvider is for DatabaseService.
        
        final pathService = PathProviderService();
        // Initialize path provider? Note: PathProviderService might rely on getApplicationDocumentsDirectory
        // which works in background via MethodChannel.
        
        final keyManager = MasterKeyManager();
        
        // Database
        final dbService = SQLCipherDatabaseService(
          keyManager: keyManager, 
          pathService: pathService
        );

        // Basic Services
        final cryptoService = CryptoService();
        final fileSecurityHelper = FileSecurityHelper(cryptoService: cryptoService);

        // Repositories
        final ocrQueueRepo = OCRQueueRepository(dbService);
        final imageRepo = ImageRepository(dbService);
        final recordRepo = RecordRepository(dbService);
        final searchRepo = SearchRepository(dbService);

        // OCR Service (Platform Specific - assuming Android per task scope)
        // If running on iOS via workmanager, this might need check, but T19.4 is separate.
        // T19.3 is Android focused.
        final ocrService = AndroidOCRService();

        // Processor
        final processor = OCRProcessor(
          queueRepository: ocrQueueRepo,
          imageRepository: imageRepo,
          recordRepository: recordRepo,
          searchRepository: searchRepo,
          ocrService: ocrService,
          securityHelper: fileSecurityHelper,
        );

        // 2. Process Queue
        // Keep processing until queue empty or timeout risk? 
        // WorkManager allows ~10 mins. We process a batch.
        // Let's try processing up to 5 items to be safe.
        int processedCount = 0;
        bool hasMore = true;
        
        while (hasMore && processedCount < 10) {
          hasMore = await processor.processNextItem();
          if (hasMore) processedCount++;
        }

        log('Background OCR Worker Finished. Processed: $processedCount', name: 'BackgroundWorker');
      }
      return Future.value(true);
      
    } catch (err, stack) {
      log('Background OCR Worker Error', error: err, stackTrace: stack, name: 'BackgroundWorker');
      // Return false to indicate failure (may trigger retry based on constraints)
      return Future.value(false); 
    }
  });
}

class BackgroundWorkerService {
  static final BackgroundWorkerService _instance = BackgroundWorkerService._internal();
  factory BackgroundWorkerService() => _instance;
  BackgroundWorkerService._internal();

  /// 初始化 WorkManager
  Future<void> initialize() async {
    // 仅在 Android 上初始化 (iOS tbd in T19.4)
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode, // Debug shows notifications
      );
      log('WorkManager Initialized', name: 'BackgroundWorkerService');
    }
  }

  /// 触发一次性立即执行的任务 (例如：用户添加图片后)
  Future<void> triggerProcessing() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Workmanager().registerOneOffTask(
        '$_uniqueWorkName-${DateTime.now().millisecondsSinceEpoch}',
        _ocrTaskName,
        constraints: Constraints(
          networkType: NetworkType.not_required, // 本地 OCR，无需网络
          requiresBatteryNotLow: true,
        ),
        existingWorkPolicy: ExistingWorkPolicy.append, // Append new requests
      );
    }
  }
}
