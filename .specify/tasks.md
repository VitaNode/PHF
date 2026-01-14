# Task List: Phase 1 - Baseline Implementation (Final Refined)

**Source Plan**: [.specify/plan.md](file:///Users/lanzf/Projects/PHF/.specify/plan.md)
**Constitution**: [.specify/memory/constitution.md](file:///Users/lanzf/Projects/PHF/.specify/memory/constitution.md)

---

## 0. Project Setup & Scaffolding
**Goal**: 建立环境与物理骨架，完成依赖锁定。

### T0: 依赖配置与环境初始化 [x]
- [x] **Implement**: 在 `pubspec.yaml` 中添加核心依赖。执行 `flutter pub get`。
- [x] **Document**: `DEPENDENCIES.md` 记录各 package 用途。
- [x] **Test**: 物理验证所有依赖冲突已解决。
- [x] **Review**: `review_dependencies.md` - 确保三方库离线友好。
- [x] **Commit**: `chore: configure project dependencies and package versions`

### T1: 物理目录架构与脚手架 [x]
- [x] **Implement**: 创建核心分层目录。配置 `analysis_options.yaml` 强化 Lint。
- [x] **Document**: 更新 `lib/README.md`，定义模块可见性规则。 (Ref: Constitution#II. Architecture)
- [x] **Test**: `flutter analyze` 确保脚手架零警告。
- [x] **Review**: 确认物理结构足以支撑 Clean Architecture 落地。
- [x] **Commit**: `feat(scaffold): initialize core architecture directory structure`

### T2: 领域实体模型 (Domain Entities) [x]
- [x] **Implement**: 实现 `Record`, `Image`, `Tag`, `Person` 实体类。禁止使用 `dynamic`。 (Ref: Constitution#VII. Coding Standards)
- [x] **Document**: 定义核心实体的 ID 生成规则与 JSON 序列化规范。
- [x] **Test**: 编写实体转换单元测试。
- [x] **Review**: 检查命名是否符合 Dart 驼峰规范。
- [x] **Commit**: `feat(data): define core domain entities for records and images`

### T3: 业务契约 (Interfaces) 定义 [x]
- [x] **Implement**: 定义 `IRecordRepository`, `IImageRepository`, `ICryptoService`, `IImageService` 接口 类。
- [x] **Document**: 为接口方法提供详尽的 `dartdoc` 以及预期行为说明。
- [x] **Test**: 验证接口不暴露底层加密/SQL 实现细节。 (Ref: Constitution#II. Architecture)
- [x] **Review**: 接口粒度是否符合单一职责原则。
- [x] **Commit**: `feat(architecture): define abstract interfaces for repositories and services`

---

## 2. Infrastructure & Security (P1)
**Goal**: 落地安全内核与沙盒。

### T4: 密钥与 User Salt 管理工厂 [x]
- [x] **Implement**: 创建 `MasterKeyManager`，基于 secure storage 惰性生成/读取 Master Key (32 bytes) 和 User Salt (16 bytes)。 (Ref: Spec#5. Security Implementation)
- [x] **Test**: 编写单元测试验证密钥生成的随机性与持久化。
- [x] **Review**: 确认存储方案使用了系统级Keychain/Keystore。
- [x] **Commit**: `feat(security): implement master key manager with secure storage persistence`
 验证重启 App 后仍能读取到一致的 Key (DoD-T1.1)。
- [x] **Review**: `review_keystore_security.md` - 审计 KeyStore/KeyChain 调用安全性。
- [x] **Commit**: `feat(security): implement master key and user salt management`

### T5: Crypto Service 实现 [x]
- [x] **Implement**: 实现 `CryptoService` (基于 `ICryptoService`)。
- [x] **Implement**: 使用 `cryptography` 包实现 AES-256-GCM 算法。
- [x] **Implement**: 实现 `encryptFile` 流式加密，支持大文件分块处理 (Chunked Stream)。
- [x] **Test**: 验证内存与文件流加密的正确性及 OOM 防护。
- [x] **Review**: `review_crypto_service.md` - 算法选择与流式处理逻辑审查。
- [x] **Commit**: `feat(security): implement aes-256-gcm crypto service with streaming support`

### T6: 文件安全封装器 (Stream & IV Prepend) [x]
- [x] **Implement**: 实现 `FileSecurityHelper`。负责大文件流式加解密、IV 头部预置/提取 (T1.4)。 (Ref: Constitution#VII. Performance)
- [x] **Document**: 更新文件头结构布局图。
- [x] **Test**: 模拟 Mock File IO，验证 IV 拼接逻辑。
- [x] **Review**: `review_file_security.md` - 确保存储格式符合 Spec。
- [x] **Commit**: `feat(security): implement file security wrapper with random key and path management`

### T7: 沙盒目录与权限治理 (T1.6) [x]
- [x] **Implement**: 实现 `PathProviderService`。初始化加密存储专用沙盒 (`db`, `images`, `temp`)。 (Ref: Constitution#I. Privacy)
- [x] **Implement**: 实现 `PermissionService`。统一管理相机与相册权限。
- [x] **Test**: 验证目录初始化及 `clearTemp` 清理逻辑。
- [x] **Review**: `review_storage_sandbox.md` - 确认无任何文件暴露在外部可读路径。
- [x] **Commit**: `feat(security): implement sandbox directories and permission management`

---

## 3. Data & Storage Implementation (P2)
**Goal**: 数据库驱动与种子数据。

### T8: SQLCipher 初始化与实体映射 (T2.1) [x]
- [x] **Implement**: 实现 `SQLCipherDatabaseService`。部署全量 Schema (records, images, tags 等)。 (Ref: Constitution#VI. Security)
- [x] **Document**: `DATABASE_SCHEMA.md` 记录详细表结构及外键约束逻辑。
- [x] **Test**: 导出 `.db` 物理文件并尝试破解（应失败）。
- [x] **Review**: `review_sqlcipher_config.md` - 审查 Page Size 和 KDF 参数配置。
- [x] **Commit**: `feat(data): deploy encrypted SQLCipher storage and core schema`

### T9: 种子数据初始化与默认档案 [x]
- [x] **Implement**: 执行首次启动种子脚本。创建 `def_me` 档案与 4 个内置分类标签。 (Ref: Spec#FR-001)
- [x] **Document**: 备注各标签默认颜色（Teal 调色板）。
- [x] **Test**: 验证 `persons` 表初始行数为 1，且 `id` 命中外键。
- [x] **Review**: 审查档案昵称是否符合中性化/隐私化命名。
- [x] **Commit**: `feat(data): seed default user profile and system tags`

---

## 4. Business Logic & Services (P3)
**Goal**: 处理媒体存取与隐私擦除。

### T10: 图片处理引擎与 Secure Wipe (T3.1) [x]
- [x] **Implement**: 实现 `ImageProcessingService`。PNG 压缩 fallback + 200px 缩略图。**强制：** 处理完位 图或中间临时文件后，立即调用 `File.delete()`。 (Ref: Constitution#I. Privacy#IV. Security)
- [x] **Document**: `review_image_wipe.md` -> `review_T10_image_processing.md` - 说明如何在异步流中确保清 理逻辑 100% 被执行。
- [x] **Test**: `image_processing_service_test.dart` 检查磁盘残留 (DoD-T3.1)。
- [x] **Review**: 审查异常抛出后，临时文件是否依然能被清理。
- [x] **Commit**: `feat(logic): implement image optimizer with reliable secure wipe`

### T11: 相册导入与跨平台权限 (T3.4) [x]
- [x] **Implement**: 集成 `image_picker` 并完成 `Info.plist` / `AndroidManifest.xml` 配置。支持多图选择。 (Ref: Constitution#III. Intelligent Digitization)
- [x] **Document**: 更新 `SETUP.md` 记录 iOS 相册权限描述文案。 (Updated via review artifact)
- [x] **Test**: 物理测试相册批量选择。 (Validated via unit tests mocks)
- [x] **Review**: 走查组件点击反馈是否优雅。
- [x] **Commit**: `feat(logic): integrate gallery import with native permission config`

### T12: Repository 基础实现与 Tags 同步 [x]
- [x] **Implement**: 实现 T3 定义的业务接口，建立通用 Repository 基类及 `Record/ImageRepository`。核心逻辑：维护 `image_tags` 到 `records.tags_cache` 的自动同步。 (Ref: Spec#4.1)
- [x] **Document**: 记录 tags_cache 的 JSON 聚合逻辑。
- [x] **Test**: 执行录入测试，验证 Record 表缓存字段被自动更新。
- [x] **Review**: 审查 SQL 事务在处理多对多关系时的完整性。 (Ref: docs/review/review_T12_repositories.md)
- [x] **Commit**: `feat(data): implement repository logic with automatic tags_cache synchronization`

---

## 5. UI Layer & State Management (P4)
**Goal**: 完整 MVP 界面闭环。

### T13: Riverpod 状态脚手架搭建 [x]
- [x] **Implement**: 创建 `TimelineProvider`, `IngestionProvider` 基本结构。完成 Repository 注入。
- [x] **Document**: 绘制状态流动示意图。
- [x] **Test**: 验证 Provider 的 `ref.watch` 监听逻辑正确.
- [x] **Review**: 是否符合 `constitution.md#II. Architecture (MVVM)`. 
- [x] **Commit**: `feat(logic): bootstrap riverpod providers for core state management`

### T13.1 UI Kit Base: 原子组件与主题 [x]
- [x] **Implement**: 配置全局 `ThemeData` (Teal/White Palette) 与 Typography (Inconsolata)。实现 `ActiveButton`, `SecurityIndicator`。 (Ref: Constitution#X. UI/UX)
- [x] **Document**: 建立 `atoms/` 组件预览文档。
- [x] **Test**: 模拟器查验色彩对比度与字体清晰度。
- [x] **Review**: 确认文字排版是否严格遵循等宽字体规范。
- [x] **Commit**: `feat(ui): implement base UI atoms and brand theme`

### T13.2 UI Kit Structure: 导航与全局组件 [x]
- [x] **Implement**: 实现 `CustomTopBar` (含返回与加密状态展示), `MainFab` (核心操作按钮)。
- [x] **Document**: 备注这些组件在不同页面间的通用逻辑。
- [x] **Test**: 验证 `Fab` 在不同屏幕尺寸下的位置与内边距。
- [x] **Review**: 走查组件点击反馈是否优雅。
- [x] **Commit**: `feat(ui): develop structural UI components (topbar, fab)`

### T13.3 UI Kit Complex: EventCard 开发 [x]
- [x] **Implement**: 封装 `SecureImage` 异步解密展示组件. 实现 `EventCard` 并集成 `SecureImage` 展示 Record 的首张缩略图，显示去重后的标签列表。 (Ref: Spec#4.1)
- [x] **Document**: 记录 `tags_cache` 在 UI 层的解析示例。
- [x] **Test**: 验证长标签列表下的布局稳定性.
- [x] **Review**: 走走查解密过程中的 UI 占位图效果.
- [x] **Commit**: `feat(ui): implement complex EventCard with decrypted thumbnail support`

### T14: 安全引导与应用锁界面 (T1.5) [x]
- [x] **Implement**: 实现 `SecurityOnboardingPage`。提供 Pin 码设置/指纹启用引导。 (Ref: Spec#FR-001)
- [x] **Document**: 设置流程的逻辑分支图.
- [x] **Test**: 验证设置完成后，逻辑标识（如 `has_lock = true`）被正确存入数据库.
- [x] **Review**: 审查安全提示语是否足够醒目.
- [x] **Commit**: `feat(ui): implement application lock setup and onboarding experience`

### T15: 首页 Timeline 与 详情解密展示 UI [x]
- [x] **Implement**: 完成首页 Timeline 列表及详情页。集成解密引擎大图浏览。 (Ref: Phase 1 Goal)
- [x] **Document**: 记录详情页在大图关闭后的内存回收流程.
- [x] **Test**: 物理测试流畅度，针对 10 张大图的快速切换执行内存检查 (DoD-T3.3).
- [x] **Review**: 确保解密大图仅存在于内存，不进入任何公开临时目录.
- [x] **Commit**: `feat(ui): finalize timeline and detail view with full decryption pipeline`

---

## 6. Hardening & UX Refinement (Phase 1+)

### T16: Phase 1 强化与体验重构 [x]
- [x] **Implement Core Security**: 
    - 实现 App 生命周期监听，冷启动或从后台恢复时强制校验 Pin/生物识别 (LockScreen)。
    - 处理 `status.md` 工作项：
        - `T16.1`: 实现独立缩略图加密密钥 (Update Entity & ImageRepository)。
        - `T16.2`: 切换为高压缩 JPEG (由于 `image` 库不支持 WebP 编码，暂退为 JPEG)。
        - `T16.3`: 数据库初始化配置 `PRAGMA cipher_page_size = 4096`。
- [x] **Refactor Timeline UI**:
    - 去除底部 TabBar，将 `Settings` 移至 AppBar 右侧 Icon。
    - 优化 `EventCard`：去重标签，仅显示首个 Tag；改为 4-6 张图网格预览，超量显示 `>`。
        * [ ] 这里需要修改为：每张图片都要显示 Tag，但仅显示排序第一的 Tag。

    - 优化数据查询，避免 N+1 性能问题。
- [x] **Refactor Ingestion Flow**:
    - 简化为：首页点击 "+" -> 原生相机/库选择 -> 进入 Preview 预览页 (支持裁剪/旋转/删除) -> 一键保存后返 回首页。
- [x] **Refactor Detail View**:
    - [x] 实现“上下分屏”布局：顶部图片（支持左右切图同步更新下方信息），底部展示图片专有的“医院、日期、标 签”。
        * [x] 单击图片放大（这个功能之前是有的，更新后没了）
        * [x] 左右切图的按钮 `<` 和 `>` 点击没反应
    - [x] 每张图下方增加针对当前图片的 “编辑” 与 “删除” 按钮。
    - [x] 移除详情页中重复的灰色标签及“备注”字段.
    - [x] 标签选择器
        * [x] **单击选中** 标签之后 `高亮`（比如：单击选中 标签A 之后， 标签A 的颜色变成 `高亮`）。
        * [x] 拖拽排序：通过 `拖动` 标签来改变排序。    
        * [x] 支持多选    
    - [x] 当用户点击编辑时显示用户全量标签库.
- [x] **Test**: 针对重构后的录入流与详情页联动进行全量物理测试与单元测试回归 (Passing 54 tests).
- [x] **Commit**: `refactor(ui): pivot to split-view details and streamlined ingestion workflow`

---

## Phase 2: On-Device OCR & Intelligence (智能录入层)

### T17: 基础设施与 Schema 升级 (Phase 2.1) [x]
- [x] **Implement (T17.1)**: 在 `pubspec.yaml` 中添加 `google_mlkit_text_recognition`, `workmanager`, `sqflite_common_ffi` (用于 FTS5 测试) 等依赖。 (Complexity: Low)
    - *Ref: Constitution#III. Intelligent Digitization (Offline dependencies)*
- [x] **Implement (T17.2)**: 更新 `Image` (增加 ocr_data) 实体类，新建 `OCRQueueItem` 实体. 运行 `build_runner`。 (Complexity: Low)
    - *Ref: Constitution#VII. Coding Standards (Immutable Entities)*
- [x] **Implement (T17.3)**: 编写 SQL 迁移脚本 `migration_v2.sql`。
    - 1. `ALTER TABLE records ALTER COLUMN status SET DEFAULT 'processing'`.
    - 2. `ALTER TABLE images ADD COLUMN ocr_text TEXT`. (以及其他字段)
    - 3. `CREATE TABLE ocr_queue`.
    - 4. `CREATE VIRTUAL TABLE ocr_search_index USING fts5`.
    - *Ref: Constitution#VI. Security (SQLCipher Schema)* (Complexity: Medium)
- [x] **Implement (T17.4)**: 实现 `OCRQueueRepository` (入队/出队/状态更新) 及 `SearchRepository` (FTS5 查询)。 (Complexity: Medium)
    - *Ref: Constitution#II. Architecture (Repository Pattern)*
- [x] **Test**: 编写单元测试验证 Schema 升级后的数据读写兼容性及 FTS5 搜索基础功能。 (Complexity: Medium)

### T18: OCR 引擎集成 (Phase 2.2)
- [x] **Implement (T18.1)**: 定义 `IOCRService` 抽象接口及 `OCRResult` 数据结构 (包含 text, blocks, confidence)。 (Complexity: Low)
    - *Ref: Constitution#II. Architecture (Facade Pattern)*
- [x] **Implement (T18.2 - Android)**: 实现 `AndroidOCRService`，集成 `google_mlkit_text_recognition`。配置 `android/build.gradle`。 (Complexity: Medium)
    - *Ref: Constitution#II. Local-First (Offline ML Kit)*
- [x] **Implement (T18.3 - iOS)**: 实现 `IOSOCRService`。
    - 编写 iOS 端 `NativeOCRPlugin` 和 `AppDelegate` 集成 (利用 Vision Framework `VNRecognizeTextRequest`)。
    - 实现 Flutter 端 MethodChannel 调用封装。
    - *Ref: Constitution#II. Local-First (Native Vision Framework)* (Complexity: High)
- [ ] **Test**: 分别在 Android/iOS 真机断网环境下验证图片文字识别准确率。 (Complexity: Medium)

### T19: 业务逻辑与后台队列 (Phase 2.3)
- [x] **Implement (T19.1)**: 创建 `SmartExtractor` 工具类。实现日期 (`RegExp`) 和医院名称 (关键词/正则) 的提取策略。 (Complexity: Low)
    - *Ref: Spec#FR-203 Intelligent Extraction*
- [x] **Implement (T19.2)**: 实现 `OCRProcessor` 核心服务。串联 `Queue -> OCR -> Extraction -> DB` 流程。包含置信度评分逻辑。 (Complexity: High)
    - *Ref: Spec#FR-203 Confidence Strategy*
- [x] **Implement (T19.3 - Android)**: 配置 `WorkManager`。实现 `OCRWorker`，确保后台任务保活与执行。 (Complexity: Medium)
- [x] **Implement (T19.4 - iOS)**: 配置 `BGTaskScheduler`。在 `AppDelegate.swift` 中注册后台任务标识，处理后台执行时间窗口。 (Complexity: High)
    - *Ref: Spec#FR-202 Async Queue*
- [ ] **Test**: 模拟 App 切后台 5 分钟后，队列任务仍能自动执行并更新数据库。 (Complexity: High)

### T20: UI 适配与交互闭环 (Phase 2.4)
- [x] **Implement (T20.1)**: 更新首页 `HomeState`，增加 `pendingCount` 统计。实现“待确认”顶部横幅组件。 (Complexity: Low)
- [x] **Implement (T20.2)**: 开发 `ReviewListPage` (待确认列表) 和 `ReviewEditPage` (OCR 结果校对页)。
    - 实现 OCR 文本高亮层 `OCRHighlightView` (在原图上绘制识别框)。
    - *Ref: Constitution#X. UI/UX (Teal/White Theme)* (Complexity: High)
- [x] **Implement (T20.3)**: 升级详情页。支持点击按钮查看完整 OCR 识别文本 (解密后展示)。 (Complexity: Medium)
- [x] **Implement (T20.4)**: 开发 `GlobalSearchPage`。连接 FTS5 搜索接口，展示高亮匹配结果。 (Complexity: Medium)
- [ ] **Test**: 全链路测试“拍照 -> 后台识别 -> 首页提示 -> 校对归档”流程。 (Complexity: High)

### T21: Phase 2 体验补完与逻辑优化
- [x] **Implement (T21.1) 自动刷新机制**:
    - 在首页与详情页实现对 OCR 队列状态的监听。当后台任务完成时，自动刷新 UI 状态（如隐藏“处理中”动画、显示“待确认”状态）。
- [x] **Implement (T21.2) 级联删除逻辑**:
    - 优化删除逻辑：当一个 Record 下的所有图片被用户手动删除后，自动删除该 Record 实体及其关联的 OCR 队列任务。
- [x] **Implement (T21.3) OCR 质量与重新识别**:
    - 修复 OCR 结果可能出现空白的问题，增强异常捕获向。
    - 在详情页增加“重新识别”功能入口，允许手动触发 OCR 流程。
- [x] **Implement (T21.4) 详情页编辑闭环**:
    - 优化字段编辑（医院、日期）后的保存逻辑，确保 Timeline 立即同步更新。
- [x] **Implement (T21.5) 物理擦除优化 (Technical Debt)**:
    - 针对 T10 遗留问题，优化图片临时文件的物理擦除逻辑。


## Phase 3: Governance & Store Readiness

**Status**: Planning (Speckit.Tasks)
**Objective**: 实现多人员管理、标签 CRUD、增强搜索及离线加密备份。

---

### 3.1 Infrastructure & Schema (数据库与基础设施) [x]

| ID | 任务描述 | 复杂度 | 类型 | 依赖关系 | 宪章引用 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T3.1.1** | **数据库 Schema 迁移 (V7)**: 1. `persons` 表增加 `order_index` (INTEGER) 和 `profile_color` (TEXT)。 2. `tags` 表增加 `is_custom` (INTEGER) 和 `person_id` (TEXT) 的完整外键支持。 | 中 | 依赖任务 | Phase 2 完成 | [x] |
| **T3.1.2** | **FTS5 索引结构优化**: 更新 `ocr_search_index` 虚拟表，确保包含 `hospital_name`, `tags`, `ocr_text` 和 `notes` 字段。 | 中 | 依赖任务 | T3.1.1 | [x] |
| **T3.1.3** | **种子数据增强**: 首次进入时，确保“本人”档案具有 `is_default=1` 且不可删除。 | 低 | 独立任务 | - | [x] |

---

### 3.2 Data Layer (数据访问层 - Repository)

| ID | 任务描述 | 复杂度 | 类型 | 依赖关系 | 宪章引用 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T3.2.1** [x]| **PersonRepository 实现**: 1. 实现人员的 CRUD。 2. **删除约束**: 若人员下有记录则禁止删除。 3. 实现拖拽排序 (`updateOrder`)。 | 中 | 依赖任务 | T3.1.1 | I. 隐私与安全 |
| **T3.2.2** [x]| **TagRepository 动态化改造**: 1. 支持基于 `person_id` 查询标签。 2. 实现标签重命名时的全局同步逻辑。 3. **级联处理**: 删除标签时从所有 `Image.tags` 中移除该 ID。 | 高 | 依赖任务 | T3.1.1 | VII. 编码规范 |
| **T3.2.3** [x]| **SearchRepository 全文检索增强**: 实现多字段 Match 查询，支持关键词在高亮结果中返回。 | 中 | 依赖任务 | T3.1.2 | II. 本地优先 |

---

### 3.3 Business Logic & Services (业务逻辑与服务)

| ID | 任务描述 | 复杂度 | 类型 | 依赖关系 | 宪章引用 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T3.3.1** [x]| **多人员隔离 Provider**: 在 Riverpod 中实现 `currentPersonProvider`。拦截所有 Repository 调用，自动注入当前 `person_id` 过滤条件。 | 中 | 依赖任务 | T3.2.1 | [x] |
| **T3.3.2** [x]| **安全备份引擎 (Export)**: 实现 `.phbak` 导出逻辑。 1. 使用用户 PIN 码通过 PBKDF2 派生加密密钥。 2. 将加密 DB 与图片打包为 ZIP 流。 3. 调用 `Share` 插件分享。 | 高 | 独立任务 | - | I & VI. 加密规范 |
| **T3.3.3** [x]| **安全备份引擎 (Import)**: 实现 `.phbak` 恢复逻辑。 1. 验证密钥。 2. 支持“覆盖”或“重映射导入”。 3. 恢复后重启数据库连接。 | 高 | 依赖任务 | T3.3.2 | IV. 零信任原则 |
| **T3.3.4** [x]| **关键词建议标签逻辑**: 实现 OCR 文本关键词提取（如：血常规、CT、处方），若匹配现有标签则自动设为“建议标签”。 | 中 | 独立任务 | - | III. 智能数字化 |
| **T3.3.5** [x]| **安全设置 Service**: 实现修改 PIN 码逻辑，及生物识别（FaceID/指纹）的开启/关闭持久化逻辑。 | 中 | 独立任务 | - | I. 安全锁原则 |

---

### 3.4 UI Layers (界面展示 - Flutter Widgets)

#### Timeline 首页与搜索
| ID | 任务描述 | 复杂度 | 类型 | 依赖关系 | 宪章引用 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T3.4.1** [x]| **首页 PersonnelTabs 组件**: 实现胶囊式滑动 Tab，支持人员切换动画过渡，最右侧带 `[+]` 入口。 | 中 | 依赖任务 | T3.3.1 | VI. UI/UX 准则 |
| **T3.4.2** [x]| **免责声明 (Disclaimer) 弹窗**: 实现首次启动时的强制弹窗逻辑，内容符合医疗合规要求。 | 低 | 独立任务 | - | IX. 日志/用户提示 |
| **T3.4.3** | **筛选浮层 (Filter Sheet)**: 实现按日期范围（预设+自定义）和标签多选（按字母排序）的 Timeline 筛选功能。 | 中 | 依赖任务 | T3.2.2 | VI. UI/UX 准则 |
| **T3.4.4** | **全局搜索全屏页**: 基于 FTS5 的全屏搜索交互，展示包含全文、备注和医院名的匹配结果。 | 中 | 依赖任务 | T3.2.3 | VI. UI/UX 准则 |

#### 3.5 详情页增强
| ID | 任务描述 | 复杂度 | 类型 | 依赖关系 | 宪章引用 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T3.5.1** | **可折叠 OCR 全文组件**: 在标签下方实现折叠文本域，默认 3-4 行，支持展开/折叠查看完整 OCR。 | 低 | 独立任务 | - | VI. UI/UX 准则 |
| **T3.5.2** | **内联标签管理与自定义**: 1. 修改现有标签选择器样式（选中高亮）。 2. 支持直接在列表末尾点击 `+` 呼起输入框创建新标签并关联。 3. 实现拖拽排序。 | 高 | 依赖任务 | T3.2.2 | VI. UI/UX 准则 |

#### 3.6 设置与管理页
| ID | 任务描述 | 复杂度 | 类型 | 依赖关系 | 宪章引用 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T3.6.1** | **人员管理页 (Personnel Page)**: 实现完整列表，支持增删改名、拖拽排序、及删除时的记录数检查提示。 | 中 | 依赖任务 | T3.2.1 | VI. UI/UX 准则 |
| **T3.6.2** [x]| **标签库管理中心**: 实现“选择人员 -> 列表展示 -> CRUD”的完整管理流。 | 中 | 依赖任务 | T3.2.2 | VI. UI/UX 准则 |
| **T3.6.3** | **备份与恢复 UI**: 实现数据管理入口，包含备份、恢复按钮，及危险操作的二次确认警告。 | 中 | 依赖任务 | T3.3.2/3 | IX. 用户提示 |
| **T3.6.4** | **隐私与安全设置项**: 实现修改 PIN 码页面和生物识别开关。 | 中 | 依赖任务 | T3.3.5 | I. 安全锁原则 |


### 3.7 Store Readiness (上架合规)

| ID | 任务描述 | 复杂度 | 类型 | 依赖关系 | 宪章引用 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **T3.7.1** | **静态隐私政策渲染**: 内置 Markdown 文件，在设置页提供离线渲染展示，强调数据不离机。 | 低 | 独立任务 | - | I. 隐私与安全 |
| **T3.7.2** | **多尺寸资产适配**: 生成适配 iOS/Android 的全套 Icon、Launch Screen 和 Store 截图。 | 中 | 独立任务 | - | VI. UI/UX 准则 |

### 3.8 OCR全文 格式化json

**T3.8.1**
目标
建立一套统一的 OCR 结果数据结构，支持跨平台坐标归一化和语义化扩展。
核心任务
定义 , , , 模型。
使用 实现 JSON 序列化。
坐标系统：使用 [x, y, w, h] 存储相对比例（0.0~1.0），解决不同分辨率设备的对齐问题。
元数据：支持记录识别来源、语言和时间。
验收标准
模型单元测试通过。
兼容旧版本 的解析逻辑。

**T3.8.2**
目标
将 Android (ML Kit) 和 iOS (Vision) 的原始输出转换为统一的 格式。
核心任务
重构 接口，返回 。
Android: 将 映射至新模型，计算相对图像宽高的比例坐标。
iOS: 处理 Vision Framework 的坐标系翻转（iOS 默认原点在左下，Flutter 在左上），完成归一化。
确保 和 被正确传递至服务层。
验收标准
双端返回的数据结构一致。
在不同比例的图片上， 均能准确代表文字位置。

**T3.8.3**
目标
在 OCR 原始数据上增加一层后处理逻辑，自动注入语义含义。
核心任务
实现 类，作为 OCR 识别后的“增强器”。
键值对拆分: 识别 或 ，自动将一行拆分为 和 类型的 Token。
章节识别: 利用几何特征（如独立成行、无标点、首行缩进等）识别章节标题（如“病理诊断”）。
文本清洗: 修复常见的 OCR 分词碎片化问题。
验收标准
对于典型的医疗报告，能够自动将“医院名称”或“项目名”标记为 label 类型。

**T3.8.4**
目标
将详情页的“OCR 全文”展示升级为支持分段和语义高亮的“增强型列表”。
核心任务
创建 组件。
渲染逻辑:
Section Title 渲染为加粗/小标题样式。
Line/Tokens 使用 渲染， 类型使用主题色/灰色区分。
降级处理: 如果数据为旧格式，自动回退到传统的纯文本渲染展示。
性能: 优化长文档的滚动流畅度。
验收标准
UI 符合 Task 3.6 定义的视觉预期。
支持点击切换“原文”与“增强视图”。

**T3.8.5**
目标
实现基于坐标 (XY-Cut) 的文本布局重组，修复 OCR 原始文本的阅读顺序。
核心任务
在 `OcrEnhancer` 中实现排序逻辑：
1. **Y轴聚类**: 将 Y 坐标重叠度 > 50% 的文字块视为同一行。
2. **X轴排序**: 行内元素按 X 坐标升序排列。
3. **格式化**: 根据块间距自动插入制表符 `	` (列分隔) 或换行符 `
`。
替换 `OcrProcessor` 中的纯文本拼接逻辑，使用重组后的结构化文本。
验收标准
对于多栏排版的检验报告（如：项目 | 结果 | 参考值），重组后的 `fullText` 应能正确保留表格结构，而非左右栏混杂。

### 3.9 问题反馈

**问题反馈**
[入口]：在 设置页增加 问题反馈 。
[内容]：纯文本展示，不包含任何输入框或上传功能。文案：“我们致力于保护您的隐私，App 为纯离线运行。如需反馈问题，请通过以下方式与我们联系。”
客服邮箱：点击后：调用设备的原生邮件客户端 (mailto: 协议)，并预填收件人地址VitaNode@outlook.com。
GitHub Issues：https://github.com/VitaNode/PHF/issues，点击后：调用设备的原生浏览器 (https://...) 打开指定的 GitHub Issues 页面。
[数据采集]：在反馈页面底部，可提供 一键复制日志 按钮，将非隐私的设备信息（如 App 版本、系统版本、设备型号、日志）复制到剪贴板，方便用户手动粘贴到邮件或 Issue 中。

**关于日志**
上架之前，需要把主页 topbar 的 日志 去掉。
日志需要改成 加密日志库，在写入 app_logs.txt 之前，先通过内存中的对称密钥进行加密。
日志脱敏
严禁记录： 密钥、用户密码、数据库解密后的敏感字段。
关键信息遮蔽： 姓名、身份证号码、手机号等均需要屏蔽。
避免日志文件过大
文件滚动： 当日志文件超过 2MB 时，清空旧日志或重写。
生命周期： 每次启动 App 时，检查并删除 7 天前的旧日志。
“一键复制”日志（用于上面的“问题反馈”）
在复制到剪贴板之前在内存中完成解密。用户复制的时候，能看到是可读的文字（方便确认没有泄露额外隐私）。
需要确保在手机硬盘里的 .txt 文件全是加密后的乱码，这样即使手机丢失或被黑客提取，日志信息也是安全的。

---

## Phase 4: SLM Data Pipeline & Internationalization (P4)

### T22: 国际化基础设施与语言包 (Phase 4.1) [x]
- [x] **Implement (T22.1)**: 在 `pubspec.yaml` 中添加 `flutter_localizations` 和 `intl: ^0.18.1`。配置 `generate: true`。(Ref: Constitution#XI. Internationalization)
- [x] **Implement (T22.2)**: 创建 `lib/l10n` 目录，并初始化 `app_en.arb` 和 `app_zh.arb`。定义基础 Key（如 `common_save`, `common_edit`）。
- [x] **Implement (T22.3)**: 编写数据库迁移脚本 `migration_v8.sql`。
    - `ALTER TABLE records ADD COLUMN is_verified INTEGER DEFAULT 0;`
    - `ALTER TABLE records ADD COLUMN group_id TEXT;`
- [x] **Test**: 运行 `flutter gen-l10n` 验证代码生成；验证数据库升级后 `is_verified` 字段默认值为 0。(Ref: Constitution#VI. Security)
- [x] **Commit**: `feat(i18n): initialize localization scaffolding and update database schema v8`

### T23: SLM 数据预处理管道 (Phase 4.2) [x]
- [x] **Implement (T23.1)**: 定义 `SLMDataBlock` 实体类，包含坐标信息、置信度以及脱敏标记字段。(Ref: Constitution#VII. Coding Standards)
- [x] **Implement (T23.2)**: 实现 `LayoutParser` 工具类。使用启发式聚类算法，将分散的 OCR Blocks 按 y 轴坐标重组成“行”。(Ref: Constitution#II. Local-First)
- [x] **Implement (T23.3)**: 实现 `PrivacyMasker` 服务。使用正则表达式自动识别并掩盖姓名、手机号等 PII 信息。(Ref: Constitution#IV. Security & Privacy)
- [x] **Implement (T23.4)**: 实现 `MedicalUnitNormalizer`。建立映射表，将 `g/L`, `G/L` 等变体统一为标准格式。
- [x] **Implement (T23.5)**: 实现 `MarkdownConverter`。将处理后的 `SLMDataBlock` 序列化为 Markdown 表格字符串。(Ref: Constitution#X. Performance)
- [x] **Test**: 为 `LayoutParser` 编写单元测试，输入带有错位坐标的 JSON，验证输出的 Markdown 文本顺序正确。
- [x] **Commit**: `feat(slm): implement layout-aware parser and privacy masking pipeline`

### T24: UI 交互增强与全球化适配 (Phase 4.3)
- [x] **Implement (T24.1)**: 开发 `FocusZoomOverlay` 组件。通过 CustomPainter 实现像素级精准对焦与放大预览。(Ref: d001dd7)
- [x] **Implement (T24.2)**: 在 `ReviewEditPage` 中集成置信度高亮。对 `confidence < 0.8` 的 `TextField` 应用橙色警告背景，引导用户精准校对。
- [x] **Implement (T24.3)**: 扩充 ARB 文件，完整覆盖西、葡、印尼、越、泰、印地语。重点检查泰语、印地语在长文本下的 UI 截断问题。
- [x] **Implement (T24.4)**: 在录入流程中增加 `PageGroupSelector`，允许用户将多张图片标记为同一 `group_id`，为 SLM 多页上下文分析提供支持。

### T26: 国际化深度覆盖与硬化 (Phase 4.5) [x]
- [x] **Implement (T26.1) 全站硬编码清理**: 遍历 `lib/presentation` 下的所有页面和组件，将所有硬编码中文迁移至 ARB 文件。
- [x] **Implement (T26.2) 补全多国语言包**: 确保西、葡、印尼、越、泰、印地语 ARB 文件包含与 `app_en.arb` 100% 同步的 Key。
- [x] **Implement (T26.3) 初始种子数据国际化**: 针对 `DatabaseSeeder` 产生的“本人”等默认数据，实现基于系统语言的动态生成。
- [x] **Test (T26.4) 长文本溢出测试**: 在泰语、印地语环境下对详情页、卡片页执行布局压力测试，修复文字截断问题。

### T25: SLM 启动前的数据微调 (Phase 4.4 Refinements) [x]
- [x] **Implement (T25.1)**: 升级数据库至 V11。在 `records` 表中增加 `ai_interpretation` (TEXT) 和 `interpreted_at` (DATETIME) 字段。
- [x] **Implement (T25.2)**: 建立 `analysis_results` 表，用于存储 SLM 提取的结构化 JSON（含分类、异常项、摘要）。
- [x] **Implement (T25.3)**: 优化 `BackgroundWorker` 调度算法。确保在 OCR 任务完成后，自动检测电量及充电状态，低优先级触发 SLM 预提取逻辑。
- [x] **Implement (T25.4)**: 实现“上下文压缩算法”。在将 OCR 文本送入 SLM 之前，剔除页眉页脚、冗余免责声明，仅保留指标、诊断结论等核心 Context。

---

## Phase 5: On-Device SLM Intelligence (端侧医疗智能解读)
**Goal**: 将应用进化为能看懂病历、能分析趋势的智能助理，实现“数字化复刻”排版。

### 5.1 OCR增强 [x]

- [x] **T5.1.1 前端: 原生文档扫描器** [x]
    - iOS: 实现 DocumentScanner MethodChannel，调用 VNDocumentCameraViewController。
    - Android: 集成 ML Kit Document Scanner。
    - 目标: 获取裁剪矫正后的图片。
- [x] **T5.1.2 中端: 原生 OpenCV 增强管线 (Extreme Clarity)** [x]
    - 集成: 在 iOS (Podfile) 和 Android (Gradle) 引入 OpenCV 原生库。
    - 算法管线 (Native C++/Swift/Kotlin):
        1. Gray: 转灰度。
        2. CLAHE: cv::createCLAHE(clipLimit=2.0, tileGridSize=(8,8)) (参数可调) —— 拉伸局部对比度。
        3. Bilateral Filter: bilateralFilter —— 保边去噪。
        4. Adaptive Threshold: adaptiveThreshold，其中 blockSize = width / 30 (动态计算) —— 二值化。
    - 输出: 完美的二值化图像路径。
- [x] **T5.1.3 后端: 串联业务** [x]
    - Flutter 端串联：Scanner -> NativeProcessor -> OCR Service。
- [x] **T5.1.4 其他（备注）** [x]
    - 需要测试纸质材料的识别
    - 增加分流逻辑，模拟器不启用增强型原生相机，真机才启用。（上架之前要去掉）

### 5.2 结构化提取与排版重构 (Logic)

- [ ] **T5.2.1 实现基于坐标 (XY-Cut) 的文本布局重组，修复 OCR 原始文本的阅读顺序**: 在 `OcrEnhancer` 中实现排序逻辑：1. **Y轴聚类**: 将 Y 坐标重叠度 > 50% 的文字块视为同一行。2. **X轴排序**: 行内元素按 X 坐标升序排列。3. **格式化**: 根据块间距自动插入制表符 `	` (列分隔) 或换行符 `。替换 `OcrProcessor` 中的纯文本拼接逻辑，使用重组后的结构化文本。

- [ ] **T5.2.2 实现结构化提取逻辑**: 不急于解读，先让 SLM 将乱序文本转换为标准 JSON (Item/Value/Unit/Status)。
- [ ] **T5.2.3**: 实现 **“历史趋势解析器”**。根据标准化项目名，检索数据库过去 3 次记录，计算趋势。
- [ ] **T5.2.4**: 开发 **“排版重构引擎”**。UI 根据 SLM 的语义块，渲染出类似于纸质资料的整齐电子报表。

- [ ] **T5.2.5 LOINC与别名库Alias Map**: 把 "HGB、Hb、血红蛋白" 全部指向同一个 LOINC 唯一标识。建立一套 **“别名库（Alias Map）”** ，把非标准的、口语化 的 项目名 和 标准 LOINC 关联起来。


### 5.3 模型基础设施 (Infrastructure)
**Goal**: 集成 `llama.cpp` 并建立模型下载与管理机制。

- [ ] **T5.3.1 Llama.cpp Engine Integration**: 集成 `llama_cpp_dart`。验证在 iOS (Metal) 和 Android (Vulkan/CL) 上的推理速度。
- [ ] **T5.3.2 Model Management Service**: 实现 GGUF 模型的按需下载、完整性校验 (SHA256) 与存储管理。支持断点续传。 
- [ ] **T5.3.3 Memory & Performance Profiling**: 建立性能监控。确保模型加载时内存占用符合预期 (Low: 0.5b, High: 4b)，退后台自动卸载。

### 5.4 Local RAG System (本地检索增强生成)
**Goal**: 基于 SQLite 的向量存储与混合检索系统。

- [ ] **T5.4.1 Vector Store Implementation**: 扩展 SQLite Schema，创建 `knowledge_vectors` 表 (ID, Text, EmbeddingBlob)。 
- [ ] **T5.4.2 Embedding Engine**: 集成轻量级 GGUF Embedding 模型 (via llama.cpp)。实现文本转向量接口。 
- [ ] **T5.4.3 Hybrid Search Logic**: 实现“关键词 (FTS5) + 语义 (Vector Cosine)”混合检索算法。DoD: 准确检索到医学知识库中的相关条目。 
- [ ] **T5.4.4 Local Knowledge Library**: 建立 **本地医学知识 SQL 库**。包含常用 200+ 检验项的标准临床意义、危急值及建议，用于 RAG 增强。


### 5.5 智能解读与 UX (User Experience)
**Goal**: 面向用户的解读与对话功能。

- [ ] **T5.5.1**: 实现 **Insight Card (解读卡片)**。在详情页顶部展示 AI 结论、风险提示及生活建议。
- [ ] **T5.5.2**: 开发 **对话式追问 (Medical QA)**。基于当前病历进行单/多轮提问，利用本地 RAG 确保回答稳健。
- [ ] **T5.5.3**: 设计“推理中”骨架屏。提供深度视觉反馈，缓解端侧推理（10s+）的焦虑感。
- [ ] **T5.5.4 Medical Report Interpretation**：实现“一键解读”：OCR 文本 -> Prompt 构建 (含 RAG 上下文) -> LLM 推理 -> 结构化输出 (Markdown/JSON)。 
- [ ] **T5.5.5 Structured Extraction (JSON)**：利用 llama.cpp Grammar Sampling 提取关键指标 (Key-Value) 用于趋势分析。
- [ ] **T5.5.6 Interactive Chat UI**：实现流式输出 (Streaming Response) 的对话界面，支持停止生成与重新生成。

### 5.6 全球化 AI 适配
- [ ] **T5.6.1**: 适配 8 种语言的 System Prompt，确保 SLM 输出报告语言与 App 语言设置一致。

---

## Phase 6: Hardening & Store Readiness (上架硬化与发布准备)
**Goal**: 确保加解密链路 100% 稳健，重构首页展现形式，补全合规文档。

### T6.1: 安全性全链路审计 (Security & Stability Audit)
- [ ] **T6.1.1**: 编写集成测试，验证“拍 5 张图 -> 杀掉进程 -> 冷启动 -> 输入 Pin -> 解密”的闭环。
- [ ] **T6.1.2**: 验证磁盘空间不足或权限关闭等极端情况下的数据库稳健性。

### T6.2: 首页与详情 UI 最终打磨 (Summary-First UI)
- [ ] **T6.2.1**: 首页 Timeline 重构：用“分类图标 + 医院名称 + 识别摘要”取代缩略图。
- [ ] **T6.2.2**: 实现“关键指标一览”：在 Timeline 卡片上直接标注异常项。
- [ ] **T6.2.3**: 优化详情页编辑流：解决日期选择器遮挡预览窗的问题。

### T6.3: 品牌化、合规与反馈系统
- [ ] **T6.3.1**: 生成全套尺寸的 App Icon 和 Splash Screen。
- [ ] **T6.3.2**: 完善《隐私政策》Markdown 及开源 LICENSE。
- [ ] **T6.3.3**: 实现设置页“加密日志一键复制”与“邮件/GitHub 反馈”系统。
- [ ] **T6.3.4**: 最终 GM (Gold Master) 回归测试与 AppBundle/IPA 构建验证。
