# T13.3 Tags Implementation (Supplement)

**Date**: 2025-12-30
**Task**: 补全 T13.3 中关于图片标签 (Image Tags) 的需求遗漏。

## 1. 核心实现逻辑 (Core Implementation)

### 1.1 数据库层
- **Images Table**: 确认 `images` 表包含 `tags` 字段 (TEXT/JSON)，用于存储该图片关联的 Tag IDs 列表。
- **Mapping**: `ImageRepository` 在保存时将 `List<String> tagIds` 序列化为 JSON 字符串存储；读取时反序列化。

### 1.2 UI 层 (Timeline & EventCard)
- **需求**: 在 Timeline 卡片中，读取首张图片的第一个标签，替代（或优先于）Record Notes 显示。
- **挑战**: `EventCard` 仅持有 `tagId` (String)，需要显示 `tagName`。
- **解决方案**:
  - 将 `EventCard` 重构为 `ConsumerWidget`。
  - 使用 `FutureBuilder` 异步调用 `TagRepository.getAllTags()` 并根据 ID 查找 Name。
  - **Fallback**: 若无图片标签，回退显示 `record.notes`。

### 1.3 详情页 (RecordDetailPage)
- 已实现聚合展示 Record 下所有图片关联的去重标签。
- 修复了 `RecordDetailPage` 中的语法错误（方法定义位置）。

### 1.4 录入页 (IngestionPage)
- 已集成 `TagSelector`，支持标签选择与排序。

## 2. 遇到的技术挑战

### 2.1 性能问题 (N+1 Query)
- **现状**: `TimelinePage` 中的每个 `EventCard` 如果有图片标签，都会触发一次 `TagRepository.getAllTags()` 查询。
- **影响**: 列表滚动时可能产生大量数据库读取操作，虽然 SQLite 很快，但在低端机上可能掉帧。
- **临时方案**: Phase 1 暂且接受，利用 `FutureBuilder` 的缓存特性（但在 `ListView` 回收后会重刷）。

### 2.2 状态同步
- 图片标签更新后，需要同步更新 `records.tags_cache` 和 `EventCard` 显示。目前 Repository 层已处理 `tags_cache` 同步。

## 3. 对后续任务的建议 (Phase 2 Optimization)

1.  **全局标签缓存 (TagCacheProvider)**:
    - 建议创建一个 `GlobalTagProvider` (StateNotifier)，在应用启动或 Tag 变更时加载所有标签到内存 (`Map<String, Tag>`)。
    - `EventCard` 直接从内存 Provider 读取 Tag Name，变为同步渲染，消除 N+1 异步闪烁和性能损耗。

2.  **数据库反范式化**:
    - 考虑在 `images` 表中冗余存储 `first_tag_name`，或者在 `records` 表中存储 `primary_display_text`，减少联表或二次查询需求。

3.  **UI 优化**:
    - 在 `RecordDetailPage` 增加“编辑标签”入口。

## 4. 测试验证
- 新增 `test/presentation/widgets/event_card_tags_test.dart`。
- 覆盖场景：
  - 图片有标签 -> 显示标签名，不显示 Notes。
  - 图片无标签 -> 显示 Notes。
- 测试通过。