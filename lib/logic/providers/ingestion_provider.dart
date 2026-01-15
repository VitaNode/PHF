/// # Ingestion Provider
///
/// ## Description
/// 管理病历录入流程的状态。
///
/// ## Logic
/// - `pickImages`: 调用 GalleryService 选择图片。
/// - `submit`:
///    1. 创建 Record 实体。
///    2. 并发处理所有图片 (Compress + Encrypt + Save)。
///    3. 保存 Record。
///    4. 触发 Timeline 刷新。
///
/// ## Repair Logs
/// - [2025-12-31] 优化：实现即时物理擦除机制。图片处理并加密存入沙盒后立即擦除原始临时文件；在 `removeImage` 及 `onDispose` 时强制执行清理，确保隐私数据不滞留在系统临时目录。
/// - [2025-12-31] 性能：在 `submit` 中切换为 `processFull` 一站式处理，将多张图片录入时的内存峰值解码次数减少 66%，显著降低 OOM 风险。
library;

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/image.dart';
import 'person_provider.dart';
import '../../data/models/record.dart';
import '../services/background_worker_service.dart';
import '../utils/secure_wipe_helper.dart';
import '../providers/logging_provider.dart';
import 'native_plugins_provider.dart';
import 'ocr_status_provider.dart';
import 'core_providers.dart';
import 'states/ingestion_state.dart';
import 'timeline_provider.dart';

part 'ingestion_provider.g.dart';

@riverpod
class IngestionController extends _$IngestionController {
  final Set<String> _pathsToCleanup = {};

  @override
  IngestionState build() {
    ref.onDispose(() {
      try {
        if (_pathsToCleanup.isEmpty) return;
        for (final path in _pathsToCleanup) {
          SecureWipeHelper.wipe(File(path)).catchError((_) {});
        }
        _pathsToCleanup.clear();
      } catch (_) {
        // Ignore potential assertion errors during dispose to prevent crash
      }
    });
    return const IngestionState();
  }

