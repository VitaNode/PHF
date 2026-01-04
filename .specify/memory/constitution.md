<!--
SYNC IMPACT REPORT
- Version: 1.4.2 → 1.4.3
- Rationale: Added mandatory Task ID prefixing for all files in the `docs/` directory to ensure traceability between implementation tasks and documentation artifacts.
- Modified Sections:
  - #### 11. 代码提交与文档协作 (Code Commits & Documentation): Added "Documentation Naming" rule.
- Templates Updated:
  - ✅ .specify/templates/plan-template.md: Updated Constitution Check to include new principles
  - ✅ .specify/templates/tasks-template.md: Updated to reflect new principles
- TODOs:
  - TODO(RATIFICATION_DATE): 初始批准日待定
-->
# PaperHealth 章程

## 核心原则

### I. 绝对的隐私与安全 (Absolute Privacy & Security)
- **规则**:
  - 应用核心功能不得发起任何网络请求，确保数据100%留存在用户设备上。
  - 数据库必须使用 SQLCipher 进行整库加密。
  - 所有文件（如图片、附件）在写入存储前，必须使用 AES-256 算法进行独立加密。
  - 图片、扫描件等所有文件附件必须存储在应用私有沙盒目录中，防止其他应用或用户直接访问。
  - 应用必须提供启动安全锁（如生物识别或密码），作为防止未授权访问的第一道防线。
- **理念**: 用户的医疗数据是其最敏感的个人信息。我们承诺提供银行级别的安全保障，将数据控制权完全且唯一地交还给用户本人。

### II. 本地优先架构 (Local-First Architecture)
- **规则**:
  - 应用的所有核心功能，包括数据创建、读取、更新、删除和处理，都必须能在完全离线的环境下无缝运行。
  - 禁止将核心业务逻辑或用户数据处理委托给任何外部或云端服务。
  - 所有计算密集型任务，如 OCR 识别、数据分析等，必须利用设备自身的算力完成。
- **理念**: 摆脱对网络的依赖，不仅是保障隐私的手段，更是确保应用在任何时间、任何地点都稳定可靠的关键。用户体验不应因网络状况而打折扣。

### III. 智能数字化与归档 (Intelligent Digitization & Archiving)
- **规则**:
  - **第一阶段**: 应用需提供基础的数字化能力，允许用户通过拍照将纸质资料作为图片存入应用。
  - **第二阶段**: 应用需集成设备端 OCR 能力，将图片中的文本信息转化为可搜索、可编辑的数字记录。
  - 用户单次操作提交的所有图片被定义为一个“就诊单元”，并分配一个全局唯一的 `event_id`。
  - 初期版本中，所有记录归档至当前用户的档案下。系统设计应为未来的多用户支持做好准备。
- **理念**: 我们不仅仅是存储信息，更是将无序的纸质资料转化为有序、可用、有价值的个人健康档案，让用户能轻松地管理和理解自己的健康历程。

### IV. Security & Privacy (Safety Standards)
- **数据脱敏**：严禁在日志（Logs）或错误提示中包含任何用户身份信息（PII），如姓名、身份证号、医疗诊断结果等。
- **OCR 临时文件**：图片在 OCR 识别完成后，必须立即从临时缓存中彻底删除。
- **内存安全**：处理敏感字符串（如解密后的医疗记录）后，应尽快手动释放或覆盖内存变量（如果语言支持）。
- **零信任原则**：假设所有外部 API 都是不可信的，所有从 OCR 引擎返回的数据必须经过严格的格式校验和清洗。
- **合规性**：代码实现必须遵循数据保护原则（如参考 HIPAA 或等保三级要求），严禁将敏感数据备份至不可信的云端（如 iCloud/Google Drive 的非加密备份区）。

## 技术栈与架构原则 (Technology Stack & Architectural Principles)

### 技术栈 (Technology Stack)

- **应用框架 (Application Framework)**: Flutter
- **UI 组件库 (UI Component Library)**: Flutter 内置组件库 + 自定义 Design System
- **日志工具 (Logging Tool)**: logger 包
- **数据库 (Database)**: SQLite + SQLCipher
- **文件加密 (File Encryption)**: AES-256 算法，大文件需采用流式加密 (Streaming)或提前压缩图片 以避免内存溢出 (OOM)
- **设备端OCR (On-Device OCR)**: iOS 平台使用 Vision 框架，Android 平台使用 ML Kit，须确保 OCR 模型随应用打包或首次启动即完成下载，以保证后续完全离线可用
- **状态管理 (State Management)**: Riverpod
- **依赖注入 (Dependency Injection)**: get_it
- **JSON 序列化 (JSON Serialization)**: json_serializable
- **路由管理 (Navigation & Routing)**: AutoRoute
- **国际化 (Internationalization)**: flutter_localizations

