# Project Review Status Summary

**Last Updated**: 2026-01-08
**Coverage**: T0 - Issue #113 (Feedback & Encrypted Logging)

## Approved Features (Highlights)
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

## 🟡 Pending Issues / Technical Debt (New for Phase 4)
- None.

## 🔴 Blockers
- None.

---
*Note: This document is updated after every task review to provide a holistic view of technical health.*