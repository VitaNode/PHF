// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagImpl _$$TagImplFromJson(Map<String, dynamic> json) => _$TagImpl(
      id: json['id'] as String,
      personId: json['personId'] as String?,
      name: json['name'] as String,
      color: json['color'] as String,
      isSystem: json['isSystem'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TagImplToJson(_$TagImpl instance) => <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'name': instance.name,
      'color': instance.color,
      'isSystem': instance.isSystem,
      'createdAt': instance.createdAt.toIso8601String(),
    };
