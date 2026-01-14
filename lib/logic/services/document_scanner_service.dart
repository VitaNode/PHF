import 'package:flutter/services.dart';

/// # DocumentScannerService
///
/// ## Description
/// 封装原生文档扫描器调用逻辑。
class DocumentScannerService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.phf/scanner',
  );

  /// 启动原生文档扫描器
  ///
  /// 返回扫描生成的图片文件路径列表。
  Future<List<String>> scanDocument() async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod('scanDocument');
      return result?.cast<String>() ?? [];
    } on PlatformException catch (e) {
      if (e.code == 'CANCELLED') {
        return [];
      }
      throw Exception('Document scan failed: ${e.message}');
    }
  }
}