  void updateHospital(String name) {
    state = state.copyWith(hospitalName: name);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(visitDate: date);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  /// 选择相册图片
  Future<void> pickImages() async {
    try {
      final gallery = ref.read(galleryServiceProvider);
      final files = await gallery.pickImages();
      if (files.isNotEmpty) {
        final processor = ref.read(imageProcessorServiceProvider);
        final processedFiles = <XFile>[];

        for (final xFile in files) {
          try {
            // 1. Apply OpenCV Enhancement with UPLOAD mode (Contrast only)
            final processedPath = await processor.processImage(
              xFile.path,
              mode: 'UPLOAD',
            );
            processedFiles.add(XFile(processedPath));

            _pathsToCleanup.add(xFile.path);
          } catch (e) {
            processedFiles.add(xFile);
          }
        }
        _addFiles(processedFiles);
      }
    } catch (e) {
      _setError(e);
    }
  }

  /// 拍照 (普通拍照模式 - 保留彩色，跳过 OpenCV)
  Future<void> takePhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        // 直接使用原始图片，不接入 OpenCV 增强
        _addFiles([photo]);
        _pathsToCleanup.add(photo.path);
      }
    } catch (e) {
      _setError(e);
    }
  }

  /// 扫描文档 (Native Scanner + OpenCV Enhancer)
  /// 实现方案 A：自动降级 (Fallback)
  Future<void> scanDocuments() async {
    try {
      final scanner = ref.read(documentScannerServiceProvider);
      final paths = await scanner.scanDocument();

      if (paths.isNotEmpty) {
        final processor = ref.read(imageProcessorServiceProvider);
        final processedFiles = <XFile>[];

        for (final path in paths) {
          try {
            final processedPath = await processor.processImage(
              path,
              mode: 'CAMERA',
            );
            processedFiles.add(XFile(processedPath));
            await SecureWipeHelper.wipe(File(path)).catchError((_) {});
          } catch (e) {
            processedFiles.add(XFile(path));
          }
        }
        _addFiles(processedFiles);
      }
    } catch (e) {
      // 方案 A: 针对任何启动错误（如低端机性能不足、系统库缺失等），自动切换到普通拍照
      if (Platform.isAndroid ||
          e.toString().contains('UNSUPPORTED') ||
          e.toString().contains('SCAN_ERROR')) {
        // 设置状态为错误以触发 SnackBar 提示用户，然后立即开启拍照
        state = state.copyWith(
          status: IngestionStatus.error,
          errorMessage: "检测到系统扫描器不可用，已为您开启专业相机模式",
        );
        // 延迟一小会儿执行，确保 UI 能够先响应错误状态（展示 SnackBar）
        Future.delayed(const Duration(milliseconds: 500), () {
          takePhoto();
        });
      } else {
        _setError(e);
      }
    }
  }

  void _addFiles(List<XFile> files) {
    if (files.isNotEmpty) {
      for (final f in files) {
        _pathsToCleanup.add(f.path);
      }
      state = state.copyWith(
        rawImages: [...state.rawImages, ...files],
        rotations: [...state.rotations, ...List.filled(files.length, 0)],
        status: IngestionStatus.idle,
      );
    }
  }

  void rotateImage(int index) {
    final newRotations = [...state.rotations];
    newRotations[index] = (newRotations[index] + 90) % 360;
    state = state.copyWith(rotations: newRotations);
  }

  void _setError(Object e) {
    state = state.copyWith(
      status: IngestionStatus.error,
      errorMessage: e.toString(),
    );
  }

  /// 移除选中的图片
  void removeImage(int index) {
    final xFile = state.rawImages[index];
    _pathsToCleanup.remove(xFile.path);
    // 立即物理擦除被移除的图片，防止隐私泄漏
    SecureWipeHelper.wipe(File(xFile.path)).catchError((_) {});

    final newImages = [...state.rawImages];
    final newRotations = [...state.rotations];
    newImages.removeAt(index);
    newRotations.removeAt(index);
    state = state.copyWith(rawImages: newImages, rotations: newRotations);
  }

  /// 切换标签选中状态
  void toggleTag(String tagId) {
    final current = [...state.selectedTagIds];
    if (current.contains(tagId)) {
      current.remove(tagId);
    } else {
      current.add(tagId);
    }
    state = state.copyWith(selectedTagIds: current);
  }

  /// 标签排序
  void reorderTags(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final current = [...state.selectedTagIds];
    final item = current.removeAt(oldIndex);
    current.insert(newIndex, item);
    state = state.copyWith(selectedTagIds: current);
  }

  /// 切换跨页报告分组状态
  void toggleGroupedReport(bool value) {
    state = state.copyWith(isGroupedReport: value);
  }

  /// 提交保存
  Future<void> submit() async {
    if (state.rawImages.isEmpty) {
      state = state.copyWith(
        status: IngestionStatus.error,
        errorMessage: "需至少包含一张图片",
      );
      return;
    }

    state = state.copyWith(status: IngestionStatus.processing);

    try {
      final recordId = const Uuid().v4();
      final recordRepo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);
      final ocrQueueRepo = ref.read(ocrQueueRepositoryProvider); // T17.4
      final fileSecurity = ref.read(fileSecurityHelperProvider);
      final imageProcessing = ref.read(imageProcessingServiceProvider);
      final pathService = ref.read(pathProviderServiceProvider);
      final dbService = ref.read(databaseServiceProvider);

      final currentPersonId = await ref.read(
        currentPersonIdControllerProvider.future,
      );
      if (currentPersonId == null) {
        throw Exception('Cannot submit record without a valid person ID.');
      }

      final defaultHospital = state.hospitalName ?? '未命名记录';
      final defaultDate = state.visitDate ?? DateTime.now();

      final List<MedicalImage> medicalImages = [];

      // Sequential processing to prevent OOM memory spikes (Issue Fix)
      for (int i = 0; i < state.rawImages.length; i++) {
        final xFile = state.rawImages[i];
        final rawBytes = await xFile.readAsBytes();

        // 1. Optimized Image Processing (Single Decode)
        final result = await imageProcessing.processFull(
          data: rawBytes,
          rotationAngle: state.rotations[i],
          quality: 80,
        );

        // 2. Encrypt & Save Main File (Generate New Key)
        final fileResult = await fileSecurity.saveEncryptedFile(
          data: result.mainBytes,
          targetDir: pathService.imagesDirPath,
        );

        // 3. Encrypt & Save Thumbnail (NEW INDEPENDENT Key - T16.1)
        final thumbDir = '${pathService.sandboxRoot}/images/thumbnails';
        final thumbResult = await fileSecurity.saveEncryptedFile(
          data: result.thumbBytes,
          targetDir: thumbDir,
        );

        // 4. Create Entity
        medicalImages.add(
          MedicalImage(
            id: const Uuid().v4(),
            recordId: recordId,
            encryptionKey: fileResult.base64Key,
            thumbnailEncryptionKey: thumbResult.base64Key, // Independent key
            filePath: 'images/${fileResult.relativePath}',
            thumbnailPath: 'images/thumbnails/${thumbResult.relativePath}',
            mimeType: 'image/jpeg',
            fileSize: result.mainBytes.lengthInBytes,
            displayOrder: i,
            width: result.width,
            height: result.height,
            createdAt: DateTime.now(),
            hospitalName: defaultHospital,
            visitDate: defaultDate,
            tagIds: state.selectedTagIds,
          ),
        );

        // 5. 一旦完成处理并安全存入加密沙盒，立即擦除原始临时文件
        _pathsToCleanup.remove(xFile.path);
        await SecureWipeHelper.wipe(File(xFile.path)).catchError((_) {});
      }

      // 6. Create Record
      final record = MedicalRecord(
        id: recordId,
        personId: currentPersonId,
        isVerified: false,
        groupId: state.isGroupedReport ? recordId : null,
        hospitalName: defaultHospital,
        notes: state.notes,
        notedAt: defaultDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: RecordStatus.processing,
      );

      // 7. 关键修复：将所有数据库写入操作整合进单一顶级事务，避免锁竞争 (Issue #124)
      final db = await dbService.database;
      await db.transaction((txn) async {
        // 显式传递 txn 以确保使用同一连接且不触发死锁
        await recordRepo.saveRecord(record, executor: txn);
        await imageRepo.saveImages(medicalImages, executor: txn);
        await recordRepo.syncRecordMetadata(recordId, executor: txn);

        await ocrQueueRepo.enqueueBatch(
          medicalImages.map((e) => e.id).toList(),
          executor: txn,
        );
      });

      // 8. Phase 2: Trigger Background Worker & Foreground processing
      await BackgroundWorkerService().triggerProcessing();
      // Start foreground processing immediately (fire-and-forget)
      // ignore: unawaited_futures
      BackgroundWorkerService().startForegroundProcessing(
        talker: ref.read(talkerProvider),
      );

      // 9. Refresh Timeline & Reset State
      ref.invalidate(timelineControllerProvider);
      ref.invalidate(ocrPendingCountProvider); // 强制立即重新开始轮询探测

      // 10. Secure Wipe remaining raw images
      final remaining = [...state.rawImages];
      state = const IngestionState(status: IngestionStatus.success);
      await _cleanupFiles(remaining);
    } catch (e) {
      state = state.copyWith(
        status: IngestionStatus.error,
        errorMessage: e.toString(),
      );
      // Cleanup even on error
      await _cleanupFiles(state.rawImages);
    }
  }

  /// 物理擦除所有已加载的原始临时图片
  Future<void> _cleanupFiles(List<XFile> images) async {
    for (final xFile in images) {
      _pathsToCleanup.remove(xFile.path);
      try {
        await SecureWipeHelper.wipe(File(xFile.path));
      } catch (_) {
        // 忽略清理阶段的错误
      }
    }
  }
}
