# AI Agent 开发规范 (Agent Development Standards)

为了确保 PaperHealth 项目的代码质量和 CI/CD 流程的稳定性，所有参与开发的 AI Agent 必须严格遵守以下预检与协作规范。

## 1. 强制本地预检 (Mandatory Pre-flight Checks)

在执行 `git push` 前，Agent 必须自主完成“同步”与“预检”流程：

### 同步与变基 (Sync & Rebase)
1.  **获取更新**: `git fetch origin develop`
2.  **变基同步**: `git rebase origin/develop`
    *   *冲突处理*: 如果遇到代码冲突，优先调用 `codebase_investigator` 分析，确保合代码逻辑正确。

### 自动化预检 (Pre-flight Checks)
1.  **代码生成**: `dart run build_runner build --delete-conflicting-outputs`
2.  **自动格式化**: `dart format .`
3.  **静态分析**: `flutter analyze`
4.  **单元测试**: `flutter test`
    *   *注意*: 若环境（如 Jules）暂不支持本地测试，可跳过此步，但必须以 GitHub CI 的结果为准进行修正。

## 2. CI 闭环与故障修复 (CI Loop & Recovery)

Agent 对其提交的代码负有终身修复责任：

*   **监听反馈**: 提交 PR 后，必须关注 CI 状态。
*   **故障修复**: 如果 CI 失败，必须立即读取报错信息进行修正并重新推送。
*   **严禁强行合并**: 在 CI 状态为红色（Failure）时，禁止执行任何合并操作。

---
*本规范作为 `.specify/memory/constitution.md` 的重要补充，是 Agent 在本项目中生存与协作的基石。*