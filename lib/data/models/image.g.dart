// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicalImage _$MedicalImageFromJson(Map<String, dynamic> json) =>
    _MedicalImage(
      id: json['id'] as String,
      recordId: json['recordId'] as String,
      encryptionKey: json['encryptionKey'] as String,
      thumbnailEncryptionKey: json['thumbnailEncryptionKey'] as String,
      filePath: json['filePath'] as String,
      thumbnailPath: json['thumbnailPath'] as String,
      mimeType: json['mimeType'] as String? ?? 'image/jpeg',
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 0,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      ocrText: json['ocrText'] as String?,
      ocrRawJson: json['ocrRawJson'] as String?,
      ocrConfidence: (json['ocrConfidence'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      hospitalName: json['hospitalName'] as String?,
      visitDate: json['visitDate'] == null
          ? null
          : DateTime.parse(json['visitDate'] as String),
      tagIds: (json['tagIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$MedicalImageToJson(_MedicalImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recordId': instance.recordId,
      'encryptionKey': instance.encryptionKey,
      'thumbnailEncryptionKey': instance.thumbnailEncryptionKey,
      'filePath': instance.filePath,
      'thumbnailPath': instance.thumbnailPath,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'displayOrder': instance.displayOrder,
      'width': instance.width,
      'height': instance.height,
      'ocrText': instance.ocrText,
      'ocrRawJson': instance.ocrRawJson,
      'ocrConfidence': instance.ocrConfidence,
      'createdAt': instance.createdAt.toIso8601String(),
      'hospitalName': instance.hospitalName,
      'visitDate': instance.visitDate?.toIso8601String(),
      'tagIds': instance.tagIds,
    };
