# Baseline Specification: Core Architecture & MVP Loop (Phase 1)

**Status**: Draft (Speckit.Specify)  
**Created**: 2025-12-28  
**Scope**: Phase 1 - Architecture & MVP Loop  
**Primary Strategy**: Security First | Schema First | UI Kit First

---

## 1. Product Goals
PaperHealth (PHF) 旨在通过 **100% 本地运行** 的方式，为用户提供一个绝对隐私、高安全性的纸质医疗文档数字化管理工具。
- **隐私性**: 数据永不离机。
- **可用性**: 摆脱对医院或云端系统的依赖，用户拥有完整的数据控制权。
- **数字化**: 将杂乱的纸质病历转化为结构化、可搜索、可追溯的数字档案。

---

## 2. User Flows

### A. 录入流程 (Ingestion Loop) - Priority: P1
1.  **Entry**: 用户在首页点击“+ 拍照”或“导入”按钮。
2.  **Capture / Select**: 
    - **相机**: 调起原生相机，支持单张或连拍。
    - **相册**: 从系统相册选择多张图片进行导入。
3.  **Process**: 
    - 自动压缩图片以减少空间占用。
    - 生成随机 AES-256 密钥（或使用派生自 Master Key 的密钥）。
    - 将加密后的字节流写入应用私有目录。
4.  **Preview & Edit**: 
    - 用户进入预览页，可进行裁剪、旋转或删除操作。
    - 对预览图进行实时解密显示。
5.  **Metadata Entry**: 
    - 用户为本次录入的 **图片** 批量或逐一设置标签（提供4个标签供用户选择，暂不支持用户自定义）。
    - 手工录入就诊层级的元数据：**医院名称**、**就诊日期**。
6.  **Save**: 点击保存。
    - 标签关系写入 `image_tags` 表。
    - 系统自动提取该记录下所有图片的标签集合，去重后更新到 `records.tags_cache`。
7.  **Exit**: 应用返回首页，首页 Timeline 立即反映新增加的就诊记录（以卡片形式展示）。

### B. 查看与编辑流程 (View & Edit Loop) - Priority: P2
1.  **Browse**: 用户在首页滑动 Timeline 浏览记录。
2.  **Detail**: 点击卡片进入详情页。
    - 解密并展示该就诊单元下的所有图片（支持大图查看/滑动）。
    - 展示相关的文字元数据。
3.  **Edit**: 用户修改医院、日期或标签，点击「更新」。
4.  **Delete**: 用户可选择删除整条就诊记录，应用必须确保物理删除所有相关的加密图片文件及数据库记录。

---

## 3. Functional Requirements

### FR-001: 环境与安全初始化
- 系统启动时必须初始化 **SQLCipher**。
- 如果是首次启动，系统必须执行以下操作：
  - **创建默认用户**: 自动在 `persons` 表中创建一个初始档案（如 "Me" 或 "本人"），并标记为 `is_default = 1`。
  - **引导安全设置**: 引导用户设置应用锁（Pin/Biometric，注：Phase 1 可先提供基础状态，Phase 4 深度集成）。
- 必须确保所有关键目录（图片存放地）在沙盒内部。

### FR-002: 图片录入与捕捉
- **双来源支持**: 必须支持通过原生相机拍摄及通过系统相册（Image Picker）选择图片。
- **批量处理**: 支持多图连拍和多图批量导入。
- **压缩**: 原图及缩略图在存入前必须压缩（建议 WebP 格式，平衡清晰度与体积）。
- **缩略图规则**:
  - **生成**: 在图片录入阶段同步生成 200-300px 尺寸的 WebP 缩略图。
  - **加密**: 缩略图必须同样执行 AES-256 独立加密存储。
  - **解密性能**: 列表页预览应只分片解密缩略图，以确保 Timeline 滑动流畅度。
