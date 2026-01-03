/// # OCR Queue Item Entity
///
/// ## Description
/// OCR 异步处理队列中的任务项。
/// 负责追踪单张图片的识别进度、重试次数及错误信息。
///
/// ## Fields
/// - `id`: 任务 ID.
/// - `imageId`: 需要处理的图片 ID.
/// - `status`: 任务状态 (`pending`, `processing`, `completed`, `failed`).
/// - `retryCount`: 已重试次数.
/// - `lastError`: 最后一次失败的错误信息.
/// - `createdAt`: 任务创建时间.
/// - `updatedAt`: 任务最后更新时间.
///
/// ## Implementation Rules
/// - 符合 `Spec#FR-202 Async Queue`。
/// - 采用 Freezed 实现不可变性。
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ocr_queue_item.freezed.dart';
part 'ocr_queue_item.g.dart';

enum OCRJobStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

@freezed
abstract class OCRQueueItem with _$OCRQueueItem {
  const factory OCRQueueItem({
    required String id,
    required String imageId,
    @Default(OCRJobStatus.pending) OCRJobStatus status,
    @Default(0) int retryCount,
    String? lastError,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _OCRQueueItem;

  factory OCRQueueItem.fromJson(Map<String, dynamic> json) => _$OCRQueueItemFromJson(json);
}
