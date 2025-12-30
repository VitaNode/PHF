/// # IImageRepository Documentation
///
/// ## Description
/// 医疗图像元数据仓库接口。
///
/// ## Methods
/// - `getImagesForRecord(recordId)`: 获取属于某条记录的所有图像。
/// - `saveImage(image)`: 存储图像元数据及对应的加密密钥。
/// - `syncTags(imageId, tagIds)`: 同步单张图片的标签关联。
///
/// ## Integrity Standards
/// - 符合 `Spec#4.1 Data Schema`：维护 `image_tags` 表的关联一致性。
library;

import '../../../data/models/image.dart';

/// 医疗图像仓储契约
abstract class IImageRepository {
  /// 获取属于特定记录的所有图片元数据
  /// 
  /// 结果应按 `displayOrder` 正序排列。
  Future<List<MedicalImage>> getImagesForRecord(String recordId);

  /// 批量保存图片元数据（通常在一条记录创建时触发）
  Future<void> saveImages(List<MedicalImage> images);

  /// 给特定图片更新标签关联
  /// 
  /// 实现类需负责在 `image_tags` 表中执行增删，并可选地触发 Record 表的 `tags_cache` 更新。
  Future<void> updateImageTags(String imageId, List<String> tagIds);

  /// 删除单张图片元数据
  Future<void> deleteImage(String id);

  /// 更新单张图片的元数据 (医院、日期)
  Future<void> updateImageMetadata(String imageId, {String? hospitalName, DateTime? visitDate});
}
