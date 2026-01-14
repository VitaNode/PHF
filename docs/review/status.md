# Project Review Status Summary

**Last Updated**: 2026-01-09
**Coverage**: T0 - Phase 4 (SLM Data Pipeline & Internationalization)

## Approved Features (Highlights)
- [x] **Issue #128**: 修复解锁后自动跳转到首页的问题。
    - **Architecture**: 在 `MaterialApp.builder` 中使用 `Stack` 保留 `Navigator` 状态。
    - **UX**: 确保 App 在解锁后能恢复到之前的页面（如：详情页、设置页），而不是重置到首页。
    - **Safety**: 在锁定状态下通过 `AbsorbPointer` 禁用背景页面的交互。
- [x] **Issue #96**: 修复数据恢复失效及 UI 刷新延迟。
    - **Backup**: 修正了备份 ZIP 中的目录结构，确保数据库恢复到 `db/` 子目录而非沙盒根目录。
    - **Restore**: 增强了恢复后的状态刷新逻辑，显式重置所有核心业务 Provider，确保 UI 立即感知数据变更。
- [x] **Issue #98**: FTS5 搜索索引多用户隔离加固。
    - **Schema**: 确保 `ocr_search_index` 虚拟表包含 `person_id` 列 (UNINDEXED)。
    - **Logic**: 在 `RecordRepository.searchRecords` 和 `SearchRepository.search` 中强制执行 `fts.person_id = ?` 过滤。
    - **Testing**: 补全了 `repository_test.dart` 中的 FTS 架构定义，并增加了跨用户搜索隔离的安全性测试。
- [x] **Issue #124**: 修复高频录入时的 `database is locked` 错误及 Riverpod 状态访问冲突。
    - **Database**: 引入了 `DatabaseExecutor` 模式，使所有 Repository 支持在顶级事务中运行。重构了 `submit` 和 `processNextItem` 以使用单一事务，彻底消除了事务竞争导致的锁定。
    - **Riverpod**: 修复了 `IngestionController` 在 `onDispose` 中访问已销毁状态导致的断言错误。改用局部 `_pathsToCleanup` 集合安全追踪临时文件。
- [x] **Issue #121**: 修复“立即锁定”设置在非首页路由下失效的问题。
    - **Architecture**: 将锁屏拦截逻辑从 `AppLoader` 移动至 `MaterialApp.builder`。
    - **Logic**: 通过全局 Builder 包装 `Navigator`，确保无论当前处于哪个路由（如：设置页、详情页），只要 `isLocked` 为真，都会强制显示 `LockScreen` 覆盖层。
    - **Refinement**: 优化了 `AppLoader` 的路由分发逻辑，并确保在安全引导流程完成后自动解锁，避免拦截。
- [x] **Issue #113**: Feedback System & Encrypted Logging.
    - **Secure Logging**: Implemented `EncryptedLogService` with AES-256-GCM, automatic rotation (daily files), and PII masking (`LogMaskingService`).
    - **Feedback UI**: Added `FeedbackPage` with secure "Copy Logs" functionality (decrypts in memory), Email integration, and GitHub Issues link.
    - **Hardening**: Removed debug log access from Home Page top bar.
