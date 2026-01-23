# Ralph

![Ralph](ralph.webp)

Ralph is an autonomous AI agent loop that runs
an AI coding agent repeatedly until all PRD items are complete.
Each iteration is a fresh agent instance with clean context.
Memory persists via git history, `progress.txt`, and `prd.json`.

Based on [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/).

[Read my in-depth article on how I use Ralph](https://x.com/ryancarson/status/2008548371712135632)

## Supported Providers

| Provider | Command | Selection |
|----------|---------|----------|
| AMP (default) | `amp` | `RALPH_PROVIDER=amp` |
| Claude Code | `claude` | `RALPH_PROVIDER=claude-code` |
| Antigravity | `antigravity` | `RALPH_PROVIDER=antigravity` |
| CODEX | `codex` | `RALPH_PROVIDER=codex` |

Provider configurations are defined in `config/providers.json`.

## Prerequisites

- One of the supported AI CLI tools installed and authenticated
- `jq` installed (`brew install jq` on macOS)
- A git repository for your project

## Setup

### Option 1: Copy to your project

Copy the ralph files into your project:

```bash
# From your project root
mkdir -p scripts/ralph
cp /path/to/ralph/ralph.sh scripts/ralph/
cp /path/to/ralph/prompt.md scripts/ralph/
chmod +x scripts/ralph/ralph.sh
```

### Option 2: Install skills globally

Copy the skills to your Amp config for use across all projects:

```bash
cp -r skills/prd ~/.config/amp/skills/
cp -r skills/ralph ~/.config/amp/skills/
```

### Configure Amp auto-handoff (recommended)

Add to `~/.config/amp/settings.json`:

```json
{
  "amp.experimental.autoHandoff": { "context": 90 }
}
```

This enables automatic handoff when context fills up,
allowing Ralph to handle large stories that exceed a single context window.

> **Note**: Auto-handoff configuration varies by provider. Check your provider's documentation for equivalent settings.

### Select a Provider

By default, Ralph uses AMP. To use a different provider:

```bash
# Use Claude Code
RALPH_PROVIDER=claude-code ./ralph.sh 10

# Use Antigravity
RALPH_PROVIDER=antigravity ./ralph.sh 10

# Use CODEX
RALPH_PROVIDER=codex ./ralph.sh 10
```

### Sandboxed Mode

Run Ralph with restricted permissions for safer execution:

```bash
RALPH_SANDBOXED=1 ./ralph.sh 10
```

Permission allowlists are defined in `config/permissions.json`.

## Workflow

### 1. Create a PRD

Use the PRD skill to generate a detailed requirements document:

```text prompt
Load the prd skill and create a PRD for [your feature description]
```

Answer the clarifying questions. The skill saves output to `tasks/prd-[feature-name].md`.

### 2. Convert PRD to Ralph format

Use the Ralph skill to convert the markdown PRD to JSON:

```text prompt
Load the ralph skill and convert tasks/prd-[feature-name].md to prd.json
```

This creates `prd.json` with user stories structured for autonomous execution.

### 3. Run Ralph

```bash
./scripts/ralph/ralph.sh [max_iterations]
```

Default is 10 iterations.

### Parallel Execution

Run multiple independent stories in parallel:

```bash
# Run with 3 parallel workers
./scripts/ralph-parallel.sh -w 3

# Run specific stories only
./scripts/ralph-parallel.sh -s "US-001,US-002"
```

> **Note**: Only use for stories without dependencies on each other.

Ralph will:

1. Create a feature branch (from PRD `branchName`)
2. Pick the highest priority story where `passes: false`
3. Implement that single story
4. Run quality checks (typecheck, tests)
5. Commit if checks pass
6. Update `prd.json` to mark story as `passes: true`
7. Append learnings to `progress.txt`
8. Repeat until all stories pass or max iterations reached

## Key Files

| File | Purpose |
| ------ | --------- |
| `ralph.sh` | The bash loop that spawns fresh agent instances |
| `prompt.md` | Instructions given to each agent instance |
| `config/providers.json` | Provider definitions (commands, flags) |
| `config/ralph.config.sh` | Configuration loader script |
| `prd.json` | User stories with `passes` status (the task list) |
| `prd.json.example` | Example PRD format for reference |
| `progress.txt` | Append-only learnings for future iterations |
| `skills/prd/` | Skill for generating PRDs |
| `skills/ralph/` | Skill for converting PRDs to JSON |
| `skills/dev-browser/` | Browser verification skill |
| `flowchart/` | Interactive visualization of how Ralph works |
| `hooks/` | Git hooks for quality enforcement |
| `config/permissions.json` | Permission allowlists for sandboxed mode |
| `scripts/ralph-parallel.sh` | Parallel execution script |

## Flowchart

[![Ralph Flowchart](ralph-flowchart.png)](https://snarktank.github.io/ralph/)

**[View Interactive Flowchart](https://snarktank.github.io/ralph/)**

The `flowchart/` directory contains an interactive visualization built with React Flow. It:

- Shows how Ralph processes each user story
- Click through to see each step with animations.

The `flowchart/` directory contains the source code. To run locally:

```bash
cd flowchart
npm install
npm run dev
```

## Critical Concepts

### Each Iteration = Fresh Context

Each iteration spawns a **new agent instance** with clean context.
The only memory between iterations is:

- Git history (commits from previous iterations)
- `progress.txt` (learnings and context)
- `prd.json` (which stories are done)

### Small Tasks

Each PRD item should be small enough to complete in one context window.
If a task is too big, the LLM runs out of context before finishing and produces poor code.

Right-sized stories:

- Add a database column and migration
- Add a UI component to an existing page
- Update a server action with new logic
- Add a filter dropdown to a list

Too big (split these):

- "Build the entire dashboard"
- "Add authentication"
- "Refactor the API"

### AGENTS.md Updates Are Critical

After each iteration, Ralph updates the relevant `AGENTS.md` files with learnings.
This is key because agents automatically read these files,
so future iterations (and future human developers) benefit from discovered patterns, gotchas, and conventions.

Examples of what to add to AGENTS.md:

- Patterns discovered ("this codebase uses X for Y")
- Gotchas ("do not forget to update Z when changing W")
- Useful context ("the settings panel is in component X")

### Feedback Loops

Ralph only works if there are feedback loops:

- Typecheck catches type errors
- Tests verify behavior
- CI must stay green (broken code compounds across iterations)

### Browser Verification for UI Stories

Frontend stories must include "Verify in browser using dev-browser skill" in acceptance criteria.
Ralph will use the dev-browser skill to navigate to the page,
interact with the UI, and confirm changes work.

### Git Hooks

Install hooks for deterministic quality enforcement:

```bash
./hooks/install.sh
```

Hooks block commits with deletions (use TRASH/), secrets, large diffs, and test edits.
See `hooks/` for available hooks and customization.

### Stop Condition

When all stories have `passes: true`,
Ralph outputs `<promise>COMPLETE</promise>` and the loop exits.

## Debugging

Check current state:

```bash
# See which stories are done
cat prd.json | jq '.userStories[] | {id, title, passes}'

# See learnings from previous iterations
cat progress.txt

# Check git history
git log --oneline -10
```

## Customizing prompt.md

Edit `prompt.md` to customize Ralph's behavior for your project:

- Add project-specific quality check commands
- Include codebase conventions
- Add common gotchas for your stack

## Archiving

Ralph automatically archives previous runs when you start a new feature branch (different `branchName`).
Archives are saved to `archive/YYYY-MM-DD-feature-name/`.

## References

- [Geoffrey Huntley's Ralph article](https://ghuntley.com/ralph/)
- [AMP documentation](https://ampcode.com/manual)
- [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code)
- [CODEX documentation](https://github.com/openai/codex)
