/// # IOCRQueueRepository Interface
///
/// ## Description
/// OCR 异步处理队列的业务契约。
///
/// ## Functions
/// - `enqueue`: 将任务加入队列.
/// - `dequeue`: 获取下一个待处理任务.
/// - `updateStatus`: 更新任务状态.
/// - `getPendingCount`: 获取待处理任务总数.
library;

import '../../models/ocr_queue_item.dart';

abstract interface class IOCRQueueRepository {
  /// 将图片识别任务入队
  Future<void> enqueue(String imageId);

  /// 获取下一个待处理的任务
  Future<OCRQueueItem?> dequeue();

  /// 更新任务状态及错误信息
  Future<void> updateStatus(String id, OCRJobStatus status, {String? error});

  /// 增加重试次数
  Future<void> incrementRetry(String id);

  /// 获取所有挂起的任务数量
  ///
  /// 如果提供 [personId]，则仅统计该用户的任务。
  Future<int> getPendingCount({String? personId});

  /// 删除任务
  Future<void> deleteJob(String id);

  /// 根据图片 ID 删除关联的任务
  Future<void> deleteByImageId(String imageId);
}
