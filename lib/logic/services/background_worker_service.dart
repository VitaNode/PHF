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

import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
import '../services/ios_ocr_service.dart';
import '../services/interfaces/ocr_service.dart';
import '../services/ocr_processor.dart';

// CryptoService implementation for DI
import '../services/crypto_service.dart';

const String _ocrTaskName = 'com.example.phf.ocr.processing_task';
const String _uniqueWorkName = 'PHF_OCR_WORKER';

/// Top-level function for background execution.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final talker = TalkerFlutter.init();
    try {
      if (task == _ocrTaskName) {
        talker.info('[BackgroundWorker] Started');

        final processor = await BackgroundWorkerService()._buildProcessor(
          talker: talker,
        );

        // 2. Process Queue
        int processedCount = 0;
        bool hasMore = true;

        while (hasMore && processedCount < 10) {
          hasMore = await processor.processNextItem();
          if (hasMore) processedCount++;
        }

        talker.info('[BackgroundWorker] Finished. Processed: $processedCount');
      }
      return Future.value(true);
    } catch (err, stack) {
      talker.handle(err, stack, '[BackgroundWorker] Global Error');
      return Future.value(false);
    }
  });
}

class BackgroundWorkerService {
  static final BackgroundWorkerService _instance =
      BackgroundWorkerService._internal();
  factory BackgroundWorkerService() => _instance;
  BackgroundWorkerService._internal();

  Talker? _talker;
  bool _isProcessing = false;

  void setTalker(Talker talker) {
    _talker = talker;
  }

  /// 内部依赖构建逻辑 (Isolate 安全)
  Future<OCRProcessor> _buildProcessor({Talker? talker}) async {
    final pathService = PathProviderService();

    talker?.info('[BackgroundWorkerService] Initializing dependencies...');
    // CRITICAL: Ensure path service is initialized
    await pathService.initialize();
    talker?.info('[BackgroundWorkerService] PathProvider initialized.');

    final keyManager = MasterKeyManager();
    final dbService = SQLCipherDatabaseService(
      keyManager: keyManager,
      pathService: pathService,
    );

    final cryptoService = CryptoService();
    final fileSecurityHelper = FileSecurityHelper(cryptoService: cryptoService);

    final ocrQueueRepo = OCRQueueRepository(dbService);
    final imageRepo = ImageRepository(dbService);
    final recordRepo = RecordRepository(dbService);
    final searchRepo = SearchRepository(dbService);

    IOCRService ocrService;
    if (defaultTargetPlatform == TargetPlatform.android) {
      ocrService = AndroidOCRService(talker: talker);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      ocrService = IOSOCRService(talker: talker);
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    return OCRProcessor(
      queueRepository: ocrQueueRepo,
      imageRepository: imageRepo,
      recordRepository: recordRepo,
      searchRepository: searchRepo,
      ocrService: ocrService,
      securityHelper: fileSecurityHelper,
      pathService: pathService,
      talker: talker,
    );
  }

  /// 初始化 WorkManager
  Future<void> initialize() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Workmanager().initialize(callbackDispatcher);
      _talker?.info(
        '[BackgroundWorkerService] Initialized for ${defaultTargetPlatform.name}',
      );
    }
  }

  /// 启动前台处理循环 (iOS 重点，确保立即执行)
  Future<void> startForegroundProcessing({Talker? talker}) async {
    if (talker != null) _talker = talker;

    if (_isProcessing) {
      _talker?.info(
        '[BackgroundWorkerService] Already processing, skipping...',
      );
      return;
    }

    _isProcessing = true;
    _talker?.info('[BackgroundWorkerService] Starting Foreground OCR Loop');

    try {
      final processor = await _buildProcessor(talker: _talker);

      // 2. Process all pending items
      int count = 0;
      while (await processor.processNextItem()) {
        count++;
      }
      _talker?.info(
        '[BackgroundWorkerService] Foreground OCR Finished. Total processed: $count',
      );
    } catch (e, stack) {
      _talker?.handle(
        e,
        stack,
        '[BackgroundWorkerService] Foreground OCR Error',
      );
    } finally {
      _isProcessing = false;
    }
  }

  /// 触发一次性立即执行的任务
  Future<void> triggerProcessing() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Workmanager().registerOneOffTask(
        '$_uniqueWorkName-${DateTime.now().millisecondsSinceEpoch}',
        _ocrTaskName,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: true,
        ),
        existingWorkPolicy: ExistingWorkPolicy.append,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await Workmanager().registerOneOffTask(
        _ocrTaskName,
        _ocrTaskName,
        existingWorkPolicy: ExistingWorkPolicy.append,
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: true,
        ),
      );
    }
  }
}
