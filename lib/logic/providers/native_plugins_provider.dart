import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/document_scanner_service.dart';
import '../services/image_processor_service.dart';

part 'native_plugins_provider.g.dart';

@riverpod
DocumentScannerService documentScannerService(Ref ref) {
  return DocumentScannerService();
}

@riverpod
ImageProcessorService imageProcessorService(Ref ref) {
  return ImageProcessorService();
}