### 架构原则 (Architectural Principles)

#### 1. 本地优先架构 (Local-First Architecture)
- **原则**: 所有核心功能必须在完全离线环境下正常运行
- **实现**:
  - 采用嵌入式数据库 (SQLite/SQLCipher) 存储所有数据
  - 设备端处理所有计算密集型任务 (OCR、数据处理)
  - 避免任何形式的网络请求用于核心功能
  - 确保在网络不稳定或无网络环境下应用依然可用

#### 2. 架构模式 (Architecture Pattern)
- **原则**: 采用 **MVVM** (Model-View-ViewModel) 模式结合 **清洁架构 (Clean Architecture)** 的分层思想，确保关注点分离、可维护性和可测试性。
- **实现**:
  - **表现层 (Presentation Layer / View)**: Flutter UI 组件，专注于界面展示和用户交互。
  - **逻辑层 (Logic Layer / ViewModel)**: 使用 **Riverpod** 管理应用状态和业务逻辑，作为 View 与数据的桥梁。
  - **数据层 (Data Layer)**:
    - **Model**: 由于本地优先，数据模型贯穿各层，定义核心业务实体。
    - **Repository**: 统一数据访问接口，屏蔽底层实现细节。
    - **Data Source**: 具体的本地数据库 (SQLite+SQLCipher) 和文件系统访问。

#### 3. 隐私优先设计 (Privacy-First Design)
- **原则**: 隐私保护是系统设计的核心约束
- **实现**:
  - 数据加密存储 (SQLCipher + AES-256)
  - 应用沙盒机制，文件存储在私有目录
  - 无网络请求，数据不离开用户设备
  - 安全访问控制 (生物识别/密码锁)

#### 4. 响应式编程 (Reactive Programming)
- **原则**: 采用响应式编程模式，提升用户体验和代码可维护性
- **实现**:
  - Riverpod 状态管理，实现数据流的响应式更新
  - Stream 和 Future 的合理使用，处理异步操作
  - 组件间松耦合，通过状态变化驱动界面更新

#### 5. 测试驱动开发 (Test-Driven Development)
- **原则**: 代码质量通过全面的测试保障
- **实现**:
  - 单元测试覆盖业务逻辑层
  - 集成测试验证模块间协作
  - UI 测试确保用户交互正确性
  - 核心业务逻辑代码覆盖率目标不低于 80%

#### 6. UI/UX 准则 (UI/UX Guidelines)
- **原则**: **简洁、专业、数据驱动。** 消除所有不必要的视觉噪音，让用户将注意力集中在 OCR 结果和档案内容上。
- **实现**:
  - **色彩规范**:
    - **主色调**：深青色 (Teal) (e.g.,` #008080`)，配以辅助的**警戒色** (如橙色` #FF9900` 用于低置信度提示) 和成功色 (如绿色` #4CAF50 `用于保存成功)。
    - **字体**：严格采用等宽字体 (Monospace Font)，如 Inconsolata 或 Fira Code，以确保医疗数值对齐可读性。
    - **Background**: #FFFFFF (白色，用于背景) / #F2F2F7 (浅灰，用于次要背景)
    - **卡片/背景**：使用较大的圆角（统一 **12px**）来增加亲和力，同时保持专业感。
    - **按钮/输入框**：使用中等圆角（统一 **8px**），强调可点击性。
  - **无障碍要求**: 所有交互元素必须符合 WCAG 2.1 AA 标准，且具备足够的点击热区 (最小 44x44 像素)
  - **动画风格**: 使用线性或淡入淡出的简洁过渡，避免过度浮夸的动画

#### 7. 编码规范 (Coding Standards)
- **原则**: 确保代码质量、一致性和可维护性
- **实现**:
  - **文件组织**: 使用按功能模块划分的文件结构 (Feature-based folder structure)
  - **命名约定**: 组件名使用 PascalCase，函数名使用 camelCase，常量使用 UPPER_SNAKE_CASE
  - **类型安全**: 强制要求所有变量和函数必须定义 Dart 类型 (Type)，禁止使用 dynamic
  - **注释要求**: 仅在逻辑复杂处添加注释，优先通过语义化命名实现代码自解释

