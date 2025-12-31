/// # ImageProcessingService Implementation
///
/// ## Description
/// 基于 `image` 包实现的图像处理服务。
/// 负责图像的压缩及缩略图生成（目前回退到 PNG，待 WebP API 确认后优化）。
///
/// ## Privacy & Security
/// - **Memory**: 尽可能及时释放中间对象（Dart GC 自动管理，但业务层需避免持有引用）。
/// - **Wipe**: `secureWipe` 确保物理文件被删除。
/// ## Repair Logs
/// - [2025-12-31] 优化：新增 `processFull` 方法实现“一站式”图像处理（旋转+压缩+缩略图），将内存解码次数从 3 次降为 1 次，大幅提升大批量图片录入时的性能并降低 OOM 风险。
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
import '../utils/secure_wipe_helper.dart';
import 'interfaces/image_service.dart';

class ImageProcessingService implements IImageService {
  
  @override
  /// 将原始图片数据转换为 WebP 格式
  /// 
  /// [quality] 控制压缩质量。
  Future<Uint8List> compressImage({
    required Uint8List data,
    int quality = 80,
  }) async {
    // 1. Decode generic image
    final image = decodeImage(data);
    if (image == null) {
      throw Exception('Failed to decode image data.');
    }

    // 2. Encode to JPEG
    final jpeg = encodeJpg(image, quality: quality);
    
    // 3. Return as Uint8List
    return jpeg;
  }

  @override
  /// 生成缩略图数据 (WebP 格式)
  Future<Uint8List> generateThumbnail({
    required Uint8List data,
    int width = 200,
  }) async {
    // 1. Decode
    final image = decodeImage(data);
    if (image == null) {
      throw Exception('Failed to decode image data for thumbnail.');
    }

    // 2. Resize
    // copyResize handles aspect ratio automatically if height is not provided
    final thumbnail = copyResize(image, width: width);

    // 3. Encode to JPEG
    final jpeg = encodeJpg(thumbnail, quality: 75);

    return jpeg;
  }

  @override
  /// 旋转图像
  Future<Uint8List> rotateImage({
    required Uint8List data,
    required int angle,
  }) async {
    // 1. Decode
    final image = decodeImage(data);
    if (image == null) {
      throw Exception('Failed to decode image data for rotation.');
    }

    // 2. Rotate
    final normalizedAngle = (360 - (angle % 360)) % 360; 
    final rotatedImage = copyRotate(image, angle: normalizedAngle);

    // 3. Encode to JPEG
    final jpeg = encodeJpg(rotatedImage, quality: 80); 

    return jpeg;
  }

  @override
  Future<ImageProcessingResult> processFull({
    required Uint8List data,
    int? rotationAngle,
    int quality = 80,
    int thumbWidth = 200,
  }) async {
    // 1. 单次解码
    final image = decodeImage(data);
    if (image == null) {
      throw Exception('Failed to decode image data.');
    }

    // 2. 旋转 (如果需要)
    Image processed = image;
    if (rotationAngle != null && rotationAngle != 0) {
      final normalizedAngle = (360 - (rotationAngle % 360)) % 360;
      processed = copyRotate(image, angle: normalizedAngle);
    }

    // 3. 生成主图字节流
    final mainBytes = encodeJpg(processed, quality: quality);

    // 4. 生成缩略图
    final thumb = copyResize(processed, width: thumbWidth);
    final thumbBytes = encodeJpg(thumb, quality: 75);

    return ImageProcessingResult(
      mainBytes: mainBytes,
      thumbBytes: thumbBytes,
      width: processed.width,
      height: processed.height,
    );
  }

  @override
  Future<void> secureWipe(String filePath) async {
    await SecureWipeHelper.wipe(File(filePath));
  }

  @override
  Future<ImageDimensions> getDimensions(Uint8List data) async {
    // Use decodeImageInfo for efficiency if available, or lightweight decode
    // 'image' package decodeInfo might be lighter than full decode
    final info = decodeImage(data); 
    // Note: 'image' package 4.x has decodeImage which decodes fully. 
    // Ideally we want metadata only but for Phase 1 robustness we decode.
    // If strict performance optimization is needed later, look for header parsers.
    
    if (info == null) {
       throw Exception('Failed to decode image info.');
    }
    
    return ImageDimensions(info.width, info.height);
  }
}
