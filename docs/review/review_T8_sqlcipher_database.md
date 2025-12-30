# Review T8: SQLCipher Database Service & Schema

**Review Date**: 2025-12-29
**Reviewer**: Antigravity
**Status**: 🟢 APPROVED with Optimizations

## Summary
The `SQLCipherDatabaseService` provides a secure, encrypted storage layer using SQLCipher. The schema implementation in `_onCreate` strictly follows the `T8_DATABASE_SCHEMA.md` and correctly incorporates foreign key constraints, indexing, and FTS5 for search.

## Security Audit

### 1. Encryption & Key Management
- **Requirement**: Use SQLCipher (AES-256) with a master key.
- **Implementation**: Correctly retrieves 32-byte Master Key from `MasterKeyManager` and encodes it as Base64 for the DB password.
- **Observation**: `sqflite_sqlcipher` handles the key application internally.
- **Result**: 🟢 Pass.

### 2. Schema Alignment (T2.1)
- **Tables**: `persons`, `records`, `images`, `tags`, `image_tags`, `hospitals`, `app_meta` are all implemented.
- **OCR Support**: Added `ocr_text`, `ocr_raw_json`, and `ocr_confidence` directly to the `images` table, which is a good extension of the original plan for performance.
- **FTS5**: `ocr_search_index` virtual table is correctly set up with `UNINDEXED record_id`.
- **Foreign Keys**: Correctly used `REFERENCES` with `ON DELETE CASCADE` for all relations.
- **Result**: 🟢 Pass.

### 3. Database Settings
- **Foreign Keys**: Enabled via `PRAGMA foreign_keys = ON` in `_onConfigure`.
- **Page Size**: Documentation specifies `4096`, but it is currently commented out in the code.
- **Result**: 🟡 Minor (See Optimizations).

## Code Quality
- **Batch Operations**: Uses `db.batch()` for efficient creation of all tables and indexes.
- **Indexes**: Strategic indexes on `visit_date`, `status`, and `page_index` are implemented.
- **Path Management**: Delegates to `PathProviderService` to ensure files stay in the security sandbox.

## Suggested Optimizations & Omissions

### 1. Explicit Cipher Configuration
While SQLCipher 4 defaults to 4096/256000, it's safer to be explicit to prevent issues if underlying defaults change in future package updates.
> [!TIP]
> Uncomment and enable `PRAGMA cipher_page_size = 4096;` in `_onConfigure`.

### 2. KDF Iteration Setting
The constitution might require a specific KDF iteration count for higher security (e.g., 256,000 or higher). This is currently left at default.

### 3. Missing `tags_initialization`
The `TAGS` table is created, but the task T9 (Seeds) is yet to be done. Ensure that `seeds` logic is separated from schema creation to keep `database_service.dart` clean.

### 4. Database Path Privacy
Ensure that `phf_encrypted.db` is stored in the application's *private* documents directory (it is, via `PathProviderService`).

---
**Final Status**: 🟢 APPROVED
