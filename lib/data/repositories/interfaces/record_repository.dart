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
///
/// ## 修复记录
/// - [issue#22] 为 `searchRecords` 增加 `startDate` 和 `endDate` 过滤参数。
library;

import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../models/record.dart';

abstract interface class IRecordRepository {
  /// 保存或更新就诊记录
  Future<void> saveRecord(MedicalRecord record, {DatabaseExecutor? executor});

  /// 根据 ID 获取记录
  Future<MedicalRecord?> getRecordById(String id, {DatabaseExecutor? executor});

  /// 获取指定人员的所有活跃记录
  Future<List<MedicalRecord>> getRecordsByPerson(
    String personId, {
    DatabaseExecutor? executor,
  });

  /// 更新记录状态 (归档、删除、待校对)
  Future<void> updateStatus(
    String id,
    RecordStatus status, {
    DatabaseExecutor? executor,
  });

  /// 更新记录元数据
  Future<void> updateRecordMetadata(
    String id, {
    String? hospitalName,
    DateTime? visitDate,
    String? notes,
    String? groupId,
    DatabaseExecutor? executor,
  });

  /// 彻底物理删除记录（慎用）
  Future<void> hardDeleteRecord(String id, {DatabaseExecutor? executor});

  /// 搜索记录 (支持文本、日期、标签过滤)
  Future<List<MedicalRecord>> searchRecords({
    required String personId,
    String? query,
    List<String>? tags,
    DateTime? startDate,
    DateTime? endDate,
    DatabaseExecutor? executor,
  });

  /// 聚合 Record 下所有图片的元数据并同步到 Record 表缓存
  Future<void> syncRecordMetadata(
    String recordId, {
    DatabaseExecutor? executor,
  });

  /// 获取指定人员处于 review 状态的记录数量
  Future<int> getPendingCount(String personId, {DatabaseExecutor? executor});

  /// 获取所有待审核的记录
  Future<List<MedicalRecord>> getReviewRecords(
    String personId, {
    DatabaseExecutor? executor,
  });
}
