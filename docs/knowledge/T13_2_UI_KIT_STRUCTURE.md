# T13.2 UI Kit Structure: 导航与全局组件

## 概述
本任务实现了应用结构层级的核心通用组件：`CustomTopBar` 和 `MainFab`。这些组件遵循 `Constitution.md` 中的 UI/UX 准则，并集成了安全状态展示。

## 核心组件

### 1. CustomTopBar (`custom_top_bar.dart`)
统一定制的顶部导航栏，作为应用每个页面的入口标配。

- **功能**:
  - 支持动态标题。
  - 内置符合 iOS 风格的返回按钮 (`arrow_back_ios_new`)。
  - **安全集成**: 右侧强制或半强制显示 `SecurityIndicator`，向用户明示当前页面处于“AES-256 加密保护”状态。
- **视觉准则**:
  - 背景色：`AppTheme.bgWhite`
  - 底部边框：1px 浅灰色 (`0xFFE5E5EA`)，增强层级感。
  - 字体：`Inconsolata` (Monospace)。

### 2. MainFab (`main_fab.dart`)
主悬浮操作按钮，通常用于触发“病历录入”这一核心流程。

- **设计细节**:
  - 颜色：`AppTheme.primaryTeal`。
  - 圆角：16px (RoundedRectangleBorder)，平衡了 Material 3 的现代感与项目专业感。
  - **扩展支持**: 支持 `label` 参数，可自动切换为 `FloatingActionButton.extended` 模式。
- **交互**:
  - 抬升高度 (Elevation)：6 (静止) / 2 (点击)。

## 安全性保障
- **零硬编码**: 所有颜色、间距和字体均引用 `AppTheme` 类，确保 UI 一致性且易于全局调整。
- **隐私增强**: 通过在 TopBar 显眼位置展示安全状态，从心理层面加强用户对“数据不离机”原则的感知。

## 使用示例
```dart
Scaffold(
  appBar: const CustomTopBar(
    title: '我的健康档案',
    showBack: false,
  ),
  floatingActionButton: MainFab(
    onPressed: () => _handleIngestion(),
    label: '录入新病历',
  ),
  body: ...,
);
```
