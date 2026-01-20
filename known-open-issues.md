# Known Open Issues - Ralph-1 Tooling

This document tracks identified issues, potential inconsistencies, and polish items for the Ralph-1 tooling ecosystem.

## Rationale for Deferred Action
We have intentionally deferred fixing these issues for the following reasons:
1. **Ambiguity**: It is unclear if some behaviors (e.g., binary file blocking) are bugs or intentional architectural features.
2. **Quota Optimization**: None of these issues are high-priority or state-blocking. As one of our core goals is to **maximize work scope delivered within a limited LLM token quota**, the tokens saved by deferring these fixes are currently more valuable than the fixes themselves.

---

## 📋 Issue Log

| ID | severity | Issue Description | Component | Notes |
|:---|:---|:---|:---|:---|
| 001 | **Medium** | Inconsistent test-edit policy defaults: `hooks/pre-commit` defaults to `0` while `ralph.sh` defaults to `1`. | `hooks/`, `ralph.sh` | Affects manual commits vs. autonomous loops. |
| 002 | **Medium** | Binary file changes (images, assets) are blocked by default in pre-commit, requiring an override. | `hooks/pre-commit` | May cause friction when adding project assets. |
| 003 | **Low** | Empty `## Your Task` section header. | `prompt.md` | Cosmetic; immediately followed by a P0 section. |
| 004 | **Low** | `$AMP_CURRENT_THREAD_ID` is not included in the `envsubst` variable list. | `ralph.sh`, `prompt.md` | May result in literal string appearing if `amp` doesn't handle expansion. |
| 005 | **Low** | `RALPH_MAX_CHANGED_LINES` and `RALPH_ALLOW_LARGE_DIFF` undocumented in plan. | `TOOLING_SETUP_PLAN.md` | Documentation gap for available configuration knobs. |
| 006 | **None** | `set -o pipefail` interaction with exit status capture. | `ralph.sh` | **Verified Sound**: Capture logic is correct, noted during evaluation as a false positive. |

---
*Last Reviewed: 2026-01-20T11:59:16+05:30*
