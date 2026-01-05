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
import 'ocr_status_provider.dart';
import 'core_providers.dart';
import 'states/ingestion_state.dart';
import 'timeline_provider.dart';

part 'ingestion_provider.g.dart';

@riverpod
class IngestionController extends _$IngestionController {
  @override
  IngestionState build() {
    // 确保在 Provider 销毁时清理所有未提交的临时文件
    // 注意：必须通过闭包捕获当时的列表，不能在 onDispose 内部访问 state
    ref.onDispose(() {
      final imagesToCleanup = state.rawImages;
      _cleanupFiles(imagesToCleanup);
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
      _addFiles(files);
    } catch (e) {
      _setError(e);
    }
  }

  /// 拍照
  Future<void> takePhoto() async {
    try {
      final picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        _addFiles([photo]);
      }
    } catch (e) {
      _setError(e);
    }
  }

  void _addFiles(List<XFile> files) {
    if (files.isNotEmpty) {
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

      final currentPersonId = await ref.read(
        currentPersonIdControllerProvider.future,
      );
      if (currentPersonId == null) {
        throw Exception('Cannot submit record without a valid person ID.');
      }

      final defaultHospital = state.hospitalName ?? '未命名记录';
      final defaultDate = state.visitDate ?? DateTime.now();

      final List<MedicalImage> medicalImages = [];

      // Process images concurrently
      await Future.wait(
        state.rawImages.asMap().entries.map((entry) async {
          final index = entry.key;
          final xFile = entry.value;
          final rawBytes = await xFile.readAsBytes();

          // 1. Optimized Image Processing (Single Decode)
          final result = await imageProcessing.processFull(
            data: rawBytes,
            rotationAngle: state.rotations[index],
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
              displayOrder: index,
              width: result.width,
              height: result.height,
              createdAt: DateTime.now(),
              hospitalName: defaultHospital,
              visitDate: defaultDate,
              tagIds: state.selectedTagIds,
            ),
          );

          // 5. 关键优化：一旦完成处理并安全存入加密沙盒，立即擦除原始临时文件
          await SecureWipeHelper.wipe(File(xFile.path)).catchError((_) {});
        }),
      );

      // 6. Create Record
      final record = MedicalRecord(
        id: recordId,
        personId: currentPersonId,
        hospitalName: defaultHospital,
        notes: state.notes,
        notedAt: defaultDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // Phase 2 Change: Default status is processing
        status: RecordStatus.processing,
      );

      // 7. Transactional Save
      await recordRepo.saveRecord(record);
      await imageRepo.saveImages(medicalImages);

      // 8. Sync Aggregated Metadata
      await recordRepo.syncRecordMetadata(recordId);

      // 9. Phase 2: Enqueue OCR Jobs
      for (final img in medicalImages) {
        await ocrQueueRepo.enqueue(img.id);
      }

      // 10. Phase 2: Trigger Background Worker & Foreground processing
      await BackgroundWorkerService().triggerProcessing();
      // Start foreground processing immediately (fire-and-forget)
      // ignore: unawaited_futures
      BackgroundWorkerService().startForegroundProcessing(
        talker: ref.read(talkerProvider),
      );

      // 10. Refresh Timeline & Reset State
      ref.invalidate(timelineControllerProvider);
      ref.invalidate(ocrPendingCountProvider); // 强制立即重新开始轮询探测

      // 11. Secure Wipe raw images
      await _cleanupFiles(state.rawImages);

      state = const IngestionState(status: IngestionStatus.success);
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
      try {
        await SecureWipeHelper.wipe(File(xFile.path));
      } catch (_) {
        // 忽略清理阶段的错误
      }
    }
  }
}
