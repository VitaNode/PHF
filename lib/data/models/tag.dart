/// # Tag Entity
///
/// ## Description
/// 用于标记医疗图像的分类标签（例：化验单、处方、心电图）。
///
/// ## Fields
/// - `id`: 唯一标识 (UUID).
/// - `personId`: 所属用户 ID (系统标签为 null).
/// - `name`: 标签名称.
/// - `color`: 标签颜色 (Hex String, e.g., "#008080").
/// - `orderIndex`: 排序索引.
/// - `isCustom`: 是否为用户自定义标签.
/// - `createdAt`: 创建时间.
///
/// ## Implementation Rules
/// - 符合 `Spec#4.1`：标签与图片关联，Record 查看时聚合显示。
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@freezed
abstract class Tag with _$Tag {
  const Tag._();

  const factory Tag({
    required String id,
    String? personId,
    required String name,
    required String color,
    @Default(0) int orderIndex,
    @Default(false) bool isCustom,
    required DateTime createdAt,
  }) = _Tag;

  bool get isSystem => !isCustom;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
