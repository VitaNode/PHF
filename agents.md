# AI Agent 开发规范 (Agent Development Standards)

为了确保 PaperHealth 项目的代码质量和 CI/CD 流程的稳定性，所有参与开发的 AI Agent 必须严格遵守以下预检与协作规范。

## 1. 强制本地预检 (Mandatory Pre-flight Checks)

在执行 `git push` 推送任何代码改动前，Agent 必须自主按顺序完成以下预检步骤：

1.  **代码生成**: `dart run build_runner build --delete-conflicting-outputs`
    *   *适用场景*: 修改了含有 `@freezed`, `@JsonSerializable`, `@riverpod` 等注解的文件后。
2.  **自动格式化**: `dart format .`
    *   *目的*: 确保代码风格完全符合项目 CI 校验标准，避免因缩进或空格导致的构建失败。
3.  **静态分析**: `flutter analyze`
    *   *要求*: 必须达到 `No issues found!` 状态。严禁带病提交。
4.  **单元测试**: `flutter test`
    *   *要求*: 至少运行与当前改动相关的测试目录。鼓励运行全量测试以确保没有引入回归错误。

## 2. CI 闭环与故障修复 (CI Loop & Recovery)

GitHub Actions 已配置为在检测到错误时自动提取日志并发表 PR 评论。Agent 对其提交的代码负有终身修复责任：

*   **监听反馈**: 提交 PR 后，必须关注 CI 状态。
*   **故障修复**: 如果收到来自 GitHub Actions 的报错评论，Agent 必须立即调用工具读取评论中的堆栈信息（或使用 `gh run view --log-failed`）。
*   **迭代推送**: 根据错误信息重新修正代码，再次执行“本地预检”并推送，直到 CI 通过或评论消失。
*   **严禁强行合并**: 在 CI 状态为红色（Failure）时，禁止执行任何合并操作。

## 3. Git 协作规约 (Git Workflow)

*   **基准分支**: 始终基于最新的 `develop` 分支创建功能分支。
*   **命名规范**: `feat/issue-[ID]` 或 `fix/issue-[ID]`。
*   **PR 自动闭环**: 在 PR 描述中包含 `Closes #[ID]`，确保合并后 Issue 自动关闭。
*   **自动合并**: 推荐在创建 PR 后立即执行 `gh pr merge --auto --squash` 开启自动合并队列。

---
*本规范作为 `.specify/memory/constitution.md` 的重要补充，是 Agent 在本项目中生存与协作的基石。*
