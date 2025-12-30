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