#### 8. AI 交互规则 (AI Interaction Rules)
- **原则**: 确保高效、安全的 AI 辅助开发过程
- **实现**:
  - **简洁性**: 直接输出代码或方案，除非被询问，否则不要进行过多的礼貌性寒暄
  - **安全性**: 在处理敏感信息（如 API Key）时，必须提醒用户使用环境变量
  - **纠错机制**: 如果你发现之前的方案有误，请直接承认并提供修正后的最优解

#### 9. 错误处理与日志规范 (Error Handling & Logging)
- **原则**: 确保应用的健壮性和可维护性，提供清晰的错误信息和日志记录
- **实现**:
  - **异步操作**: 所有异步操作必须使用 try-catch 块进行错误处理
  - **日志记录**: 严禁在生产代码中使用 print() 或 debugPrint()，必须使用项目统一的 logger 工具
  - **用户提示**: 用户侧错误必须通过 Toast 或 SnackBar 友好提示，禁止直接显示原始 Error Stack
  - **崩溃分析**: 鉴于无网络请求，需提供安全的本地日志导出功能（如加密导出），以便用户主动分享以排查问题

#### 10. 性能与资源管理 (Performance & Resource Management)
- **原则**: 优化应用性能，确保流畅的用户体验和高效的资源利用
- **实现**:
  - **列表渲染**: 长列表渲染必须使用 ListView.builder 或类似虚拟列表组件
  - **图片处理**: 所有图片必须指定占位图和错误图，优化加载体验
  - **计算优化**: 对于昂贵的计算，使用 Memoization 技术进行缓存优化

#### 11. 代码提交与文档协作 (Code Commits & Documentation)
- **原则**: 规范代码提交和协作流程，确保代码历史清晰可追溯
- **实现**:
  - **提交规范**: 遵循 Conventional Commits 规范，格式为 `<type>(<scope>): <description>`
  - **文档更新**: 每次修改代码后，更新相关的文档说明，文档统一放在 `docs/` 目录下。
  - **文档命名**: 存放在 `docs/` 目录下的所有文件必须包含关联的任务 ID，遵循 `T[ID]_描述` (知识库) 或 `review_T[ID]_描述` (审查报告) 的命名约定，例如 `T0_DEPENDENCIES.md` 或 `review_T2_entities.md`。
  - **分支管理**: 按照功能分支开发，通过 Pull Request 进行代码审查。

#### 12. 模块边界与禁止清单 (Negative Constraints / Anti-Patterns)
- **原则**: 避免常见的代码问题，确保架构的清晰和可维护性
- **实现**:
  - **禁止硬编码**: 严禁在业务代码中直接硬编码 API URL、颜色值或文本字符串，必须引用 constants 或 i18n 文件
  - **禁止循环依赖**: 严禁在 utils 层级引用 components 层级的代码，保持依赖方向的单向性
  - **禁止过度封装**: 除非某个逻辑在三个以上的地方重复使用，否则不要过早进行抽象封装

#### 13. 测试要求 (Testing Standards)
- **原则**: 保证代码质量，通过全面的测试确保功能的正确性和稳定性
- **实现**:
  - **单元测试**: 为每个新创建的 Utility 函数编写单元测试（Unit Test）
  - **覆盖率**: 核心业务逻辑必须达到 80% 以上的测试覆盖率
  - **测试类型**: 包括单元测试、集成测试和 UI 测试，确保不同层面的质量

#### 14. 本地预检与 CI 自动化 (Pre-flight Checks & CI Automation)
- **原则**: Agent 在推送代码前必须确保代码质量，并对 CI 反馈负责。
- **实现**:
  - **强制本地预检**: 在执行 `git push` 前，Agent 必须自主按序完成以下步骤：
    1. `dart run build_runner build --delete-conflicting-outputs` (若修改了含有注解的 Model/Entity)。
    2. `dart format .` (确保格式符合工程规范)。
    3. `flutter analyze` (确保零警告、零错误)。
    4. `flutter test` (至少运行与当前改动相关的测试用例，确保无回归问题)。
  - **CI 闭环责任**:
    - 如果收到来自 GitHub Actions 的报错评论（PR Comment），Agent 必须立即根据评论中的日志和堆栈信息进行修正。
    - 持续修正并推送，直到评论消失或 CI 状态变为绿色。
    - 禁止在 CI 失败的情况下尝试合并代码。

## 治理
所有开发活动和功能变更都必须严格遵守本章程定义的原则。任何偏离核心原则的修改都需要经过正式的章程修订流程。

**版本**: 1.4.3 | **批准于**: TODO(RATIFICATION_DATE): 初始批准日待定 | **最后修订于**: 2025-12-29