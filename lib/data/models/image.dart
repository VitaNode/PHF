/// # Image Entity
///
/// ## Description
/// 医疗记录中的每一张独立图片及其元数据。
///
/// ## Fields
/// - `id`: 唯一标识 (UUID).
/// - `recordId`: 所属 Record 的 ID.
/// - `encryptionKey`: 针对该图片的 256-bit AES 密钥 (Base64 编码存储).
/// - `filePath`: 加密后的原始图文件相对路径.
/// - `thumbnailPath`: 加密后的缩略图文件相对路径.
/// - `mimeType`: 文件 MIME 类型 (默认 image/webp).
/// - `fileSize`: 文件大小 (字节).
/// - `displayOrder`: 在 Record 中的显示顺序.
/// - `width`, `height`: 原始图像素尺寸.
/// - `ocrText`: OCR 识别出的全文文本.
/// - `ocrRawJson`: OCR 识别的原始结构化数据 (JSON).
/// - `ocrConfidence`: OCR 识别的置信度评分.
/// - `createdAt`: 图片录入时间.
/// - `tags`: 该图片关联的标签列表 (非数据库字段, 内存聚合).
///
/// ## Security & Privacy
/// - 符合 `Constitution#VI. Security`：每张图片使用独立随机密钥。
/// - 符合 `Spec#4.1 IV Management`：IV 存储在物理文件头部，故此处不存储 IV。
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'tag.dart';

part 'image.freezed.dart';
part 'image.g.dart';

@freezed
abstract class MedicalImage with _$MedicalImage {
  const factory MedicalImage({
    required String id,
    required String recordId,
    required String encryptionKey,
    required String thumbnailEncryptionKey,
    required String filePath,
    required String thumbnailPath,
    @Default('image/jpeg') String mimeType,
    @Default(0) int fileSize,
    @Default(0) int displayOrder,
    int? width,
    int? height,
    
    // OCR Results
    String? ocrText,
    String? ocrRawJson,
    double? ocrConfidence,

    required DateTime createdAt,
    String? hospitalName,
    DateTime? visitDate,
    
    /// 数据库存储的 Tag IDs (JSON List from DB)
    @Default([]) List<String> tagIds,

    /// 内存关联字段，不直接参与数据库简单序列化
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([]) List<Tag> tags,
  }) = _MedicalImage;

  factory MedicalImage.fromJson(Map<String, dynamic> json) => _$MedicalImageFromJson(json);
}
