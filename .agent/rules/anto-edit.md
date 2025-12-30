---
trigger: always_on
---

# Antigravity Behavior Rules

1. **Task Progress Source of Truth**: The file `tasks.md` is the definitive source for project progress. Assume all predecessor tasks in a sequence (e.g., T1-T9 before T10) are completed.
2. **Document Writing Method**: To avoid the editor's "Accept" UI, use `run_command` (e.g., `cat > file <<EOF`) to write documentation, artifacts, and review logs.
3. **Review Status Tracking**: Maintain and update `docs/review/status.md` after every task review. Track "Approved Features", "Pending Issues", and "Technical Debt".
4. **Dart Version & Syntax**: Target Dart 3.10 syntax (matching Flutter 3.38.5).
