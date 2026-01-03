// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OCRQueueItem _$OCRQueueItemFromJson(Map<String, dynamic> json) =>
    _OCRQueueItem(
      id: json['id'] as String,
      imageId: json['imageId'] as String,
      status: $enumDecodeNullable(_$OCRJobStatusEnumMap, json['status']) ??
          OCRJobStatus.pending,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastError: json['lastError'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OCRQueueItemToJson(_OCRQueueItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageId': instance.imageId,
      'status': _$OCRJobStatusEnumMap[instance.status]!,
      'retryCount': instance.retryCount,
      'lastError': instance.lastError,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$OCRJobStatusEnumMap = {
  OCRJobStatus.pending: 'pending',
  OCRJobStatus.processing: 'processing',
  OCRJobStatus.completed: 'completed',
  OCRJobStatus.failed: 'failed',
};
