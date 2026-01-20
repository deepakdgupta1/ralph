# Tooling Setup Plan for Ralph-1

**Based on resource analysis**: `resource_analysis_progress.md` (P0/P1 adoption items)  
**Objective**: Implement the highest-impact safety + backpressure + continuity tooling for Ralph itself.

## P0: Safety, Backpressure, Stability

### 1) Safety Hooks Suite (`hooks/`)
*Source: `tool-3bb5a470` (claude-code-tools), `wf-eee9a073` (Shipping Real Code)*
- **Deletion protection (TRASH pattern)**: block staged deletions unless under `TRASH/` (`hooks/pre-commit`)
- **Secrets protection**: block `.env*` / key material from being committed (`hooks/pre-commit`)
- **Large diff guard**: block huge diffs by default (`hooks/pre-commit`, `RALPH_MAX_CHANGED_LINES`, `RALPH_ALLOW_LARGE_DIFF`)
- **Humans Write Tests guard**: when enabled, block edits to test files (`hooks/pre-commit`, `RALPH_HUMANS_WRITE_TESTS`)
- **Branch discipline**: block pushes from branches that don’t match `prd.json.branchName` (`hooks/pre-push`)
- **Install script**: symlink hooks into `.git/hooks/` (`hooks/install.sh`)
- **Safe delete helper**: `./hooks/safe-rm …` moves paths into `TRASH/` (no `rm`)

### 2) Workflow Enforcement (DAIC + scope drift)
*Source: `tool-9f8d507e` (cc-sessions)*
- **DAIC + structured output**: `[STATUS]`, `[PLAN]`, `[CHECK]`, `[BLOCKERS]` markers (`prompt.md`)
- **Approval gate**: plan must appear before implementation; supports auto-mode via `RALPH_AUTO_APPROVE` (`prompt.md`)
- **Scope drift rule**: if plan changes materially, re-align before implementing (`prompt.md`)

### 3) “Humans Write Tests” + Never-Touch Boundaries
*Source: `wf-eee9a073` (Shipping Real Code)*
- **Never-touch boundaries**: no secrets, no destructive deletes, optional “don’t touch tests” (`prompt.md`)
- **Blocked signal**: if human action is required, document and emit `<promise>BLOCKED</promise>` (`prompt.md`, enforced by `ralph.sh`)

### 4) Loop Hardening (`ralph.sh`)
*Source: `wf-8ceac0c4` (ralph-claude-code)*
- **No-progress circuit breaker**: fingerprint-based detection on `progress.txt` (`RALPH_MAX_NO_PROGRESS`)
- **Error burst circuit breaker**: stop after repeated non-zero `amp` exits (`RALPH_MAX_CONSECUTIVE_ERRORS`)
- **Rate/usage limit detection**: stop and prompt retry later (exit code `2`)
- **Blocked detection**: stop when `<promise>BLOCKED</promise>` is emitted (exit code `3`)
- **Timeouts**: optional per-iteration timeout if `timeout` exists (`RALPH_ITERATION_TIMEOUT_MINUTES`)
- **Intelligent exit detection**: requires BOTH `<promise>COMPLETE</promise>` AND `prd.json` having 0 remaining stories

## P1: Continuity, Persistence, Isolation

### 1) Session Lineage + Scratchpad (`.agent/`)
*Source: `wf-bc51a50b` (ralph-orchestrator), `tool-3bb5a470` (claude-code-tools)*
- **Scratchpad memory**: `.agent/scratchpad.md` read/write guidance in `prompt.md`
- **Parent session tracking**: `.agent/last-session` → `RALPH_PARENT_SESSION_ID` injection (`ralph.sh`)
- **Archive scratchpad**: copied into `archive/…/scratchpad.md` on branch rollover (`ralph.sh`)

### 2) Task/Dev-Docs Templates
*Source: `tool-9f8d507e` (cc-sessions), `wf-bdb46cd1` (Scopecraft MDTM), `wf-82428576` (infra showcase)*
- **Task persistence template**: `tasks/_template-task.md` (frontmatter)
- **Dev docs 3-file pattern**: `dev-docs/template-*.md`

### 3) Worktree + Docker Isolation (Optional)
*Source: `tool-5fb873b1` (TSK), `tool-fcf2812e` (viwo-cli)*
- **Worktree runner**: `scripts/ralph-run-worktree.sh` (isolated worktree per `branchName`)
- **Docker sandbox skeleton**: `docker/Dockerfile`, `docker/README.md`

## Config Knobs (Key Env Vars)

- `RALPH_MODE`: `playground` | `pair` | `production`
- `RALPH_AUTO_APPROVE`: `1` (default) to proceed after `[PLAN]` in autonomous mode
- `RALPH_HUMANS_WRITE_TESTS`: `1` (default) blocks edits to tests in hooks + prompt
- `RALPH_MAX_NO_PROGRESS`, `RALPH_MAX_CONSECUTIVE_ERRORS`, `RALPH_ITERATION_TIMEOUT_MINUTES`, `RALPH_SLEEP_SECONDS`

---

## Execution Status

- [x] **P0 Safety Hooks Suite** (`hooks/pre-commit`, `hooks/pre-push`, `hooks/install.sh`, `hooks/safe-rm`)
- [x] **P0 DAIC + scope drift + approval gate** (`prompt.md`)
- [x] **P0 Humans Write Tests + never-touch boundaries + blocked signal** (`prompt.md`, `ralph.sh`)
- [x] **P0 Loop hardening** (fingerprint no-progress, error burst, timeout, rate limit, intelligent exit) (`ralph.sh`)
- [x] **P1 Session lineage + scratchpad** (`.agent/*`, `ralph.sh`, `.gitignore`)
- [x] **P1 Task + dev-docs templates** (`tasks/_template-task.md`, `dev-docs/`)
- [x] **P1 Worktree + Docker isolation skeleton** (`scripts/ralph-run-worktree.sh`, `docker/`)
