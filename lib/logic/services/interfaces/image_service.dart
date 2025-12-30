/// # IImageService Documentation
///
/// ## Description
/// 图像处理与元数据提取服务接口。
///
/// ## Core Methods
/// - `processSourceImage(sourcePath)`: 处理原始图，生成加密后的文件及缩略图。
/// - `createThumbnail(data)`: 生成 200px 尺寸的 WebP 缩略图字节流。
///
/// ## Privacy Standards
/// - 符合 `Constitution#I. Privacy`：原始位图 (Bitmap/Bytes) 处理完后必须立即从内存释放。
/// - 符合 `Spec#T3.1`：所有临时转换文件必须执行 Secure Wipe。
library;

import 'dart:typed_data';

/// 图像处理服务契约
abstract class IImageService {
  /// 将原始图片数据转换为标准的 WebP 格式
  /// 
  /// [quality] 默认为 80。
  Future<Uint8List> compressImage({
    required Uint8List data,
    int quality = 80,
  });

  /// 生成缩略图数据 (WebP 格式)
  /// 
  /// 宽度限制为 200-300px 范围内以优化 Timeline 加载。
  Future<Uint8List> generateThumbnail({
    required Uint8List data,
    int width = 200,
  });

  /// 安全擦除指定路径的文件
  /// 
  /// 在录入流程结束后调用，确保存留的临时明文文件被彻底物理删除。
  Future<void> secureWipe(String filePath);

  /// 提取图像的基本尺寸信息（而不完整解码整个图像）
  Future<ImageDimensions> getDimensions(Uint8List data);

  /// 旋转图像
  Future<Uint8List> rotateImage({
    required Uint8List data,
    required int angle,
  });
}

/// 图像尺寸数据模型
class ImageDimensions {
  final int width;
  final int height;
  ImageDimensions(this.width, this.height);
}
