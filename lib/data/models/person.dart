/// # Person Entity
///
/// ## Description
/// 表示医疗档案的归属主体（如：“我”、家人）。
///
/// ## Fields
/// - `id`: 唯一标识 (UUID).
/// - `nickname`: 昵称.
/// - `avatarPath`: 头像文件的相对路径（加密存储）.
/// - `isDefault`: 是否为默认用户 (Me).
/// - `createdAt`: 创建时间.
///
/// ## Security & Privacy
/// - 符合 `Constitution#I. Privacy`：所有个人识别信息仅存储于本地加密数据库。
/// - 不包含任何生物识别敏感字段，仅用于档案分类。
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required String id,
    required String nickname,
    String? avatarPath,
    @Default(false) bool isDefault,
    required DateTime createdAt,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}
