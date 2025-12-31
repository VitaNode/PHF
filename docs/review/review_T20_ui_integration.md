# Review Log: T20 UI Integration

**Task IDs**: T20.1, T20.2
**Date**: 2025-12-31
**Reviewer**: Gemini Agent

## 1. Review Summary
The implementation of the UI components for the OCR review flow was reviewed.

### 1.1 Scope
- `lib/presentation/pages/timeline/widgets/pending_review_banner.dart` (T20.1)
- `lib/logic/providers/states/home_state.dart` (T20.1)
- `lib/presentation/pages/timeline/timeline_page.dart` (Integration)
- `lib/presentation/pages/review/review_list_page.dart` (T20.2)
- `lib/presentation/pages/review/review_edit_page.dart` (T20.2)
- `lib/presentation/pages/review/widgets/ocr_highlight_view.dart` (T20.2)
- `ios/Runner/NativeOCRPlugin.swift` (Cross-cutting Refactor)

### 1.2 Findings

#### State Management
- **Issue**: `HomeState` usage in `HomePage` was merely a wrapper. `TimelinePage` correctly handles the provider consumption and banner display.
- **Lint**: `review_list_provider.dart` had unnecessary awaits. Fixed.

#### UI Logic
- **Issue**: `ReviewEditPage` failed to cast `jsonDecode` result, potentially causing runtime type errors. Fixed by explicit cast to `Map<String, dynamic>`.
- **Lint**: `ReviewListPage` navigation callback didn't await the refresh future. Fixed.

#### Cross-Platform Consistency (OCR Coordinates)
- **Critical Issue**: Android ML Kit returns **absolute** pixel coordinates for bounding boxes, while iOS Vision Framework returns **normalized** (0.0-1.0) coordinates with a flipped Y-axis.
- **Impact**: `OCRHighlightView` (UI) expects absolute coordinates to draw overlay boxes correctly on the image. Without standardization, iOS highlights would be microscopic (0-1 pixel size).
- **Refactor**: Modified `NativeOCRPlugin.swift` (iOS) to denormalize the coordinates and flip the Y-axis before returning data to Dart. This ensures the Dart UI code remains uniform for both platforms.

## 2. CI/Test Verification
- **Unit/Widget Tests**: 
  - `test/presentation/pages/timeline/timeline_page_test.dart`: Updated to verify `PendingReviewBanner` appears when pending count > 0.
  - `test/logic/services/ios_ocr_service_test.dart`: Re-verified basic service logic.
- **Result**: All tests passed (100%).

## 3. Fix Record

### Modified Files
- `lib/logic/providers/review_list_provider.dart`: Cleaned async logic.
- `lib/presentation/pages/review/review_edit_page.dart`: Fixed JSON type casting.
- `lib/presentation/pages/review/review_list_page.dart`: Fixed unawaited future.
- `ios/Runner/NativeOCRPlugin.swift`: Standardized OCR coordinate system.
- `test/presentation/pages/timeline/timeline_page_test.dart`: Added UI integration tests.
