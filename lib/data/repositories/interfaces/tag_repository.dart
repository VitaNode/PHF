/// # ITagRepository
///
/// ## Description
/// 标签数据仓库接口。
///
/// ## Methods
/// - `getAllTags`: 获取标签。支持按 `personId` 过滤（返回全局标签 + 个人标签）。
/// - `createTag`: 创建新标签。
/// - `updateTag`: 更新标签（如重命名、排序）。
/// - `deleteTag`: 删除标签，并级联更新关联数据。
library;

import '../../../data/models/tag.dart';

abstract class ITagRepository {
  /// 获取标签
  ///
  /// 如果 [personId] 为 null，返回所有标签（或视策略而定）。
  /// 如果 [personId] 不为 null，返回该用户的标签以及全局标签 (`person_id IS NULL`)。
  Future<List<Tag>> getAllTags({String? personId});

  /// 创建新标签
  Future<void> createTag(Tag tag);

  /// 更新标签
  Future<void> updateTag(Tag tag);

  /// 删除标签
  ///
  /// 触发级联操作：
  /// 1. 物理删除 `tags` 表记录。
  /// 2. 级联删除 `image_tags` (DB Foreign Key).
  /// 3. 更新 `images.tags` 缓存字段。
  Future<void> deleteTag(String id);

  /// 批量更新标签排序
  Future<void> updateOrder(List<Tag> tags);

  /// 根据文本内容建议标签
  ///
  /// 简单的关键词匹配：如果标签名称出现在 [text] 中，则建议该标签。
  Future<List<Tag>> suggestTags(String text, {String? personId});
}
