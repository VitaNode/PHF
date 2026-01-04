# Implementation Plan: Phase 1 - Architecture & MVP Loop

**Branch**: `feat/phase1-baseline` | **Date**: 2025-12-28
**Spec**: [.specify/spec.md](file:///Users/lanzf/Projects/PHF/.specify/spec.md)

---

## 1. Summary
本计划旨在构建 PaperHealth 的核心基础设施与 MVP 闭环。重点落实 **“Security First”** 策略，通过 SQLCipher 和 AES-256-GCM 确保医疗数据的绝对隐私。我们将按照分层架构，从底层安全基础设施逐步向上构建，直至实现完整的拍照录入并展示在 Timeline 的核心流程。

---

## 2. Constitution Check

*GATE: Must pass before implementation.*

- [x] **I. 隐私与安全 (Privacy & Security)**: 应用核心功能完全离线，不产生网络请求。所有图片和数据库均采用 256 位加密存储。
- [x] **II. 本地优先 (Local-First)**: 所有数据处理（压缩、加密）均在设备端执行。
- [x] **III. 智能数字化 (Intelligent Digitization)**: Phase 1 实现了“拍照 -> 结构化存储”的基础数字化能力，并预留了 OCR 接口。
- [x] **IV. 架构规范 (MVVM)**: 明确划分 UI (View)、Logic (Riverpod)、Data (Repository) 层次。

---

## 3. Implementation Phases & Tasks

### 3.1: Infrastructure & Security (基础设施层)
**Goal**: 建立全应用的安全信任根基。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T1.1** | **集成本地主密钥与 User Salt 管理** | 使用 `flutter_secure_storage` 在安全区域存储 Master Key。DoD: 重启应用后，能从 KeyStore 正确读取到首次启动时生成的同一个 Key。 | - |
| **T1.2** | **SQLCipher 加密数据库初始化** | 成功打开加密 DB，执行元数据写入测试，外部查看器无法读取数据。 | T1.1 |
| **T1.3** | **AES-256-GCM Core 工具类** | 纯加解密算法逻辑。验证对 `Uint8List` 的处理正确性（含 AAD 支持）。单元测试覆盖。 | T1.1 |
| **T1.4** | **File Security Wrapper (IV & Stream)** | 负责 IV 的头部预置/提取、大文件流式加密及内存水位控制。DoD: 验证同一 Key 下连续两次加密的文件密文不同。 | T1.3 |
| **T1.5** | **安全设置引导 (Security Setup UI)** | 实现首次启动时的 Pin/Biometric 录入界面及逻辑。DoD: 验证未设置锁时无法跳过，设置后写入 app_meta。 | T1.1 |
| **T1.6** | **目录管理与沙盒隔离** | 确保加密资源存储在应用私有沙盒目录下，文件权限正确。 | - |

### 3.2: Data & Persistence (数据访问层)
**Goal**: 建立结构化数据模型与持久化方案。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T2.1** | **Database Schema 部署** | 按照 `spec.md` 创建 `records`, `images`, `tags` 等全部表结构。 | T1.2 |
| **T2.2** | **Repository 模式实现** | 实现 `RecordRepository` 和 `ImageRepository`。核心逻辑：更新 `image_tags` 时需自动同步更新 `records.tags_cache` 以供展示。 | T2.1, T1.4 |
| **T2.3** | **种子数据初始化 (Seed Data)** | 应用首次启动时自动创建默认用户（"本人"）并插入定义的 4 个内置标签。DoD: 验证 `persons` 表中存在 `id='def_me'` 的且 `is_default=1` 的记录。 | T2.1 |

### 3.3: Business Logic & Utilities (业务逻辑层)
**Goal**: 实现图片处理引擎与业务状态管理。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T3.1** | **图片处理引擎与清理机制 (Optimizer & Cleaner)** | 实现 WebP 压缩、缩略图生成以及**临时文件即时彻底删除**（Secure Wipe）逻辑。 | T1.6 |
| **T3.2** | **Riverpod 状态管理搭建** | 创建 `TimelineNotifier` (首页列表状态) 和 `IngestionNotifier` (录入流程状态)。 | T2.2 |
| **T3.3** | **文件流式加密适配** | 处理大尺寸图片。DoD: 在 512MB 限制的模拟器中，连续加密写入 5 张 10MB 以上的大图，应用不崩溃且内存波动平稳。 | T1.4, T3.1 |
| **T3.4** | **存取权与相册集成 (Media Access)** | 集成 `image_picker` 并处理跨平台权限（尤其是 iOS `NSPhotoLibraryUsageDescription`）。 | - |

### 3.4: UI Development (界面展示层)
**Goal**: 实现宪章风格的 UI Kit 与核心交互路径。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T4.1** | **UI Kit 核心组件开发** | 实现 `ActiveButton`, `MonospacedText`, `SecurityIndicator`, `EventCard`, `TopBar`, `MainFab`。 | - |
| **T4.2** | **录入闭环 UI (Camera/Gallery -> Edit -> Save)** | 用户可通过相机录入或从相册批量选择图片，支持预览缩略图、填写医院并保存。 | T3.2, T4.1, T2.3, T3.4 |
| **T4.3** | **首页 Timeline 与 详情页展示** | 首页按日期分组展示卡片，详情页点击可大图浏览（解密后展示）。 | T4.2 |

---

## Phase 2: On-Device OCR & Intelligent Ingestion (智能录入与识别)
**Goal**: 实现 100% 离线 OCR、异步处理队列及智能元数据提取。

### 2.1: Infrastructure & Schema (基础设施与数据层)
**Goal**: 升级数据库模型以支持任务队列与全文检索。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T2.1.1** | **Schema Update & Migration** | 1. `records` 表新增 status 字段。<br>2. `images` 表新增 OCR 相关字段。<br>3. 新增 `ocr_queue` 表。<br>4. 验证旧版本数据迁移无损。 | Phase 1 |
| **T2.1.2** | **FTS5 Search Index Setup** | 1. 创建 `ocr_search_index` 虚拟表。<br>2. 验证 FTS5 插件在 SQLCipher 下可用。<br>3. 实现基本的 Match 查询测试。 | T2.1.1 |
| **T2.1.3** | **Queue & OCR Repository** | 实现 `OCRQueueRepository` (CRUD) 和 `OCRResult` 实体模型。DoD: 单元测试覆盖队列的入队、出队、状态更新。 | T2.1.1 |

### 2.2: OCR Engine Integration (OCR 引擎集成)
**Goal**: 集成双平台原生 OCR 引擎，确保离线与隐私。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T2.2.1** | **OCR Service Interface (Facade)** | 定义 `IOCRService` 抽象接口及统一的返回结构 `OCRResult` (Text, Blocks, Confidence)。 | - |
| **T2.2.2** | **Android OCR Impl (ML Kit)** | 集成 `google_mlkit_text_recognition`。<br>DoD: Android 真机/模拟器断网环境下，能准确识别测试图片文字。 | T2.2.1 |
| **T2.2.3** | **iOS OCR Impl (Apple Vision)** | 集成 Apple Vision Framework (通过插件或 Native Channel)。<br>DoD: iOS 真机断网环境下，能准确识别测试图片文字，且不产生网络请求。 | T2.2.1 |

### 2.3: Business Logic & Processing (业务逻辑层)
**Goal**: 实现智能提取算法与后台任务调度。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T2.3.1** | **Intelligent Extraction Strategy** | 实现日期 (Regex) 和医院名称 (Keyword/Regex) 提取算法。<br>DoD: 针对 50 张样本图片的单元测试，提取准确率达标，置信度计算逻辑符合 Spec。 | T2.2.1 |
| **T2.3.2** | **OCR Processor & Manager** | 协调 `Queue` -> `OCRService` -> `Extraction` -> `DB Update` 的核心逻辑。<br>DoD: 模拟入队任务，能自动顺序执行并更新数据库状态。 | T2.1.3, T2.3.1, T2.2.2/3 |
| **T2.3.3** | **Background Task Scheduling** | 集成 `workmanager` (Android) / `BGTask` (iOS)。<br>DoD: 应用退后台 5 分钟后，队列中的待处理任务仍能被调度执行（或下次启动自动恢复）。 | T2.3.2 |

### 2.4: UI Adaptation (界面交互层)
**Goal**: 构建“待确认”闭环与检索体验。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T2.4.1** | **Pending Review Banner (Home)** | 首页 Timeline 顶部增加“待确认”入口状态感知。<br>DoD: 当有 `status='review'` 记录时显示入口，数量角标准确。 | T2.1.1 |
| **T2.4.2** | **Review Queue List & Edit UI** | 实现“待确认”列表页及专用编辑页（高亮 OCR 结果 vs 现有数据）。<br>DoD: 用户修正数据并保存后，记录状态变为 `archived` 并从列表消失。 | T2.4.1 |
| **T2.4.3** | **Detail View OCR Enhancement** | 详情页支持查看/展开 OCR 识别全文。<br>DoD: 点击图片或“查看文字”按钮，能展示对应的解密后 OCR 文本。 | Phase 1 Detail View |
| **T2.4.4** | **Global Search UI** | 实现基于 FTS5 的全文搜索界面。<br>DoD: 输入关键词能毫秒级返回包含该词的病历记录。 | T2.1.2 |

---

## Phase 3: Profile Governance & Tag Ecosystem (档案治理与标签生态)
**Goal**: 实现多档案管理、标签全生命周期维护及离线加密备份，确保应用具备上架水准。

### 3.1: Infrastructure & Data Layer (基础设施与数据层)
**Goal**: 扩展 Schema 以支持配色与排序，建立备份引擎。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T3.1.1** | **Schema Migration (Profiles & Tags)** | 1. `persons` 表新增 `profile_color` 字段。<br>2. `tags` 表完善 `order_index` 与 `person_id` 支持。<br>DoD: 数据库版本升级无损，新字段读取正常。 | Phase 2 |
| **T3.1.2** | **Backup Engine foundation** | 研究并实现基于 ZIP 的存档逻辑，初步验证对加密 DB 和图片的打包能力。 | T1.4 |

### 3.2: Data & Persistence (数据访问层)
**Goal**: 实现档案与标签的 Repository 完整操作。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T3.2.1** | **PersonRepository Impl** | 实现人员的 CRUD。核心：删除人员时需调用 `SecureWipeHelper` 物理级联删除图片。 | T3.1.1 |
| **T3.2.2** | **Enhanced TagRepository** | 实现动态标签 CRUD。DoD: 验证删除标签后，`image_tags` 关联关系自动解除，但不删除物理图片。 | T3.1.1 |

### 3.3: Business Logic & Services (业务逻辑层)
**Goal**: 实现多档案隔离逻辑与加密备份服务。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T3.3.1** | **Multi-profile Isolation Logic** | 在 Riverpod 层实现全局 `currentPersonId`。所有数据查询 Repository 默认带上所属人过滤。 | T3.2.1 |
| **T3.3.2** | **Offline Backup/Restore Service** | 实现生成 `.phf` 加密包及识别恢复逻辑。DoD: 导出的文件可在另一台模拟器上完整恢复（含图片和 FTS 索引）。 | T3.1.2, T3.2.1/2 |

### 3.4: UI & Store Readiness (界面展示与上架准备)
**Goal**: 提供完整的设置管理功能，完成合规性资产准备。

| ID | Task | DoD (验收标准) | Dependencies |
| :--- | :--- | :--- | :--- |
| **T3.4.1** | **Profile Switching & Management UI** | 首页顶部切换入口 + 人员管理页（配色选择）。DoD: 切换成员后 Timeline 刷新对应数据。 | T3.3.1 |
| **T3.4.2** | **Tag Library Management UI** | 设置页 -> 标签库。支持新增标签、修改颜色、长按拖拽排序。 | T3.2.2 |
| **T3.4.3** | **Backup & Restore UI** | 导出/导入操作界面，支持系统分享对话框调用。 | T3.3.2 |
| **T3.4.4** | **Store Compliance & Assets** | 1. 静态 Markdown 隐私政策页面。<br>2. App Icon & Splash Screen。DoD: 运行 `flutter build` 无 Asset 缺失。 | - |
