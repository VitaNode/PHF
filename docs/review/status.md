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
- [x] **T3.5.2**: UI - Inline Tag Management (Issue #25).
    - Refactored `TagSelector` to support inline creation, search, and sorting.
    - Added "Create Tag" workflow with immediate `allTagsProvider` refresh.
    - Integrated `TagRepository.createTag` with UUID generation.
    - Updated `RecordDetailPage` to handle new tag creation callback.
    - **Review & Reinforcement (2026-01-05)**: Enforced strict UI/UX (8px radius), added robustness (Try-Catch in UI/Repo), and integrated `Talker` logging.
- [x] **T3.6.2**: UI - Tag Library Center.
    - Implemented `TagManagementPage` with personnel context.
    - Supported CRUD for custom tags and drag-sorting.
    - Integrated with `SettingsPage`.
- [x] **T3.6.1**: UI - Personnel Management Page (Issue #26).
    - Implemented `PersonnelManagementPage` with CRUD and drag-sort support.
    - Integrated with `allPersonsProvider` for real-time updates.
    - Added deletion constraint check (records must be empty).
    - **Review & Reinforcement (2026-01-05)**: Applied Monospace font to nicknames, added full error handling/logging (Talker) in Repository and UI, and fixed `orderIndex` logic for new entries.
- [x] **T3.6.3**: UI - Backup & Restore Interface (Issue #28).
    - Implemented `BackupPage` with secure export/import workflows.
    - Added confirmation dialogs for data-destructive operations.
    - Integrated `file_picker` for backup restoration.
    - Reused `PinKeyboard` for secure PIN entry during backup operations.
    - Added comprehensive widget tests for the backup interface.
    - **Review & Reinforcement (2026-01-05)**: Applied Monospace font to security dialogs, unified error SnackBar styling (`AppTheme.errorRed`), and enhanced fine-grained logging for the backup/restore sequence.
- [x] **T3.6.4**: UI - Privacy & Security Settings (Issue #29).
    - Implemented `SecuritySettingsPage` for app lock management.
    - Added PIN modification flow with old PIN verification and confirmation.
    - Integrated biometric authentication toggle (fingerprint/face).
    - Added reactive state management for security settings using Riverpod.
    - **Review & Reinforcement (2026-01-05)**: Standardized error SnackBar styling (`AppTheme.errorRed`), applied Monospace font to security dialogs, and enhanced `SecurityService` with detailed logging for audit trails.
- [x] **T3.7.1**: Store - Static Privacy Policy (Issue #30).
    - Implemented `PrivacyPolicyPage` with offline Markdown rendering.
    - Integrated with settings navigation.
    - **Review & Reinforcement (2026-01-05)**: Enforced `fontFamily: AppTheme.fontPool` (Inconsolata) for all Markdown elements to comply with the UI/UX constitution for important text. Optimized rendering styles.
- [x] **T3.7.2**: Store - Asset Adaptation (Issue #31).
    - Integrated `flutter_launcher_icons` and `flutter_native_splash` for automated asset generation.
    - Configured multi-platform icon specs and Android 12+ adaptive support.
    - Set up native splash screen logic with brand colors (#008080).
    - Created placeholder source assets and asset generation guide.
    - **Review & Reinforcement (2026-01-05)**: Fixed `pubspec.yaml` font path configurations to eliminate test warnings. Executed and verified full asset generation pipeline for Android and iOS.
- [x] **T3.8.1**: OCR - Schema V2 (Issue #81).
    - Defined multi-level `OCRResult` structure (Block -> Line -> Element).
    - Implemented coordinate normalization (0.0 - 1.0) across Android and iOS.
    - Added V1/V2 compatibility logic in `OCRHighlightPainter`.
    - Integrated metadata (source, language, timestamp) into models.
    - Updated native code in `AppDelegate.swift` and `MainActivity.kt` to support V2.
- [x] **T3.8.2**: OCR - Platform Adapter Refactoring (Issue #82).
    - Standardized native coordinate systems across Android (ML Kit) and iOS (Vision) with 0.0-1.0 normalization.
    - Integrated `talker` logging system into `AndroidOCRService` and `IOSOCRService`.
    - Standardized all OCR-related classes to **PascalCase** (`OcrResult`, `OcrBlock`, etc.) across the codebase.
    - Registered `ocrServiceProvider` in `core_providers.dart` with platform-specific instantiation.
    - Verified cross-platform consistency of Schema V2 (Pages) outputs.
    - Refactored `OcrEnhancer` to support multi-page structures.
- [x] **T3.8.3**: OCR - Heuristic Enhancement Layer (Issue #83).
    - Implemented `OcrEnhancer` with multi-page support.
    - Added **Key-Value Splitting** for both Chinese and English colons.
    - Implemented **Section Title Identification** based on geometric and keyword features.
    - Added **Fragment Cleaning** to remove OCR noise (e.g., table lines, stray characters).
    - Verified semantic tagging (`label`, `value`, `sectionTitle`) via unit tests.
    - Integrated with `OCRProcessor` for automatic enhancement after recognition.
- [x] **T3.8.3**: OCR - Heuristic Semantic Enhancement (Issue #83).
    - Implemented `OCREnhancer` for post-recognition semantic augmentation.
    - Added Key-Value splitting logic for lines containing colons (label/value).
    - Implemented section title identification using geometric and keyword-based heuristics.
    - Updated `OCRResult` model to support `OCRSemanticType` (label, value, section_title).
    - Integrated enhancement layer into `OCRProcessor` pipeline.
- [x] **T3.8.4**: UI - Enhanced OCR Structured View (Issue #84).
    - Implemented `EnhancedOcrView` for semantically highlighted text rendering.
    - Upgraded `CollapsibleOcrCard` with "Original" vs "Enhanced" mode toggle.
    - Integrated structured rendering into `RecordDetailPage` info view and OCR bottom sheet.
    - Supported automatic fallback to plain text for legacy OCR data.
    - Verified with comprehensive widget tests.
- [x] **T3.3.2 & T3.3.3**: Secure Backup Engine.
    - Implemented `BackupService` with AES-256-GCM encryption and ZIP streaming.
    - Integrated with `share_plus` for encrypted backup distribution.
    - Implemented atomic restore logic with database connection management in `BackupController`.

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
