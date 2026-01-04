# Database Schema Documentation

**Version**: 7.0 (Phase 3.1)
**Database Engine**: SQLite 3.x with SQLCipher (AES-256-GCM/CBC)
**Page Size**: 4096 bytes
**Foreign Keys**: Enabled (`PRAGMA foreign_keys = ON`)

## 1. Entity Tables

### `persons` (用户档案)
存储所有归档主体（用户或家庭成员）。

| Field | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | TEXT | PRIMARY KEY | UUID v4 |
| `nickname` | TEXT | NOT NULL | 显示名称 (e.g., "我", "爷爷") |
| `avatar_path` | TEXT | | 加密头像路径 (Optional) |
| `is_default` | INTEGER | DEFAULT 0 | 1 = 默认选中用户 |
| `order_index` | INTEGER | DEFAULT 0 | 排序索引 |
| `profile_color` | TEXT | | 档案配色 |
| `created_at_ms` | INTEGER | NOT NULL | 创建时间戳 |

### `records` (就诊记录)
一次就诊或检查事件的容器。

| Field | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | TEXT | PRIMARY KEY | UUID v4 |
| `person_id` | TEXT | FK -> `persons.id` | 级联删除 (`ON DELETE CASCADE`) |
| `status` | TEXT | DEFAULT 'archived' | 状态: `archived`, `processing`, `deleted` |
| `visit_date_ms` | INTEGER | | 就诊日期 (排序用) |
| `visit_date_iso` | TEXT | | YYYY-MM-DD (分组用) |
| `hospital_name` | TEXT | | 医院名称 (用户输入或 OCR) |
| `hospital_id` | TEXT | FK -> `hospitals.id` | 关联标准库 (Optional) |
| `notes` | TEXT | | 备注信息 |
| `tags_cache` | TEXT | | JSON Array (e.g., `["检验", "血常规"]`) |
| `created_at_ms` | INTEGER | NOT NULL | |
| `updated_at_ms` | INTEGER | NOT NULL | |

**Indexes**:
- `idx_records_visit_date`: `(visit_date_ms)`
- `idx_records_person_status`: `(person_id, status)`

### `images` (图片资源)
存储图片的元数据及加密索引。
**注意**: 实际的加密密钥和 IV 管理方式见 `Security` 章节。

| Field | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | TEXT | PRIMARY KEY | UUID v4 |
| `record_id` | TEXT | FK -> `records.id` | 级联删除 |
| `file_path` | TEXT | NOT NULL | 加密原图相对路径 |
| `thumbnail_path` | TEXT | NOT NULL | 加密缩略图相对路径 |
| `encryption_key` | TEXT | NOT NULL | Base64 Encoded 256-bit Key |
| `width` | INTEGER | | |
| `height` | INTEGER | | |
| `mime_type` | TEXT | DEFAULT 'image/webp' | |
| `file_size` | INTEGER | | Bytes |
| `page_index` | INTEGER | DEFAULT 0 | 排序索引 |
| `created_at_ms` | INTEGER | NOT NULL | |

**Indexes**:
- `idx_images_record_order`: `(record_id, page_index)`

## 2. Meta & Categorization Tables

### `tags` (标签定义)
| Field | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | TEXT | PRIMARY KEY | |
| `name` | TEXT | NOT NULL UNIQUE | |
| `color` | TEXT | | Hex String (#RRGGBB) |
| `order_index` | INTEGER | | |
| `person_id` | TEXT | FK -> `persons.id` | NULL = 全局系统标签 |
| `is_custom` | INTEGER | DEFAULT 0 | 1 = 用户自定义 |

### `image_tags` (关联表)
多对多关联：图片 <-> 标签。

| Field | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `image_id` | TEXT | FK -> `images.id` | |
| `tag_id` | TEXT | FK -> `tags.id` | |
| **Primary Key** | | | `(image_id, tag_id)` |

### `hospitals` (医院库)
| Field | Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `id` | TEXT | PRIMARY KEY | |
| `name` | TEXT | NOT NULL | |
| `city` | TEXT | | |

## 3. Virtual Tables

### `ocr_search_index` (FTS5)
用于全文检索。

| Field | Type | Description |
| :--- | :--- | :--- |
| `record_id` | UNINDEXED | 关联的 Record ID |
| `hospital_name`| TEXT | 医院名称 |
| `tags` | TEXT | 标签内容 |
| `ocr_text` | TEXT | OCR 识别文本 |
| `notes` | TEXT | 备注 |
| `content` | TEXT | 兼容性全文内容 |
