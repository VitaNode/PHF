/// # EntityMapper Mixin
///
/// ## Description
/// 集中化处理数据库 Row (Map) 到领域实体 (Domain Entities) 的映射逻辑。
/// 旨在消除不同 Repository 间的重复代码，并统一处理 DateTime、Enum 及 JSON 转换。
///
/// ## Principles
/// - **Robustness**: 针对 Enum 还原提供 Fallback 机制。
/// - **Type Safety**: 强制类型转换，避免 dynamic 溢出。
/// - **Consistency**: 统一数据库字段 (snake_case) 与实体字段 (camelCase) 的映射规则。
library;

import 'dart:convert';
import '../../models/image.dart';
import '../../models/record.dart';

mixin EntityMapper {
  /// 将数据库行映射为 MedicalRecord 实体
  MedicalRecord mapToRecord(
    Map<String, dynamic> row,
    List<MedicalImage> images,
  ) {
    final createdAtMs = row['created_at_ms'] as int;
    final visitDateMs = row['visit_date_ms'] as int?;
    final updatedAtMs = row['updated_at_ms'] as int;

    // notedAt 逻辑：优先取 visit_date_ms，若为空则回退到创建时间
    final notedAt = visitDateMs != null
        ? DateTime.fromMillisecondsSinceEpoch(visitDateMs)
        : DateTime.fromMillisecondsSinceEpoch(createdAtMs);

    final visitEndDate = row['visit_end_date_ms'] != null
        ? DateTime.fromMillisecondsSinceEpoch(row['visit_end_date_ms'] as int)
        : null;

    final statusStr = row['status'] as String? ?? 'archived';
    final status = RecordStatus.values.firstWhere(
      (e) => e.name == statusStr,
      orElse: () => RecordStatus.archived,
    );

    return MedicalRecord(
      id: row['id'] as String,
      personId: row['person_id'] as String,
      isVerified: (row['is_verified'] as int? ?? 0) == 1,
      groupId: row['group_id'] as String?,
      hospitalName: row['hospital_name'] as String?,
      notes: row['notes'] as String?,
      notedAt: notedAt,
      visitEndDate: visitEndDate,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      status: status,
      tagsCache: row['tags_cache'] as String?,
      images: images,
    );
  }

  /// 将数据库行映射为 MedicalImage 实体
  MedicalImage mapToImage(Map<String, dynamic> row) {
    List<String> tags = [];
    if (row['tags'] != null) {
      try {
        final decoded = jsonDecode(row['tags'] as String);
        if (decoded is List) {
          tags = List<String>.from(decoded.map((e) => e.toString()));
        }
      } catch (_) {
        // Log or handle JSON parsing error
      }
    }

    return MedicalImage(
      id: row['id'] as String,
      recordId: row['record_id'] as String,
      filePath: row['file_path'] as String,
      thumbnailPath: row['thumbnail_path'] as String,
      encryptionKey: row['encryption_key'] as String,
      thumbnailEncryptionKey:
          row['thumbnail_encryption_key'] as String? ??
          row['encryption_key'] as String,
      width: row['width'] as int?,
      height: row['height'] as int?,
      mimeType: row['mime_type'] as String? ?? 'image/webp',
      fileSize: row['file_size'] as int? ?? 0,
      displayOrder: row['page_index'] as int? ?? 0,
      tagIds: tags,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at_ms'] as int,
      ),
      ocrText: row['ocr_text'] as String?,
      ocrRawJson: row['ocr_raw_json'] as String?,
      ocrConfidence: (row['ocr_confidence'] ?? row['confidence']) as double?,
      hospitalName: row['hospital_name'] as String?,
      visitDate: row['visit_date_ms'] != null
          ? DateTime.fromMillisecondsSinceEpoch(row['visit_date_ms'] as int)
          : null,
    );
  }
}
