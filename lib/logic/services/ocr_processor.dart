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
import '../../data/models/ocr_queue_item.dart';
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

    final msg = 'Processing Task: ${item.id} for Image: ${item.imageId}';
    _talker?.info('[OCRProcessor] $msg');
    if (_talker == null) log(msg, name: 'OCRProcessor');

    // Make local vars nullable to allow clearing
    Uint8List? decryptedBytes;

    try {
      // 1. 获取图片元数据
      final image = await _imageRepository.getImageById(item.imageId);
      if (image == null) {
        throw Exception('Image not found: ${item.imageId}');
      }

      // 2. 解密图片 (Into Memory)
      // Resolve absolute path from stored relative path
      final fullPath = image.filePath.startsWith('/')
          ? image.filePath
          : '${_pathService.sandboxRoot}/${image.filePath}';

      // IOCRService 需要 Uint8List
      decryptedBytes = await _securityHelper.decryptDataFromFile(
        fullPath,
        image.encryptionKey,
      );

      // 3. 执行 OCR 识别
      var ocrResult = await _ocrService.recognizeText(
        decryptedBytes,
        mimeType: image.mimeType,
      );

      // 3.1 语义增强 (Heuristic Enhancement)
      ocrResult = OcrEnhancer.enhance(ocrResult);

      // 立即释放原始解密数据
      decryptedBytes = null;

      // 3.1 预处理 OCR 结果 (防止因接口返回 text 为空但 blocks 有数据的情况)
      String fullText = ocrResult.text.trim();
      if (fullText.isEmpty && ocrResult.blocks.isNotEmpty) {
        fullText = ocrResult.blocks.map((b) => b.text).join('\n').trim();
        _talker?.warning(
          '[OCRProcessor] OCR text was empty but blocks exist. Joined blocks.',
        );
      }

      if (fullText.isEmpty) {
        _talker?.warning(
          '[OCRProcessor] OCR result for Image ${image.id} is completely empty.',
        );
      }

      // 4. 智能提取 (FR-203)
      final extracted = SmartExtractor.extract(fullText, ocrResult.confidence);

      final info =
          'Extracted: date=${extracted.visitDate}, hospital=${extracted.hospitalName}, score=${extracted.confidenceScore}';
      _talker?.info('[OCRProcessor] $info');
      if (_talker == null) log(info, name: 'OCRProcessor');

      // 5. 持久化数据
      // 5.1 更新 Image OCR 数据
      await _imageRepository.updateOCRData(
        image.id,
        fullText,
        rawJson: jsonEncode(ocrResult.toJson()),
        confidence: extracted.confidenceScore,
      );

      // 5.2 更新 Image 业务元数据 (如果有新发现)
      // 仅当提取到有效值且当前 Image 对应字段为空时，或者我们选择覆盖？
      if (extracted.visitDate != null || extracted.hospitalName != null) {
        await _imageRepository.updateImageMetadata(
          image.id,
          hospitalName: extracted.hospitalName,
          visitDate: extracted.visitDate,
        );
      }

      // 5.3 更新 Record 状态与合并元数据
      final record = await _recordRepository.getRecordById(image.recordId);
      if (record != null) {
        // 更新 Record 元数据聚合 (sync logic inside repo usually handles this,
        // but updateImageMetadata triggers syncRecordMetadataCache in Repo implementation)
        // 所以我们只需要处理 Status。

        // 决策状态 (Spec FR-203 Phase 2 A.5)
        // - High Confidence (>0.9): Archived (Done)
        // - Low Confidence (<=0.9): Review
        // 注意：Record 可能包含多张图。如果任何一张图是 Low Confirm，Record 应该是 Review 吗？
        // 或者只要有一张是 High，就 OK？通常取最低分或加权。
        // 为了简单起见 (MVP Loop)，如果当前图片置信度低，我们将 Record 标记为 Review。
        // 如果当前是 High，且 Record 原本是 Processing，我们可以改为 Archived。

        RecordStatus newStatus = record.status;
        if (extracted.confidenceScore > _highConfidenceThreshold) {
          if (newStatus == RecordStatus.processing) {
            newStatus = RecordStatus.archived;
          }
        } else {
          // 低置信度强制进入 Review
          newStatus = RecordStatus.review;
        }

        if (newStatus != record.status) {
          await _recordRepository.updateStatus(record.id, newStatus);
        }
      }

      // 5.4 更新搜索索引 (Search Index)
      // 聚合整个 Record 的文本入库
      await _searchRepository.syncRecordIndex(image.recordId);

      // 6. 标记任务完成
      await _queueRepository.updateStatus(item.id, OCRJobStatus.completed);

      _talker?.info('[OCRProcessor] Processing Completed: ${item.id}');
      if (_talker == null) {
        log('Processing Completed: ${item.id}', name: 'OCRProcessor');
      }
      return true;
    } catch (e, stack) {
      _talker?.handle(e, stack, '[OCRProcessor] Processing Failed: ${item.id}');
      if (_talker == null) {
        log(
          'Processing Failed: ${item.id}. Error: $e',
          name: 'OCRProcessor',
          error: e,
          stackTrace: stack,
        );
      }
      decryptedBytes = null; // Ensure clear on error

      await _queueRepository.updateStatus(
        item.id,
        OCRJobStatus.failed,
        error: e.toString(),
      );

      // Retry logic could be expanded here (currently just status update)
      return false;
    }
  }
}