- [x] **T20.4**: 全局搜索 (FTS5 + Highlight).
    - **Fix (2026-01-06)**: Enabled Chinese search support in FTS5 by implementing manual CJK character segmentation during indexing and query parsing (Issue #95).
    - **Fix (2026-01-06)**: Upgraded FTS5 index to version 9 with `unicode61` tokenizer fallback.
- [x] **T21.2**: 级联删除逻辑 (当图片全删时自动清理 Record 及其 OCR 任务).
- [x] **T21.3**: OCR 质量补强与“重新识别”功能.
- [x] **T21.4**: 详情页与校对页编辑闭环 (确保同步更新 Timeline).
- [x] **T21.1**: 自动刷新机制 (监听 OCR 队列状态并自动更新 UI).
- [x] **T21.5**: 物理擦除优化 (实现随机覆盖 + Flush 的安全删除逻辑).
- [x] **T20.6**: 修复 iOS 后台 OCR 调度及延迟 bug.
- [x] **T21**: 修复图片删除崩溃并集成 `talker` 日志系统.
- **Security Core**: AES-256-GCM encryption (T5), secure key management (T4), and random IV/path management (T6).
- **Hardening (T16)**: Mandatory app lock on re-entry, independent thumbnail encryption keys, and optimized database configuration (Page Size = 4096).
- **Onboarding & Auth**: Security Onboarding (T14) with PIN setup (SHA-256) and optional biometric authentication.
- **Data Persistence**: Encrypted SQLCipher database (T8) with FTS5. Initial Schema and Seed Data (T9) deployed.
- **Repository Layer**: Type-safe `RecordRepository`, `ImageRepository` (T12), `OCRQueueRepository`, and `SearchRepository` (T17). Automated tag cache synchronization and OCR task management.
- **Image Handling**: WebP compression (T16), basic processing (T10), and Gallery/Camera integration (T11).
- **UI & UX (T16 Overhaul)**: 
  - **Timeline**: Simplified navigation, 4-6 image grid preview, and optimized data loading.
  - **Ingestion**: Streamlined "Capture -> Preview -> Save" flow.
  - **Detail View**: Split-view layout with per-image metadata (Hospital, Date, Tags) support and in-place editing.
  - **OCR Integration (T20)**: "Pending Review" banner, `ReviewListPage` for batch processing, and `ReviewEditPage` with **OCR Text Highlighting**.
- **Components**: `EventCard` and `SecureImage` (T13.3) for secure in-memory media rendering.
- **OCR (Phase 2)**: `IOCRService` (T18.1), `AndroidOCRService` (T18.2), and `IOSOCRService` (T18.3) reviewed and refactored.
- **Intelligence (Phase 2)**: `SmartExtractor` (T19.1) and `OCRProcessor` (T19.2) reviewed. Core extraction and background orchestration logic verified.
- **Background (Phase 2)**: `BackgroundWorkerService` (T19.3) and iOS `BGTaskScheduler` (T19.4) implemented and verified.
- [x] **UI (Phase 2)**: Detail View OCR Viewer (T20.3) implemented and robust.
- [x] **UI (Phase 2)**: `GlobalSearchPage` (T20.4) implemented with FTS5 highlighting and query sanitization.
- [x] **T3.3.6 (Issue #111)**: 增强应用锁逻辑与自动锁定设置。
    - **Logic**: Implemented time-based lock (default 1 min, options: 1 min, 5 min, Immediate).
    - **Bug Fix**: Resolved FaceID only working on cold start by re-triggering authentication on `resumed` lifecycle state.
    - **UI**: Added "Auto Lock Time" setting to Privacy & Security page and manual biometric trigger to LockScreen.
- [x] **T3.6.5 (Issue #113)**: 问题反馈与日志加固。
    - **Log Security**: Implemented AES-256-GCM encrypted log storage with PII redaction (LogMasker) and 7-day auto-rotation.
    - **UI**: Added "Problem Feedback" page in Settings with mailto/GitHub links and one-click copy of decrypted/de-identified logs.
    - **Refinement**: Removed debug log entry from homepage AppBar for production readiness.
- [x] **Issue #98**: 强化 FTS5 搜索索引的多用户数据隔离。
    - **Security**: Forced `person_id` validation in both `SearchRepository` and `RecordRepository` FTS queries.
    - **Architecture**: Refactored repositories to automatically sync FTS index on metadata or tag updates.
    - **Robustness**: Unified CJK segmentation and query sanitization via `FtsHelper`.

## 🟢 Phase 3 Complete
Phase 3 (Governance & Store Readiness) is now complete.

### Completed (Phase 3)
- [x] **T3.1**: Infrastructure & Schema (V7 Migration).
    - `persons` table: Added `order_index`, `profile_color`.
    - `tags` table: Added `is_custom`, `order_index`.
    - `ocr_search_index`: Optimized FTS5 structure (hospital, tags, ocr_text, notes).
- [x] **T3.3.1**: Multi-Person Isolation Provider.
    - Implemented `currentPersonIdControllerProvider` and `currentPersonProvider` in Riverpod.
    - Updated controllers to automatically isolate data by `person_id`.
- [x] **T3.3.2 & T3.3.3**: Secure Backup Engine.
    - Implemented `BackupService` with AES-256-GCM encryption and ZIP streaming.
- [x] **T3.3.5**: Security Settings Service.
    - Implemented PIN modification and biometric toggle logic.
- [x] **T3.4.1**: UI - PersonnelTabs Component.
- [x] **T3.4.4**: UI - Global Full-screen Search.
- [x] **T3.5.1**: UI - Collapsible OCR Text Component.
- [x] **T3.5.2**: UI - Inline Tag Management.
- [x] **T3.6.1**: UI - Personnel Management Page.
- [x] **T3.6.2**: UI - Tag Library Center.
- [x] **T3.6.3**: UI - Backup & Restore Interface.
- [x] **T3.6.4**: UI - Privacy & Security Settings.
- [x] **T3.7.1**: Store - Static Privacy Policy.
- [x] **T3.7.2**: Store - Asset Adaptation.
- [x] **T3.8.1**: OCR - Schema V2.
    - Defined multi-level `OcrResult` structure (`Page` -> `Block` -> `Line` -> `Element`).
    - Implemented coordinate normalization (0.0 - 1.0) across platforms.
- [x] **T3.8.2**: OCR - Platform Adapter Refactoring.
    - Standardized all OCR-related classes to **PascalCase** (`OcrResult`, `OcrBlock`, etc.).
    - Integrated `talker` logging system into native adapters.
    - **Fix (2026-01-06)**: Added `text-recognition` (Latin) dependency to `build.gradle.kts`.
- [x] **T3.8.3**: OCR - Heuristic Enhancement Layer.
    - Implemented `OcrEnhancer` with multi-page support, Key-Value splitting, and noise cleaning.
- [x] **T3.8.4**: UI - Enhanced OCR Structured Text Display.
    - Developed `EnhancedOcrView` with dual-mode support and `ListView` performance optimization.
    - **Fix (2026-01-06)**: Resolved `RenderFlex` overflow in `CollapsibleOcrCard`.

## 🟢 Phase 4 Complete
Phase 4 (SLM Data Pipeline & Internationalization) is now complete.

### Completed (Phase 4)
- [x] **T22**: 国际化基础设施与数据库 V10 升级。
    - **i18n**: 集成 `flutter_localizations`，建立 `lib/l10n` 及非合成包生成模式 (`lib/generated/l10n`)，支持多语言动态切换。
    - **Schema (V10)**: `records` 表新增 `is_verified` (用于 SLM 校验) 和 `group_id` (用于跨页文档关联) 字段。
    - **Refinement**: 将 `LockScreen` 关键 UI 文本迁移至国际化资源包。
- [x] **T23**: SLM 数据预处理管道。
    - **LayoutParser**: 基于 Y 轴聚类和 X 轴排序的启发式算法，重组 OCR Lines 为符合阅读顺序的数据块。
    - **PrivacyMasker**: 本地 PII 脱敏服务，基于正则表达式过滤手机号和身份证号。
    - **UnitNormalizer**: 医学单位归一化工具，统一不同写法的单位格式.
    - **MarkdownConverter**: 将结构化数据块序列化为 Markdown 表格格式，优化 SLM 输入 Token。
- [x] **T24**: UI 交互增强与全球化适配。
    - **FocusZoom**: 实现 `FocusZoomOverlay` 局部放大预览组件，通过归一化坐标实时裁剪解密图像。
    - **groupId**: 在 `ReviewEditPage` 中实现 `groupId` (跨页报告) 切换逻辑，支持多图关联。
    - **i18n**: 补全 ES, PT, ID, VI, TH, HI 全量 ARB 词条映射，解决国际化运行时的缺失报错。
    - **Hardening**: 为 Repository 添加 `groupId` 持久化支持，并修复测试环境 Schema 缺失问题。
- [x] **Refactor**: SearchRepository 架构重构与实体映射集中化。
    - **Architecture**: 引入 `EntityMapper` Mixin，统一全站数据库行至领域实体的解析逻辑，代码量减少 ~40%。
    - **Performance**: 沉淀 `fetchImagesForRecords` 通用逻辑至 `BaseRepository`，彻底消除 N+1 查询隐患。
    - **Robustness**: 重写 FTS5 搜索流，实现 SQL 构建、结果抓取与数据组装的职责分离。

## 🟢 Phase 5.1 Complete
Phase 5.1 (OCR Enhancement) is now complete.

### Completed (Phase 5.1)
- [x] **T5.1.1**: 原生文档扫描器集成。
    - **iOS**: 集成 `VisionKit` -> `VNDocumentCameraViewController`，支持自动裁切与矫正。
    - **Android**: 集成 `ML Kit Document Scanner`，提供系统级高质量文档捕获。
- [x] **T5.1.2**: 原生 OpenCV 增强管线。
    - **Algorithm**: 实现了 `CLAHE` (局部对比度增强) -> `Bilateral Filter` (保边去噪) -> `Adaptive Thresholding` (动态二值化) 的极致清晰管线。
    - **iOS**: 封装 `OpenCVWrapper` (Local Pod)，解决 C++ 宏冲突并实现硬件加速。
    - **Android**: 实现 `ImageProcessor` (Kotlin)，集成 OpenCV SDK。
- [x] **T5.1.3**: Flutter 业务全链路串联。
    - 实现了 `DocumentScannerService` 和 `ImageProcessorService`。
    - 改造 `IngestionController`，支持扫描后自动进入增强管线处理。
- [x] **T5.1.4**: 模拟器兼容性分流。
    - 引入 `device_info_plus`，在模拟器环境下自动隐藏原生扫描入口，确保开发流程平滑。

## 🟡 Pending Issues / Technical Debt (New for Phase 4 & 5)
- None.

## 🔴 Blockers
- None.

---
*Note: This document is updated after every task review to provide a holistic view of technical health.*