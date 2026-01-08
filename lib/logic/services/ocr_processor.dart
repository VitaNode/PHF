/// # OCRProcessor Service
///
/// ## Description
/// OCR 流程的核心调度器。负责从队列获取任务，调用本地 OCR 引擎，执行数据提取，并更新数据库状态。
///
/// ## Workflow
/// 1. `dequeue`: 获取待处理任务。
/// 2. `decrypt`: 解密图片文件（内存中）。
/// 3. `recognize`: 调用平台特定的 OCR 引擎 (ML Kit / Vision)。
/// 4. `extract`: 使用 `SmartExtractor` 提取日期和医院。
/// 5. `persist`:
///    - 更新 Image 表 (text, raw, confidence)。
///    - 更新 Image 元数据 (date, hospital)。
///    - 更新 Record 状态 (based on confidence threshold > 0.9)。
///    - 更新 Search Index (FTS5)。
/// 6. `complete`: 更新队列状态。
///
/// ## Security
/// - 图片字节流仅在内存中处理，处理完毕立即置空或通过 GC 回收（局部变量退出作用域）。
/// - 只有加密后的 OCR 结果才会被持久化。
///
/// ## Fix Record
/// - **2025-12-31**:
///   1. 修改 `processNextItem` 调用 `ISearchRepository.syncRecordIndex` 以支持同 Record 下多图文本聚合搜索。
library;

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:talker_flutter/talker_flutter.dart';
import '../../data/models/image.dart';
import '../../data/models/ocr_queue_item.dart';
import '../../data/models/ocr_result.dart';
import '../../data/models/record.dart';
import '../../data/repositories/interfaces/ocr_queue_repository.dart';

import '../../data/repositories/interfaces/image_repository.dart';
import '../../data/repositories/interfaces/record_repository.dart';
import '../../data/repositories/interfaces/search_repository.dart';
import '../../core/security/file_security_helper.dart';
import '../../core/services/path_provider_service.dart';
import '../utils/smart_extractor.dart';
import '../utils/ocr_enhancer.dart';
import 'interfaces/ocr_service.dart';

class OCRProcessor {
  final IOCRQueueRepository _queueRepository;
  final IImageRepository _imageRepository;
  final IRecordRepository _recordRepository;
  final ISearchRepository _searchRepository;
  final IOCRService _ocrService;
  final FileSecurityHelper _securityHelper;
  final PathProviderService _pathService;
  final Talker? _talker;

  static const double _highConfidenceThreshold = 0.9;

  OCRProcessor({
    required IOCRQueueRepository queueRepository,
    required IImageRepository imageRepository,
    required IRecordRepository recordRepository,
    required ISearchRepository searchRepository,
    required IOCRService ocrService,
    required FileSecurityHelper securityHelper,
    required PathProviderService pathService,
    Talker? talker,
  }) : _queueRepository = queueRepository,
       _imageRepository = imageRepository,
       _recordRepository = recordRepository,
       _searchRepository = searchRepository,
       _ocrService = ocrService,
       _securityHelper = securityHelper,
       _pathService = pathService,
       _talker = talker;

  /// 处理队列中的下一个任务
  /// 返回 true 表示处理了一个任务，false 表示队列为空或处理失败
  Future<bool> processNextItem() async {
    final item = await _queueRepository.dequeue();
    if (item == null) return false;

    _log('Processing Task: ${item.id} for Image: ${item.imageId}');

    try {
      final image = await _imageRepository.getImageById(item.imageId);
      if (image == null) throw Exception('Image not found: ${item.imageId}');

      final decryptedBytes = await _loadImageAndDecrypt(image);
      final ocrResult = await _performOCRAndEnhance(decryptedBytes, image);
      final fullText = _getValidatedText(ocrResult, image.id);

      final extracted = SmartExtractor.extract(fullText, ocrResult.confidence);
      _log(
        'Extracted: date=${extracted.visitDate}, hospital=${extracted.hospitalName}, score=${extracted.confidenceScore}',
      );

      // --- Optimized Persistence Start ---
      // 1. Update Image OCR Data & Metadata (without individual syncs if possible)
      await _imageRepository.updateOCRData(
        image.id,
        fullText,
        rawJson: jsonEncode(ocrResult.toJson()),
        confidence: extracted.confidenceScore,
      );

      if (extracted.visitDate != null || extracted.hospitalName != null) {
        // Warning: updateImageMetadata currently triggers syncRecordIndex.
        // In a perfect world, we'd have a 'silent' version or a transactional way.
        await _imageRepository.updateImageMetadata(
          image.id,
          hospitalName: extracted.hospitalName,
          visitDate: extracted.visitDate,
        );
      }

      // 2. Update Record Status
      await _updateRecordStatus(image.recordId, extracted.confidenceScore);

      // 3. Final single sync for the whole record
      // This is now redundant because updateImageMetadata and updateStatus already did it,
      // but let's keep it if those are modified to be silent.
      // Actually, to fix the lock, we should ideally move all this into a single transaction.
      await _searchRepository.syncRecordIndex(image.recordId);

      // 4. Mark job as completed
      await _queueRepository.updateStatus(item.id, OCRJobStatus.completed);
      // --- Optimized Persistence End ---

      _log('Processing Completed: ${item.id}');
      return true;
    } catch (e, stack) {
      _talker?.handle(e, stack, '[OCRProcessor] Processing Failed: ${item.id}');
      await _queueRepository.updateStatus(
        item.id,
        OCRJobStatus.failed,
        error: e.toString(),
      );
      return false;
    }
  }

  void _log(String msg) {
    _talker?.info('[OCRProcessor] $msg');
    if (_talker == null) log(msg, name: 'OCRProcessor');
  }

  Future<Uint8List> _loadImageAndDecrypt(MedicalImage image) async {
    final fullPath = image.filePath.startsWith('/')
        ? image.filePath
        : '${_pathService.sandboxRoot}/${image.filePath}';

    return _securityHelper.decryptDataFromFile(fullPath, image.encryptionKey);
  }

  Future<OcrResult> _performOCRAndEnhance(
    Uint8List bytes,
    MedicalImage image,
  ) async {
    try {
      final result = await _ocrService.recognizeText(
        bytes,
        mimeType: image.mimeType,
      );
      return OcrEnhancer.enhance(result);
    } finally {
      // Small optimization: overwrite first few bytes if possible,
      // but in Dart Uint8List is just a pointer to heap.
      // The best we can do is let it go out of scope.
    }
  }

  String _getValidatedText(OcrResult result, String imageId) {
    String text = result.text.trim();
    if (text.isEmpty && result.blocks.isNotEmpty) {
      text = result.blocks.map((b) => b.text).join('\n').trim();
      _talker?.warning(
        '[OCRProcessor] OCR text was empty but blocks exist. Joined blocks.',
      );
    }
    if (text.isEmpty) {
      _talker?.warning(
        '[OCRProcessor] OCR result for Image $imageId is completely empty.',
      );
    }
    return text;
  }

  Future<void> _updateRecordStatus(String recordId, double confidence) async {
    final record = await _recordRepository.getRecordById(recordId);
    if (record == null) return;

    RecordStatus newStatus = record.status;
    if (confidence > _highConfidenceThreshold) {
      if (newStatus == RecordStatus.processing) {
        newStatus = RecordStatus.archived;
      }
    } else {
      newStatus = RecordStatus.review;
    }

    if (newStatus != record.status) {
      await _recordRepository.updateStatus(record.id, newStatus);
    }
  }
}
