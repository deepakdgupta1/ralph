# Ralph Agent Instructions

## Overview

Ralph is an autonomous AI agent loop that runs Amp repeatedly until all PRD items are complete. Each iteration is a fresh Amp instance with clean context.

## Commands

```bash
# Run the flowchart dev server
cd flowchart && npm run dev

# Build the flowchart
cd flowchart && npm run build

# Run Ralph (from your project that has prd.json)
./ralph.sh [max_iterations]
```

## Key Files

- `ralph.sh` - The bash loop that spawns fresh Amp instances
- `prompt.md` - Instructions given to each Amp instance
- `prd.json.example` - Example PRD format
- `flowchart/` - Interactive React Flow diagram explaining how Ralph works

## Flowchart

The `flowchart/` directory contains an interactive visualization built with React Flow. It's designed for presentations - click through to reveal each step with animations.

To run locally:
```bash
cd flowchart
npm install
npm run dev
```

## Patterns

- Each iteration spawns a fresh Amp instance with clean context
- Memory persists via git history, `progress.txt`, and `prd.json`
- Cross-iteration scratchpad lives in `.agent/scratchpad.md` (local, ignored by git)
- Stories should be small enough to complete in one context window
- Default safety/backpressure is controlled via env vars (`RALPH_MODE`, `RALPH_AUTO_APPROVE`, `RALPH_HUMANS_WRITE_TESTS`)
- Git safety hooks live in `hooks/` (install with `./hooks/install.sh`, use `./hooks/safe-rm` for TRASH deletes)
- Always update AGENTS.md with discovered patterns for future iterations

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
