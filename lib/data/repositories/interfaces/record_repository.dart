/// # IRecordRepository Documentation
///
/// ## Description
/// 医疗记录仓库接口。负责 `MedicalRecord` 的持久化逻辑抽象。
///
/// ## Methods
/// - `getRecordsByPerson(personId)`: 检索指定用户的记录列表。
/// - `saveRecord(record)`: 创建或更新记录。
/// - `deleteRecord(id)`: 逻辑或物理删除记录。
///
/// ## Architectural Principles
/// - 符合 `Constitution#II. Architecture`：通过接口解耦逻辑层与具体的 SQL 实现。
library;

import '../../../data/models/record.dart';

/// 医疗记录仓储契约
abstract class IRecordRepository {
  /// 获取特定用户的所有有效记录
  /// 
  /// 结果应按 `notedAt` 倒序排列。
  Future<List<MedicalRecord>> getRecordsByPerson(String personId);

  /// 根据 ID 获取单个详细记录（含图片元数据载入）
  Future<MedicalRecord?> getRecordById(String id);

  /// 保存记录（新建或覆盖）
  Future<void> saveRecord(MedicalRecord record);

  /// 修改记录状态 (例如: 标记为已删除)
  Future<void> updateStatus(String id, RecordStatus status);

  /// 更新记录元数据
  Future<void> updateRecordMetadata(String id, {String? hospitalName, DateTime? visitDate, String? notes});

  /// 彻底删除记录实体（通常用于清理空记录）
  Future<void> hardDeleteRecord(String id);

  /// 全文检索或标签过滤后的记录查询
  Future<List<MedicalRecord>> searchRecords({
    required String personId,
    String? query,
    List<String>? tags,
  });

  /// 汇总 Image 数据并同步到 Record 缓存字段
  Future<void> syncRecordMetadata(String recordId);

  /// 获取待确认（review 状态）的记录数量
  Future<int> getPendingCount(String personId);

  /// 获取待确认列表
  Future<List<MedicalRecord>> getReviewRecords(String personId);
}
