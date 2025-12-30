// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicalRecordImpl _$$MedicalRecordImplFromJson(Map<String, dynamic> json) =>
    _$MedicalRecordImpl(
      id: json['id'] as String,
      personId: json['personId'] as String,
      hospitalName: json['hospitalName'] as String?,
      notes: json['notes'] as String?,
      notedAt: DateTime.parse(json['notedAt'] as String),
      visitEndDate: json['visitEndDate'] == null
          ? null
          : DateTime.parse(json['visitEndDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: $enumDecodeNullable(_$RecordStatusEnumMap, json['status']) ??
          RecordStatus.archived,
      tagsCache: json['tagsCache'] as String?,
    );

Map<String, dynamic> _$$MedicalRecordImplToJson(_$MedicalRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'hospitalName': instance.hospitalName,
      'notes': instance.notes,
      'notedAt': instance.notedAt.toIso8601String(),
      'visitEndDate': instance.visitEndDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': _$RecordStatusEnumMap[instance.status]!,
      'tagsCache': instance.tagsCache,
    };

const _$RecordStatusEnumMap = {
  RecordStatus.archived: 'archived',
  RecordStatus.deleted: 'deleted',
};