- **缓存清理**: 拍摄/处理过程中的临时、未加密图片（含缩略图）必须在任务结束（报错或完成）时立即彻底清除。

### FR-003: 加密存储要求
- **文件加密**: 每张图片文件在保存前必须经过 **AES-256-GCM/CBC** 加密。
- **数据库加密**: 使用 SQLCipher 256-bit AES。
- **流式处理**: 对于大文件或连拍，必须采用流式加密，避免 OOM 崩溃。

### FR-004: UI 规范 (UI Kit)
- 遵循宪章定义的 **Teal & White** 风格。
- **Typography**: 医疗数值必须使用等宽字体（Inconsolata/Fira Code）。
- **Components**: 必须先定义标准卡片 (EventCard)、导航栏 (TopBar) 和操作按钮 (Fab)。

---

## 4. Data Schema (Baseline V1)

初始化阶段将完整构建以下核心表结构，支持未来 Phase 2/3 的平滑扩展。

### 4.1 records 表（就诊事件）
存储每次就诊/检查的核心元数据。

```sql
CREATE TABLE records (
  id              TEXT PRIMARY KEY,
  person_id       TEXT NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
  
  status          TEXT NOT NULL DEFAULT 'archived', 
  -- 状态管理: 'archived' (已归档/完成), 'processing' (OCR中-Phase 2), 'review' (需人工确认-Phase 2)

  visit_date_ms   INTEGER,                -- 就诊日期时间戳 (排序/筛选用)
  visit_date_iso  TEXT,                   -- YYYY-MM-DD (分组显示用)
  
  hospital_name   TEXT,                   -- 医院名称
  hospital_id     TEXT REFERENCES hospitals(id), -- 关联标准库 (Phase 3+)
  
  notes           TEXT,                   -- 用户备注
  tags_cache      TEXT,                   -- [展示缓存] 存储该 Record 下所有图片标签的去重集合 (JSON)，用于 Timeline 快速渲染
  
  created_at_ms   INTEGER NOT NULL,
  updated_at_ms   INTEGER NOT NULL
);
```

### 4.2 images 表（图片资源）
存储文件路径、独立密钥及 OCR 预览数据。

```sql
CREATE TABLE images (
  id              TEXT PRIMARY KEY,
  record_id       TEXT NOT NULL REFERENCES records(id) ON DELETE CASCADE,
  
  -- 物理路径
  file_path       TEXT NOT NULL,          -- 加密原图相对路径
  thumbnail_path  TEXT NOT NULL,          -- 加密缩略图相对路径
  
  -- 安全
  encryption_key  TEXT NOT NULL,          -- 存储该图片专用的随机 AES 密钥 (Base64)
  -- 注意: IV (初始化向量) 不存储在数据库中，而是直接预置在加密文件的头部 (Prepend to File)，
  -- 从而避免原图与缩略图在共用 Key 时产生 IV 重用风险。
  
  -- 元数据
  width           INTEGER,
  height          INTEGER,
  mime_type       TEXT DEFAULT 'image/webp',
  file_size       INTEGER,
  page_index      INTEGER DEFAULT 0,      -- 多图排序
  
  -- OCR 结果缓存 (Phase 2)
  ocr_text        TEXT,                   -- 全文索引源数据
  ocr_raw_json    TEXT,                   -- 原始坐标数据
  ocr_confidence  REAL,                   -- OCR 识别置信度 (0.0 - 1.0)
  tags            TEXT,                   -- JSON Array (Integers) - IDs of assigned tags e.g. [1,5]
  created_at_ms   INTEGER NOT NULL
);
```

### 4.3 persons 表（多成员管理）
```sql
CREATE TABLE persons (
  id              TEXT PRIMARY KEY,
  nickname        TEXT NOT NULL,          -- "爷爷", "我", "宝宝"
  avatar_path     TEXT,                   -- 头像路径
  is_default      INTEGER DEFAULT 0,      -- 默认选中的档案
  created_at_ms   INTEGER NOT NULL
);
```

