# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs a coding agent repeatedly until all PRD items are complete. Each iteration is a fresh agent instance with clean context. Supports multiple providers: AMP, Claude Code, Antigravity, CODEX.

## Commands

```bash
# Run the flowchart dev server
cd flowchart && npm run dev

# Build the flowchart
cd flowchart && npm run build

# Run Ralph (from your project that has prd.json)
./ralph.sh [max_iterations]

# Sandboxed mode (permission-restricted)
RALPH_SANDBOXED=1 ./ralph.sh 10

# Parallel execution
./scripts/ralph-parallel.sh -w 3
```

## Key Files

- `ralph.sh` - The bash loop that spawns fresh agent instances
- `prompt.md` - Instructions given to each agent instance
- `config/providers.json` - Provider definitions and command patterns
- `config/ralph.config.sh` - Configuration loader script
- `prd.json.example` - Example PRD format
- `flowchart/` - Interactive React Flow diagram explaining how Ralph works
- `config/permissions.json` - Permission allowlists for sandboxed mode
- `scripts/ralph-parallel.sh` - Parallel execution orchestrator
- `skills/dev-browser/` - Browser verification skill
- `skills/README.md` - Skills documentation

## Flowchart

The `flowchart/` directory contains an interactive visualization built with React Flow. It's designed for presentations - click through to reveal each step with animations.

To run locally:
```bash
cd flowchart
npm install
npm run dev
```

## Patterns

- Each iteration spawns a fresh agent instance with clean context
- Memory persists via git history, `progress.txt`, and `prd.json`
- Cross-iteration scratchpad lives in `.agent/scratchpad.md` (local, ignored by git)
- Stories should be small enough to complete in one context window
- Default safety/backpressure is controlled via env vars (`RALPH_MODE`, `RALPH_AUTO_APPROVE`, `RALPH_HUMANS_WRITE_TESTS`)
- Provider selection via `RALPH_PROVIDER` env var (default: `amp`)
- Git safety hooks live in `hooks/` (install with `./hooks/install.sh`, use `./hooks/safe-rm` for TRASH deletes)
- Always update AGENTS.md with discovered patterns for future iterations
- Sandboxed mode available via `RALPH_SANDBOXED=1` for safer operation
- Parallel execution available for independent stories via `scripts/ralph-parallel.sh`
- Use subagents for exploration to preserve main context (documented in prompt.md)

## Hooks System

Deterministic quality enforcement (unlike AGENTS.md which is advisory). Install with `./hooks/install.sh`.

**Git Hooks (auto-installed):**
- `pre-commit` - Blocks deletions (use TRASH/), secrets, large diffs, test edits
- `pre-push` - Enforces branch matches `prd.json.branchName`

**Utilities:**
- `safe-rm` - Move files to TRASH/ instead of deleting

**Example hooks (copy and customize):**
- `post-edit.example` - Auto-format files after edit
- `guardrails.example` - Block edits to sensitive files

**Key env vars:**
- `RALPH_HOOKS_BYPASS=1` - Emergency override for all hooks
- `RALPH_TRASH_DIR` - Custom trash directory (default: `TRASH/`)

## Documentation Conventions

### Metrics Documentation Format

When documenting metrics, use a bulleted sub-list under each metric with the following structure:

```markdown
**Metric Name**
- **What it measures:** Brief description
- **Better values:** High / Low / Optimal range
- **Indicates:** What the metric reveals about the system
- **Related metrics:** Cross-references to paired metrics (if any)
- **Recommended Action:** What to do when out of range
```
