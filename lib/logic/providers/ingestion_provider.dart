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
library;

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/image.dart';
import '../../data/models/record.dart';
import 'core_providers.dart';
import 'states/ingestion_state.dart';
import 'timeline_provider.dart';

part 'ingestion_provider.g.dart';

@riverpod
class IngestionController extends _$IngestionController {
  @override
  IngestionState build() {
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
      state = state.copyWith(status: IngestionStatus.error, errorMessage: "需至少包含一张图片");
      return;
    }

    state = state.copyWith(status: IngestionStatus.processing);

    try {
      final recordId = const Uuid().v4();
      final recordRepo = ref.read(recordRepositoryProvider);
      final imageRepo = ref.read(imageRepositoryProvider);
      final fileSecurity = ref.read(fileSecurityHelperProvider);
      final cryptoService = ref.read(cryptoServiceProvider);
      final imageProcessing = ref.read(imageProcessingServiceProvider);
      final pathService = ref.read(pathProviderServiceProvider);
      
      const currentPersonId = 'def_me'; // Phase 1 Single User
      
      final defaultHospital = state.hospitalName ?? '未命名记录';
      final defaultDate = state.visitDate ?? DateTime.now();

      final List<MedicalImage> medicalImages = [];
      
      // Process images concurrently
      await Future.wait(state.rawImages.asMap().entries.map((entry) async {
        final index = entry.key;
        final xFile = entry.value;
        var rawBytes = await xFile.readAsBytes();
        
        // Apply Rotation if needed
        final rotation = state.rotations[index];
        if (rotation != 0) {
           rawBytes = await imageProcessing.rotateImage(data: rawBytes, angle: rotation);
        }

        // 1. Image Processing
        final compressedBytes = await imageProcessing.compressImage(data: rawBytes);
        final thumbnailBytes = await imageProcessing.generateThumbnail(data: rawBytes);
        final dimensions = await imageProcessing.getDimensions(compressedBytes);

        // 2. Encrypt & Save Main File (Generate New Key)
        final fileResult = await fileSecurity.saveEncryptedFile(
          data: compressedBytes, 
          targetDir: pathService.imagesDirPath,
        );
        
        // 3. Encrypt & Save Thumbnail (NEW INDEPENDENT Key - T16.1)
        final thumbResult = await fileSecurity.saveEncryptedFile(
          data: thumbnailBytes,
          targetDir: '${pathService.sandboxRoot}/images/thumbnails',
        );

        // 4. Create Entity
        medicalImages.add(MedicalImage(
          id: const Uuid().v4(),
          recordId: recordId,
          encryptionKey: fileResult.base64Key,
          thumbnailEncryptionKey: thumbResult.base64Key, // Independent key
          filePath: 'images/${fileResult.relativePath}',
          thumbnailPath: 'images/thumbnails/${thumbResult.relativePath}',
          mimeType: 'image/jpeg',
          fileSize: compressedBytes.lengthInBytes,
          displayOrder: index,
          width: dimensions.width,
          height: dimensions.height,
          createdAt: DateTime.now(),
          hospitalName: defaultHospital,
          visitDate: defaultDate,
          tagIds: state.selectedTagIds,
        ));
      }));

      // 5. Create Record
      final record = MedicalRecord(
        id: recordId,
        personId: currentPersonId,
        hospitalName: defaultHospital,
        notes: state.notes,
        notedAt: defaultDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: RecordStatus.archived,
        // images: medicalImages, // Not persisted here
      );
      
      // 6. Transactional Save
      await recordRepo.saveRecord(record);
      await imageRepo.saveImages(medicalImages);
      
      // 7. Sync Aggregated Metadata (New Phase 2 Requirement)
      await recordRepo.syncRecordMetadata(recordId);
      
      // 8. Refresh Timeline & Reset State
      ref.invalidate(timelineControllerProvider);
      state = const IngestionState(status: IngestionStatus.success);
      
    } catch (e) {
      state = state.copyWith(status: IngestionStatus.error, errorMessage: e.toString());
    }
  }
}
