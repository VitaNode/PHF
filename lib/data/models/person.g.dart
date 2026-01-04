// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Person _$PersonFromJson(Map<String, dynamic> json) => _Person(
  id: json['id'] as String,
  nickname: json['nickname'] as String,
  avatarPath: json['avatarPath'] as String?,
  isDefault: json['isDefault'] as bool? ?? false,
  orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
  profileColor: json['profileColor'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PersonToJson(_Person instance) => <String, dynamic>{
  'id': instance.id,
  'nickname': instance.nickname,
  'avatarPath': instance.avatarPath,
  'isDefault': instance.isDefault,
  'orderIndex': instance.orderIndex,
  'profileColor': instance.profileColor,
  'createdAt': instance.createdAt.toIso8601String(),
};
