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

### T1: 物理目录架构与脚手架 [低]
- [ ] **Implement**: 创建核心分层目录。配置 `analysis_options.yaml` 强化 Lint。
- [ ] **Document**: 更新 `lib/README.md`，定义模块可见性规则。 (Ref: Constitution#II. Architecture)
- [ ] **Test**: `flutter analyze` 确保脚手架零警告。
- [ ] **Review**: 确认物理结构足以支撑 Clean Architecture 落地。
- [ ] **Commit**: `feat(scaffold): initialize core architecture directory structure`

### T2: 领域实体模型 (Domain Entities) [低]
- [ ] **Implement**: 实现 `Record`, `Image`, `Tag`, `Person` 实体类。禁止使用 `dynamic`。 (Ref: Constitution#VII. Coding Standards)
- [ ] **Document**: 定义核心实体的 ID 生成规则与 JSON 序列化规范。
- [ ] **Test**: 编写实体转换单元测试。
- [ ] **Review**: 检查命名是否符合 Dart 驼峰规范。
- [ ] **Commit**: `feat(data): define core domain entities for records and images`

### T3: 业务契约 (Interfaces) 定义 [低]
- [ ] **Implement**: 定义 `IRecordRepository`, `IImageRepository`, `ICryptoService`, `IImageService` 接口类。
- [ ] **Document**: 为接口方法提供详尽的 `dartdoc` 以及预期行为说明。
- [ ] **Test**: 验证接口不暴露底层加密/SQL 实现细节。 (Ref: Constitution#II. Architecture)
- [ ] **Review**: 接口粒度是否符合单一职责原则。
- [ ] **Commit**: `feat(architecture): define abstract interfaces for repositories and services`

---

## 2. Infrastructure & Security (P1)
**Goal**: 落地安全内核与沙盒。

### T4: 密钥与 User Salt 管理工厂 [中]
- [ ] **Implement**: 实现 `MasterKeyManager`。负责 256-bit Master Key 和随机 Salt 的生成、持久化。 (Ref: Constitution#I. Privacy)
- [ ] **Document**: 录入 Master Key 派生流程图。
- [ ] **Test**: `persistence_test.dart` 验证重启 App 后仍能读取到一致的 Key (DoD-T1.1)。
- [ ] **Review**: `review_keystore_security.md` - 审计 KeyStore/KeyChain 调用安全性。
- [ ] **Commit**: `feat(security): implement master key and user salt management`

### T5: AES-256-GCM 核心加密逻辑 [高]
- [ ] **Implement**: 实现 `CryptoEngine`。封装物理加密逻辑，集成 AAD。 (Ref: Constitution#VI. Security)
- [ ] **Document**: `ENCRYPTION_SPEC.md` 标注 AAD 和 Tag 字节长度。
- [ ] **Test**: 编写针对边缘情况（空数据、超大数据分片）的单元测试。
- [ ] **Review**: `review_encryption_flow.md` - 审查算法实现是否严格符合 GCM 范式。
- [ ] **Commit**: `feat(security): implement core AES-256-GCM crypto engine`

### T6: 文件安全封装器 (Stream & IV Prepend) [高]
- [ ] **Implement**: 实现 `FileSecurityWrapper`。负责大文件流式加解密、IV 头部预置/提取 (T1.4)。 (Ref: Constitution#VII. Performance)
- [ ] **Document**: 更新文件头结构布局图。
- [ ] **Test**: 验证同一文件两次加密结果不一致 (DoD-T1.4)。
- [ ] **Review**: `review_file_security.md` - 重点审计流处理时的内存阈值控制。
- [ ] **Commit**: `feat(security): implement streaming file security with IV prepending`

### T7: 沙盒目录与权限治理 (T1.6) [低]
- [ ] **Implement**: 实现 `PathProviderService`。初始化加密存储专用沙盒，管理系统权限弹窗。 (Ref: Constitution#I. Privacy)
- [ ] **Document**: 列出应用所有私有存储路径及其用途。
- [ ] **Test**: 仿真权限拒绝场景，验证 App 降级逻辑。
- [ ] **Review**: `review_storage_sandbox.md` - 确认无任何文件暴露在外部可读路径。
- [ ] **Commit**: `feat(storage): setup security sandbox and permission handlers`

---

## 3. Data & Storage Implementation (P2)
**Goal**: 数据库驱动与种子数据。

### T8: SQLCipher 初始化与实体映射 (T2.1) [中]
- [ ] **Implement**: 实现 `SQLCipherDatabaseService`。部署全量 Schema (records, images, tags 等)。 (Ref: Constitution#VI. Security)
- [ ] **Document**: `DATABASE_SCHEMA.md` 记录详细表结构及外键约束逻辑。
- [ ] **Test**: 导出 `.db` 物理文件并尝试破解（应失败）。
- [ ] **Review**: `review_sqlcipher_config.md` - 审查 Page Size 和 KDF 参数配置。
- [ ] **Commit**: `feat(data): deploy encrypted SQLCipher storage and core schema`

### T9: 种子数据初始化与默认档案 [低]
- [ ] **Implement**: 执行首次启动种子脚本。创建 `def_me` 档案与 4 个内置分类标签。 (Ref: Spec#FR-001)
- [ ] **Document**: 备注各标签默认颜色（Teal 调色板）。
- [ ] **Test**: 验证 `persons` 表初始行数为 1，且 `id` 命中外键。
- [ ] **Review**: 审查档案昵称是否符合中性化/隐私化命名。
- [ ] **Commit**: `feat(data): seed default user profile and system tags`

---

## 4. Business Logic & Services (P3)
**Goal**: 处理媒体存取与隐私擦除。

### T10: 图片处理引擎与 Secure Wipe (T3.1) [高]
- [ ] **Implement**: 实现 `ImageProcessingService`。WebP 压缩 + 200px 缩略图。**强制：** 处理完位图或中间临时文件后，立即调用 `File.delete()`。 (Ref: Constitution#I. Privacy#IV. Security)
- [ ] **Document**: `review_image_wipe.md` - 说明如何在异步流中确保清理逻辑 100% 被执行。
- [ ] **Test**: `wipe_verification_test.dart` 检查磁盘残留 (DoD-T3.1)。
- [ ] **Review**: 审查异常抛出后，临时文件是否依然能被清理。
- [ ] **Commit**: `feat(logic): implement image optimizer with reliable secure wipe`

### T11: 相册导入与跨平台权限 (T3.4) [中]
- [ ] **Implement**: 集成 `image_picker` 并完成 `Info.plist` / `AndroidManifest.xml` 配置。支持多图选择。 (Ref: Constitution#III. Intelligent Digitization)
- [ ] **Document**: 更新 `SETUP.md` 记录 iOS 相册权限描述文案。
- [ ] **Test**: 物理测试相册批量选择。
- [ ] **Review**: 是否存在将相册路径上传至不可控日志的风险。
- [ ] **Commit**: `feat(logic): integrate gallery import with native permission config`

### T12: Repository 基础实现与 Tags 同步 [中]
- [ ] **Implement**: 实现通用 Repository 基类及 `Record/ImageRepository`。核心逻辑：维护 `image_tags` 到 `records.tags_cache` 的自动同步。 (Ref: Spec#4.1)
- [ ] **Document**: 记录 tags_cache 的 JSON 聚合逻辑。
- [ ] **Test**: 执行录入测试，验证 Record 表缓存字段被自动更新。
- [ ] **Review**: 审查 SQL 事务在处理多对多关系时的完整性。
- [ ] **Commit**: `feat(data): implement repository logic with automatic tags_cache synchronization`

---

## 5. UI Layer & State Management (P4)
**Goal**: 完整 MVP 界面闭环。

### T13: Riverpod 状态脚手架搭建 [低]
- [ ] **Implement**: 创建 `TimelineProvider`, `IngestionProvider` 基本结构。完成 Repository 注入。
- [ ] **Document**: 绘制状态流动示意图。
- [ ] **Test**: 验证 Provider 的 `ref.watch` 监听逻辑正确。
- [ ] **Review**: 是否符合 `constitution.md#II. Architecture (MVVM)`。
- [ ] **Commit**: `feat(logic): bootstrap riverpod providers for core state management`

### T13.1 UI Kit Base: 原子组件与主题 [低]
- [ ] **Implement**: 配置全局 `ThemeData` (Teal/White Palette) 与 Typography (Inconsolata)。实现 `ActiveButton`, `SecurityIndicator`。 (Ref: Constitution#X. UI/UX)
- [ ] **Document**: 建立 `atoms/` 组件预览文档。
- [ ] **Test**: 模拟器查验色彩对比度与字体清晰度。
- [ ] **Review**: 确认文字排版是否严格遵循等宽字体规范。
- [ ] **Commit**: `feat(ui): implement base UI atoms and brand theme`

### T13.2 UI Kit Structure: 导航与全局组件 [低]
- [ ] **Implement**: 实现 `CustomTopBar` (含返回与加密状态展示), `MainFab` (核心操作按钮)。
- [ ] **Document**: 备注这些组件在不同页面间的通用逻辑。
- [ ] **Test**: 验证 `Fab` 在不同屏幕尺寸下的位置与内边距。
- [ ] **Review**: 走查组件点击反馈是否优雅。
- [ ] **Commit**: `feat(ui): develop structural UI components (topbar, fab)`

### T13.3 UI Kit Complex: EventCard 开发 [中]
- [ ] **Implement**: 实现 `EventCard`。逻辑：解密显示 Record 的首张缩略图，显示去重后的标签列表。 (Ref: Spec#4.1)
- [ ] **Document**: 记录 `tags_cache` 在 UI 层的解析示例。
- [ ] **Test**: 验证长标签列表下的布局稳定性。
- [ ] **Review**: 走查解密过程中的 UI 占位图效果。
- [ ] **Commit**: `feat(ui): implement complex EventCard with decrypted thumbnail support`

### T14: 安全引导与应用锁界面 (T1.5) [中]
- [ ] **Implement**: 实现 `SecurityOnboardingPage`。提供 Pin 码设置/指纹启用引导。 (Ref: Spec#FR-001)
- [ ] **Document**: 设置流程的逻辑分支图。
- [ ] **Test**: 验证设置完成后，逻辑标识（如 `has_lock = true`）被正确存入数据库。
- [ ] **Review**: 审查安全提示语是否足够醒目。
- [ ] **Commit**: `feat(ui): implement application lock setup and onboarding experience`

### T15: 首页 Timeline 与 详情解密展示 UI [高]
- [ ] **Implement**: 完成首页 Timeline 列表及详情页。集成解密引擎大图浏览。 (Ref: Phase 1 Goal)
- [ ] **Document**: 记录详情页在大图关闭后的内存回收流程。
- [ ] **Test**: 物理测试流畅度，针对 10 张大图的快速切换执行内存检查 (DoD-T3.3)。
- [ ] **Review**: 确保解密大图仅存在于内存，不进入任何公开临时目录。
- [ ] **Commit**: `feat(ui): finalize timeline and detail view with full decryption pipeline`

---
