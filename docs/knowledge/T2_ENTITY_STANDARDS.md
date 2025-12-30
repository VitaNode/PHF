# ENTITY_STANDARDS.md - Domain Model Guidelines

本文记录了 PaperHealth (PHF) 项目中领域实体模型 (Domain Entities) 的设计与实现标准，确保数据层的一致性与安全性。

## 1. 唯一标识策略 (ID Strategy)

- **标准**: 使用 **UUID v4**。
- **理由**: 
  - 支持完全离线的 ID 生成，无需等待数据库自增。
  - 避免 ID 碰撞，便于未来可能的跨设备数据同步。
  - 不可预测性增加了一定的安全性。
- **代码实现**: 使用 `uuid` 库生成，并在 `Repository` 层或 `Entity` 实例化时分配。

## 2. 序列化规范 (Serialization)

- **框架**: 使用 `freezed` 配合 `json_serializable`。
- **约定**:
  - **空安全**: 所有非必填字段必须标记为 `?`。
  - **默认值**: 状态码、枚举、布尔值应通过 `@Default()` 设置。
  - **时间处理**: 使用 `DateTime` 类型，序列化时遵循 ISO-8601 标准。
  - **忽略字段**: 内存聚合字段（如 `tags`, `images`）必须使用 `@JsonKey(includeFromJson: false, includeToJson: false)` 显式排除，避免污染数据库序列化流。

## 3. 安全与隐私约束 (Security Constraints)

- **敏感信息**: 
  - `MedicalImage` 的 `encryptionKey` 必须以加密字符串（如 Base64）形式存储。
  - **IV (Initialization Vector)**：根据 `spec.md`，IV **禁止** 存储在数据库实体中，必须预置在物理加密文件的头部。
- **命名规范**: 遵循 Dart 驼峰命名法 (`camelCase`)。

## 4. 枚举处理

- 使用 `@JsonValue` 明确序列化后的字符串值，确保数据库存储的是可读且稳定的标识符（如 `archived`, `deleted`）。

---
*Last Updated: 2025-12-29*
