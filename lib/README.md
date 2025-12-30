# lib/ - PaperHealth PHF Architecture

本项目遵循 **Clean Architecture + MVVM** 架构模式，结合 **Riverpod** 进行状态管理与依赖注入。

## 目录结构及其职责

| 路径 | 职责 | 依赖限制 |
| :--- | :--- | :--- |
| `core/` | 跨层通用的核心逻辑：安全加密 (security)、数据库驱动 (database)、存储路径管理 (storage)。 | **禁止** 依赖 `data/`, `logic/` 或 `presentation/`。 |
| `data/` | 数据落地的具体实现：模型定义 (models)、存储仓库 (repositories)。 | 只能依赖 `core/`。**禁止** 依赖 `logic/` 或 `presentation/`。 |
| `logic/` | 业务逻辑与应用状态：Riverpod Providers (providers)、业务服务 (services)。 | 依赖 `data/` 和 `core/`。**禁止** 依赖 `presentation/`。 |
| `presentation/` | 用户界面展示：UI Kit 组件 (components)、功能页面 (pages)。 | 依赖 `logic/` 驱动界面。**禁止** 包含持久化逻辑。 |

## 模块可见性原则 (Ref: Constitution#II)
1.  **物理隔离**：每一层应尽可能保持独立，通过接口（Interfaces）进行通信。
2.  **单向依赖**：依赖关系只能由上至下（Presentation -> Logic -> Data -> Core）。
3.  **安全性**：加解密逻辑映射在 `core/security` 内部，任何解密后的数据严禁作为成员变量持久存在于 `data` 层之外。

---
*Created by Antigravity (Guardian)*
