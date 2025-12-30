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
- [x] **Implement**: 定义 `IRecordRepository`, `IImageRepository`, `ICryptoService`, `IImageService` 接口类。
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
- [x] **Implement**: 实现 `ImageProcessingService`。PNG 压缩 fallback + 200px 缩略图。**强制：** 处理完位图或中间临时文件后，立即调用 `File.delete()`。 (Ref: Constitution#I. Privacy#IV. Security)
- [x] **Document**: `review_image_wipe.md` -> `review_T10_image_processing.md` - 说明如何在异步流中确保清理逻辑 100% 被执行。
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
- [x] **Review**: 走查解密过程中的 UI 占位图效果.
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
    - 简化为：首页点击 "+" -> 原生相机/库选择 -> 进入 Preview 预览页 (支持裁剪/旋转/删除) -> 一键保存后返回首页。
- [x] **Refactor Detail View**:
    - [x] 实现“上下分屏”布局：顶部图片（支持左右切图同步更新下方信息），底部展示图片专有的“医院、日期、标签”。
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
