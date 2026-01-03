/// # Record Entity
///
/// ## Description
/// 医疗事件记录（如：一次就诊、一份体检报告）。
///
/// ## Fields
/// - `id`: 唯一标识 (UUID).
/// - `personId`: 所属用户的 ID.
/// - `hospitalName`: 就诊医院名称.
/// - `notes`: 备注/笔记.
/// - `notedAt`: 事件发生时间.
/// - `createdAt`: 系统录入时间.
/// - `updatedAt`: 最后修改时间.
/// - `status`: 状态 (`processing`, `archived`, `deleted`).
/// - `tagsCache`: 聚合标签的 JSON 缓存字串，用于 Timeline 快速渲染.
/// - `images`: 该记录包含的所有图片 (非数据库字段, 内存聚合).
///
/// ## Implementation Rules
/// - 符合 `Spec#Data Schema`：`status` 默认为 `processing` (Phase 2+).
/// - 符合 `Constitution#II. Architecture`：作为 Domain Layer 的核心对象。
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'image.dart';

part 'record.freezed.dart';
part 'record.g.dart';

enum RecordStatus {
  @JsonValue('processing')
  processing,
  @JsonValue('review')
  review, // Confident check required (pending user review)
  @JsonValue('archived')
  archived,
  @JsonValue('deleted')
  deleted,
}

@freezed
abstract class MedicalRecord with _$MedicalRecord {
  const factory MedicalRecord({
    required String id,
    required String personId,
    String? hospitalName,
    String? notes,
    required DateTime notedAt,
    DateTime? visitEndDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(RecordStatus.processing) RecordStatus status,
    String? tagsCache,

    /// 内存关联字段
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default([]) List<MedicalImage> images,
  }) = _MedicalRecord;

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => _$MedicalRecordFromJson(json);
}

extension MedicalRecordX on MedicalRecord {
  String get title => hospitalName ?? '医疗记录';
}
