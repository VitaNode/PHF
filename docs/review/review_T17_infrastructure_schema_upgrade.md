# Review: T17 Infrastructure & Schema Upgrade (Phase 2.1)

**Review Date**: 2025-12-31
**Reviewer**: Gemini Agent

## 1. 持续集成 (CI) 模拟
- **Static Analysis**: 发现 `lib/data/repositories/ocr_queue_repository.dart` 中缺少 `sqflite` 引用导致编译错误。已修复。
- **Tests**: 
  - 缺少 T17 相关单元测试。
  - 新增 `test/data/repositories/ocr_queue_repository_test.dart` 覆盖队列逻辑。
  - 新增 `test/data/migration_v6_test.dart` 覆盖 Schema 升级逻辑。
  - 所有新增测试通过。

## 2. 深度代码审查 (Review)

### A. Normative (规范性)
- `OCRQueueItem` 与 `OCRQueueRepository` 命名符合规范。
- 目录结构符合 Clean Architecture。

### B. Security (安全性)
- Schema 升级脚本正确处理了 `images` 表的列扩展，但遗漏了 Phase 2.1 要求的 OCR 相关字段 (`ocr_text`, `ocr_raw_json`, `ocr_confidence`)。已补全。
- `SQLCipherDatabaseService` 为了支持 FFI 测试，进行了重构，允许注入 `DatabaseFactory`。在测试环境下不使用密码加密（FFI 限制），但在生产环境下保持 SQLCipher 加密。

### C. Robustness (健壮性)
- 发现 `SQLCipherDatabaseService` 的 `_onUpgrade` 方法在 v6 升级块中缺少对 `images` 表的修改。若不修复，应用升级后 `images` 表将缺少字段，导致插入/读取失败。

### D. Readability (可读性)
- 代码注释清晰。

## 3. 自动化修复 (Refactor)
- **修复 1**: `ocr_queue_repository.dart` 添加 `sqflite_sqlcipher/sqflite.dart` 导入。
- **修复 2**: `database_service.dart` 的 `_onUpgrade` 方法中添加 `ALTER TABLE images ADD COLUMN ...` 语句。
- **修复 3**: `database_service.dart` 构造函数增加 `dbFactory` 参数，支持测试环境注入 FFI Factory。

## 4. 结论
- 修复了严重的编译错误和 Schema 迁移遗漏。
- 补全了单元测试。
- 代码质量符合 Constitution 标准。
