/// # ITagRepository
///
/// ## Description
/// 标签数据仓库接口。
///
/// ## Methods
/// - `getAllTags`: 获取所有可用标签。
/// - `createTag`: 创建新标签（Phase 2）。
library;
import '../../../data/models/tag.dart';

abstract class ITagRepository {
  /// 获取所有可用标签，按 `order_index` 排序
  Future<List<Tag>> getAllTags();
  
  // Future<String> createTag(...) // Phase 2
}
