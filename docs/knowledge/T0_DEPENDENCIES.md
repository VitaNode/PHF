# DEPENDENCIES.md - Phase 1

**Project**: PaperHealth (PHF)
**Strategy**: Local-First, Privacy-First.

## Core Dependencies

| Package | Version | Purpose | Ref (Constitution) |
| :--- | :--- | :--- | :--- |
| `sqflite_sqlcipher` | `^3.0.0` | 加密 SQLite 存储，AES-256 位数据库级加密。 | #VI. Security |
| `flutter_riverpod` | `^2.5.1` | 响应式状态管理与依赖注入。 | #II. Architecture |
| `flutter_secure_storage`| `^9.2.2` | 用于存储 Master Key 和 User Salt 到系统安全区域。 | #I. Privacy |
| `crypto` | `^3.0.3` | 提供基本的哈希支持。 | #VI. Security |
| `image` | `^4.2.0` | 纯 Dart 图片处理（缩放、WebP 转换、Secure Wipe）。 | #I. Privacy |
| `image_picker` | `^1.1.2` | 系统相册与相机接入。 | #III. Digitization |
| `path_provider` | `^2.1.3` | 获取应用私有沙盒目录。 | #I. Privacy |
| `uuid` | `^4.4.0` | 生成本地唯一的实体 ID。 | - |

## Developer Dependencies

| Package | Version | Purpose |
| :--- | :--- | :--- |
| `freezed` | `^2.5.2` | 类型安全的领域实体与 JSON 序列化。 |
| `freezed_annotation` | `^2.4.1` | Freezed 必选注解。 |
| `build_runner` | `^2.4.11` | 代码生成工具。 |
| `json_annotation` | `^4.9.0` | JSON 序列化注解。 |
| `json_serializable` | `^6.8.0` | JSON 序列化生成。 |
| `flutter_lints` | `^4.0.0` | 代码质量强制规范。 | #VII. Coding |

---
**Verification**: All packages are selected for offline-friendliness and no tracking telemetry.
