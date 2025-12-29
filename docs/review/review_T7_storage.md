# Review T7: Storage & Sandbox

**Review Date**: 2025-12-29
**Reviewer**: Antigravity
**Status**: 🟢 APPROVED

## Summary
The `PathProviderService` correctly establishes a secure directory structure within the application sandbox. The `PermissionService` provides a necessary abstraction over system permissions.

## Key Findings

### 1. Secure Sandbox Compliance
- **Verification**: Used `getApplicationDocumentsDirectory` correctly.
- **Platform Check**:
  - **iOS**: Maps to `Documents/`, which is sandboxed and backed up by iTunes (unless excluded, which is fine for user data).
  - **Android**: Maps to `/data/data/<package>/app_flutter/`, which is private to the application UID.
- **Verdict**: Compliant with `Constitution#I. Privacy`.

### 2. Temp Directory Hygiene
- **Feature**: `clearTemp()` implements a recursive delete.
- **Recommendation**: Ensure this method is called:
  1. On App Start (to clean previous crash debris).
  2. After heavy operations (e.g., OCR or batch import) complete.
  3. (Optional) On App Lifecycle `paused`/`detached`.

### 3. Android Permission Compatibility (Future Refinement)
- **Observation**: `Permission.photos` behaves differently across Android API levels (pre/post API 33).
- **Action Item**: When implementing **T11 (Gallery Import)**, verify if fallback to `Permission.storage` is required for Android 12 and below.

## Pre-flight Checklist for T8 (SQLCipher)
Since T7 prepares the `db` directory, the next task (T8) will deploy the database.
- [ ] Ensure `PathProviderService.dbDirPath` is injected into the Database Service.
- [ ] **Critical**: SQLCipher `kdf_iter` should be set to at least **64,000** (or default 256,000 for v4) to prevent brute force.
- [ ] **Critical**: Page size should match filesystem alignment (usually 4096).

---

**Next Steps**:
Proceed to **T8: SQLCipher Initialization**.