### 4.4 标签与关联表

```sql
CREATE TABLE tags (
  id              TEXT PRIMARY KEY,
  name            TEXT NOT NULL UNIQUE,
  color           TEXT,                   -- UI 颜色 Hex
  order_index     INTEGER,
  person_id       TEXT REFERENCES persons(id) ON DELETE CASCADE, -- NULL 为全局标签
  is_custom       INTEGER NOT NULL DEFAULT 0,
  created_at_ms   INTEGER NOT NULL
);

-- 初始化脚本 (首次启动)
-- 1. 创建默认用户: INSERT INTO persons (id, nickname, is_default, created_at_ms) VALUES ('def_me', '本人', 1, Date.now());
-- 2. 创建系统标签: INSERT INTO tags ... (见下文)

-- 标签初始化
const now = Date.now();

db.executeSql(`
  INSERT INTO tags (id, name, is_custom, created_at_ms)
  VALUES ('tag_check_' + now, '检验', 0, ${now}),
         ('tag_inspect_' + now + 1, '检查', 0, ${now + 1}),
         ('tag_medrecord_' + now + 2, '病历', 0, ${now + 2}),
         ('tag_prescription_' + now + 3, '处方', 0, ${now + 3});
`);
```


```sql
-- 核心关系: 图片 <-> 标签 (真相源)
CREATE TABLE image_tags (
  image_id        TEXT NOT NULL REFERENCES images(id) ON DELETE CASCADE,
  tag_id          TEXT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (image_id, tag_id)
);
```

### 4.5 辅助与搜索表
```sql
CREATE TABLE hospitals (
  id              TEXT PRIMARY KEY,
  name            TEXT NOT NULL,          -- 标准名称
  alias_json      TEXT,                   -- 别名列表 ["协和", "北京协和"]
  city            TEXT,
  created_at_ms   INTEGER NOT NULL
);

CREATE TABLE app_meta (
  key             TEXT PRIMARY KEY,
  value           TEXT
);

-- FTS5 虚拟表，用于 OCR 全文检索
CREATE VIRTUAL TABLE ocr_search_index USING fts5(
  record_id UNINDEXED, 
  content
);
```
---

## 5. Security Implementation

### Key Management
- **Database Key**: 基于设备安全存储（iOS Keychain / Android Keystore）生成的随机字符串。
- **File Key**: 每张图使用独立密钥，密钥存储在加密数据库中。

### Encryption Workflow
1.  **Derivation**: 从 Keystore 读取 User Salt，生成加密实例。
2.  **Writing**: 
    - `Raw Data` -> `Compression` -> `AES Encryption (streaming)`.
    - **IV Management**: 为每个文件（原图和缩略图）生成唯一的随机 IV。
    - **Storage**: 将 `IV (12 or 16 bytes)` + `Encrypted Data` 组合后写入文件。
3.  **Reading**:
    - **Header Extraction**: 从加密文件头部读取前 N 字节作为 IV。
    - **Decryption**: 使用 `File Key` + `Extracted IV` 进行解密。
    - **Note**: 严禁将解密后的图片再次落盘。

---

## 6. Success Criteria (Phase 1)
- **SC-001**: 应用在断网环境下可正常完成从拍照到首页 Timeline 展示的全流程。
- **SC-002**: 使用普通的 SQLite 查看器查看 `.db` 文件，结果为不可读加密乱码。
- **SC-003**: 使用相册应用无法在手机公有相册中搜到应用拍摄的医疗图片。
- **SC-004**: 处理 10 张图片连拍的端到端存入时间控制在 3s 以内（含加密与压缩）。

---

## Appendix: Roadmap Snapshot
- **Phase 2**: On-Device OCR & Queue System.
- **Phase 3**: FTS5 Search, Tags & Timeline Refinement.
- **Phase 4**: Biometrics, Backups, Multi-user support.
