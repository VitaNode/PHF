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
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PersonToJson(_Person instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'avatarPath': instance.avatarPath,
      'isDefault': instance.isDefault,
      'createdAt': instance.createdAt.toIso8601String(),
    };
