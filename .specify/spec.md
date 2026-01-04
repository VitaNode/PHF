# Baseline Specification: Core Architecture & MVP Loop (Phase 1)

**Status**: Finalized  
**Scope**: Phase 1 - Architecture & MVP Loop  
**Primary Strategy**: Security First | Schema First | UI Kit First

---

## 1. Product Goals
PaperHealth (PHF) 旨在通过 **100% 本地运行** 的方式，为用户提供一个绝对隐私、高安全性的纸质医疗文档数字化管理工具。
- **隐私性**: 数据永不离机。
- **可用性**: 摆脱对医院或云端系统的依赖，用户拥有完整的数据控制权。
- **数字化**: 将杂乱的纸质病历转化为结构化、可搜索、可追溯的数字档案。

---

## 2. User Flows

### A. 录入流程 (Ingestion Loop) - Priority: P1
1.  **Entry**: 用户在首页点击“+ 拍照”或“导入”按钮。
2.  **Capture / Select**: 
    - **相机**: 调起原生相机，支持单张或连拍。
    - **相册**: 从系统相册选择多张图片进行导入。
3.  **Process**: 
    - 自动压缩图片以减少空间占用。
    - 生成随机 AES-256 密钥（或使用派生自 Master Key 的密钥）。
    - 将加密后的字节流写入应用私有目录。
4.  **Preview & Edit**: 
    - 用户进入预览页，可进行裁剪、旋转或删除操作。
    - 对预览图进行实时解密显示。
5.  **Metadata Entry**: 
    - 用户为本次录入的 **图片** 批量或逐一设置标签。
    - 手工录入就诊层级的元数据：**医院名称**、**就诊日期**。
6.  **Save**: 点击保存。
    - 标签关系写入 `image_tags` 表。
    - 系统自动提取该记录下所有图片的标签集合，去重后更新到 `records.tags_cache`。
7.  **Exit**: 应用返回首页，首页 Timeline 立即反映新增加的就诊记录（以卡片形式展示）。

---

# Phase 2 Specification: On-Device OCR & Intelligent Ingestion

**Status**: Finalized  
**Strategy**: Local OCR | Queue Management | Confidence-based Flow

## 1. Product Goals (Phase 2)
实现 100% 离线 OCR 识别流，包括 Android/iOS 差异化引擎集成、异步处理队列、智能数据提取、以及全文搜索。
- **自动化元数据提取**: 利用本地 OCR 自动识别就诊日期、医院名称。
- **内容搜索化**: 实现全文索引 (FTS5)，支持按病历内容检索。
- **容错与闭环**: 引入“待确认”机制，确保低置信度数据的人工校验。

---

# Phase 3 Specification: Profile Governance & Tag Ecosystem

**Status**: Draft (Current)  
**Strategy**: Multi-user Management | Tag CRUD | Store Readiness

## 1. Product Goals (Phase 3)
实现多档案治理与标签生态系统，完成上架商店前的合规性与数据便携性准备。
- **多档案支持**: 支持家庭成员（本人、父母、孩子）档案创建与隔离。
- **标签全生命周期**: 实现标签的自定义 CRUD（增、删、改、查、配色）。
- **离线数据保障**: 提供离线加密备份与恢复机制（.phf 格式包）。
- **上架准入**: 补充本地隐私政策、App 资源优化、符合审核要求的安全合规声明。

## 2. User Flows (Phase 3)

### A. 成员档案管理 (Profile Management)
1.  **快速切换**: 首页点击顶部 Profile 区域，通过 BottomSheet 快速在不同成员间切换。
2.  **档案编辑**: 
    - **添加**: 输入昵称（如“父亲”）、选择档案配色。
    - **排序/删除**: 管理成员列表，删除成员时执行物理级联擦除。
3.  **录入定向**: 录入新病历时，自动关联当前活动成员，亦可手动重新分配。

### B. 标签库维护 (Tag Ecosystem CRUD)
1.  **全局管理**: 设置 -> 标签库管理。
2.  **交互**: 
    - 点击“+”新增标签，选择颜色 Hex。
    - 点击已有标签进入编辑模式（重命名/改色）。
    - 长按或点击删除图标进行清理。
3.  **应用映射**: 标签的变更实时反映在 Timeline 过滤和录入页的选择器中。

### C. 离线备份与迁移 (Encrypted Backup)
1.  **导出**: 设置 -> 离线加密备份。系统打包数据库加密快照与加密图片，调用系统分享（AirDrop/WeChat/Files）。
2.  **恢复**: 首页/设置 -> 导入备份。选择备份文件，完成完整性校验后恢复。

## 3. Functional Requirements

### FR-301: 多人员管理体系
- **Isolation**: Timeline 默认仅展示当前选中成员的记录。
- **Defaulting**: 首次安装默认创建“本人”档案且不可删除。
- **Consistency**: 成员颜色需在卡片边框或头像处体现，增加视觉区分度。

### FR-302: 标签系统升级
- **Dynamic CRUD**: 移除 Phase 1 的静态标签限制，支持数据库动态增删。
- **Validation**: 标签名不能为空，长度限制 10 字符，且在当前成员/全局范围内唯一。

### FR-303: 离线加密备份机制
- **Format**: 自定义 `.phf` (PaperHealth File) 格式，本质为 AES-256 加密的二进制流或加密 ZIP。
- **Requirement**: 备份必须包含完整的 FTS5 索引、记录元数据以及所有关联的加密图片。

### FR-304: 上架合规准备 (Store Readiness)
- **Privacy Page**: 应用内必须包含一个静态渲染的隐私政策页面，明确说明“无网络通信”、“数据全本地”。
- **Asset Compliance**: 适配多尺寸 App Icon，增加 Splash Screen 减少启动白屏感。

## 4. Data Schema (Phase 3 Updates)

### 4.1 tags 表增强
- 启用 `order_index` 支持用户自定义排序。
- 完善 `person_id` 关联，支持成员专属标签（可选，默认支持全局标签）。

### 4.2 persons 表完善
- 增加 `profile_color` 字段，用于 UI 渲染。

## 5. Security Implementation (Phase 3)
- **Backup Verification**: 导入备份时必须进行校验和（Checksum）验证，防止损坏数据损坏数据库。
- **Cascading Wipe**: 删除成员时，必须确保其磁盘上的加密图片文件被 100% 物理擦除。

---

# Roadmap Overview
- **Phase 1**: Core Architecture, Camera/Gallery, AES/SQLCipher (Done)
- **Phase 2**: Offline OCR, SMART Extraction, FTS5 Search (Done)
- **Phase 3**: Multi-Person, Tag CRUD, Encrypted Backup, Store Readiness (Current)
- **Phase 4**: UI/UE Overhaul, Advanced Intelligence, Data Insights (Next)