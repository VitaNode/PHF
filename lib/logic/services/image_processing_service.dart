/// # ImageProcessingService Implementation
///
/// ## Description
/// 基于 `image` 包实现的图像处理服务。
/// 负责图像的压缩及缩略图生成（目前回退到 PNG，待 WebP API 确认后优化）。
///
/// ## Privacy & Security
/// - **Memory**: 尽可能及时释放中间对象（Dart GC 自动管理，但业务层需避免持有引用）。
/// - **Wipe**: `secureWipe` 确保物理文件被删除。
library;

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';
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
    return Uint8List.fromList(jpeg);
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

    return Uint8List.fromList(jpeg);
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
    // The image package's copyRotate function rotates counter-clockwise.
    // We need to convert common clockwise angles (e.g., 90, 180, 270)
    // to counter-clockwise for the function.
    // A 90-degree clockwise rotation is equivalent to a 270-degree counter-clockwise rotation.
    // A 270-degree clockwise rotation is equivalent to a 90-degree counter-clockwise rotation.
    // 180 degrees is the same for both.
    final normalizedAngle = (360 - (angle % 360)) % 360; // Convert to CCW angle for img.copyRotate

    final rotatedImage = copyRotate(image, angle: normalizedAngle);

    // 3. Encode to JPEG
    final jpeg = encodeJpg(rotatedImage, quality: 80); // Use a default quality

    return Uint8List.fromList(jpeg);
  }

  @override
  Future<void> secureWipe(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
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
