// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tag _$TagFromJson(Map<String, dynamic> json) => _Tag(
  id: json['id'] as String,
  personId: json['personId'] as String?,
  name: json['name'] as String,
  color: json['color'] as String,
  orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
  isCustom: json['isCustom'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TagToJson(_Tag instance) => <String, dynamic>{
  'id': instance.id,
  'personId': instance.personId,
  'name': instance.name,
  'color': instance.color,
  'orderIndex': instance.orderIndex,
  'isCustom': instance.isCustom,
  'createdAt': instance.createdAt.toIso8601String(),
};
