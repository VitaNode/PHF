/// # GalleryImportService Implementation
///
/// ## Description
/// 相册选择服务的实现。封装 `image_picker` 以提供多图选择能力。
///
/// ## Privacy
/// - 此服务仅负责返回用户选择的文件句柄 (XFile)。
/// - **不**负责文件的持久化或加密。调用者 (Ingestion Logic) 必须负责将文件移动到加密沙盒并清理原始缓存（如果适用）。
library;

import 'package:image_picker/image_picker.dart';
import 'interfaces/gallery_service.dart';

class GalleryImportService implements IGalleryService {
  final ImagePicker _picker;

  GalleryImportService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  Future<List<XFile>> pickImages() async {
    try {
      // limit: nullable, if null user can pick multiple (implementation dependent)
      // On iOS 14+ this uses PHPicker which is privacy preserving (app can't see library).
      final List<XFile> images = await _picker.pickMultiImage();
      return images;
    } catch (e) {
      // Logger.error('Failed to pick images', e);
      // For Phase 1, we rethrow or return empty. Rethrow is better for UI handling.
      throw Exception('Gallery selection failed: $e');
    }
  }
}
