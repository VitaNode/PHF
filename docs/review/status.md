```
# Project Review Status Summary

**Last Updated**: 2026-01-05
**Coverage**: T0 - T3.4.4 (Global Search)

## Approved Features (Highlights)
- [x] **T20.4**: 全局搜索 (FTS5 + Highlight).
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
  - **Timeline**: Simplified navigation (AppBar-only settings), 4-6 image grid preview, and optimized data loading.
  - **Ingestion**: Streamlined "Capture -> Preview -> Save" flow.
  - **Detail View**: Split-view layout with per-image metadata (Hospital, Date, Tags) support and in-place editing. Fully enhanced Tag Selector with highlighting and drag-sort.
  - **OCR Integration (T20)**: "Pending Review" banner, `ReviewListPage` for batch processing, and `ReviewEditPage` with **OCR Text Highlighting**.
- **Components**: `EventCard` and `SecureImage` (T13.3) for secure in-memory media rendering.
- **OCR (Phase 2)**: `IOCRService` (T18.1), `AndroidOCRService` (T18.2), and `IOSOCRService` (T18.3) reviewed and refactored.
- **Intelligence (Phase 2)**: `SmartExtractor` (T19.1) and `OCRProcessor` (T19.2) reviewed. Core extraction and background orchestration logic verified.
- **Background (Phase 2)**: `BackgroundWorkerService` (T19.3 - Android) implemented and verified.
- **Background (Phase 2)**: iOS `BGTaskScheduler` & Headless Plugin Registry (T19.4) implemented and verified.
- [x] **UI (Phase 2)**: Detail View OCR Viewer (T20.3) implemented and robust.
- [x] **UI (Phase 2)**: `GlobalSearchPage` (T20.4) implemented with FTS5 highlighting.
    - [x] **Review & Reinforcement (2026-01-05)**: Added FTS5 query sanitization and improved Monospace font application.

## 🟢 Phase 3 In Progress
Phase 3 (Governance & Store Readiness) has started.

### Completed (Phase 3)
- [x] **T3.4.4**: UI - Global Full-screen Search.
    - Refactored `GlobalSearchPage` for improved "Full-screen" UX.
    - Integrated with `AppCard` and `AppTheme` standards.
    - Enhanced FTS5 highlighting logic and added personnel context indicator.
    - Implemented debounced search and better empty/initial states.
- [x] **T3.3.5**: Security Settings Service.
    - Implemented `ISecurityService` interface and refined `SecurityService`.
    - Added PIN modification logic with old PIN validation.
    - Added biometric persistence and toggle logic.
    - Implemented `SecuritySettingsController` for reactive UI updates.
- [x] **T3.1**: Infrastructure & Schema (V7 Migration).
    - `persons` table: Added `order_index`, `profile_color`.
    - `tags` table: Added `is_custom`, `order_index`.
    - `ocr_search_index`: Optimized FTS5 structure (hospital, tags, ocr_text, notes).
    - `DatabaseSeeder`: Enhanced default seed data.
    - Entities updated and `build_runner` executed.
- [x] **T3.3.1**: Multi-Person Isolation Provider.
    - Implemented `currentPersonIdControllerProvider` and `currentPersonProvider` in Riverpod.
    - Updated `TimelineController`, `SearchController`, and `ReviewListController` to automatically isolate data by `person_id`.
    - Refactored `ocrPendingCountProvider` and `allTagsProvider` to be responsive to the current personnel context.
    - Updated `AppMetaRepository` to persist the selected user ID across app restarts.
- [x] **T3.4.1**: UI - PersonnelTabs Component.
    - Implemented capsule-style sliding tabs for person switching.
    - Integrated with `currentPersonIdControllerProvider` for persistence and isolation.
    - Follows `Constitution` UI standards (Teal, Monospace, specific radii).
- [x] **T3.5.1**: UI - Collapsible OCR Text Component.
    - Implemented `CollapsibleOcrCard` widget with expansion logic.
    - Integrated into `RecordDetailPage` info view.
    - Follows Monospace font standards for medical data.

## 🟢 Phase 2 Complete
All Phase 2 tasks (T17-T20) are implemented and verified. The system now supports:
- Offline OCR (Android/iOS).
- Intelligent Extraction (Date/Hospital).
- Background Queue Processing.
- Full UI Integration (Review Flow, Search, Details).

## 🟡 Pending Issues / Technical Debt
- None.

## 🔴 Blockers
- None.

---
*Note: This document is updated after every task review to provide a holistic view of technical health.*
