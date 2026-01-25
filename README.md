# Ralph

![Ralph](ralph.webp)

Ralph is an autonomous AI agent loop that runs an AI coding agent repeatedly until all PRD items are complete. Each iteration is a fresh agent instance with clean context. Memory persists via git history, `progress.txt`, and `prd.json`.

Based on [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/).

## Supported Providers

| Provider | Command | Selection |
|----------|---------|-----------|
| AMP (default) | `amp` | `RALPH_PROVIDER=amp` |
| Claude Code | `claude` | `RALPH_PROVIDER=claude-code` |
| Antigravity | `antigravity` | `RALPH_PROVIDER=antigravity` |
| CODEX | `codex` | `RALPH_PROVIDER=codex` |

Provider configurations are defined in [`config/providers.json`](config/providers.json).

## Prerequisites

- One of the supported AI CLI tools installed and authenticated
- `jq` installed (`brew install jq` on macOS, `apt install jq` on Ubuntu)
- A git repository for your project

## Quick Start

```bash
# 1. Create a PRD using the skill
# In your AI agent: "Load the prd skill and create a PRD for [feature]"

# 2. Convert to Ralph format
# In your AI agent: "Load the ralph skill and convert tasks/prd-[feature].md to prd.json"

# 3. Run Ralph
./ralph.sh 10
```

## Setup

### Option 1: Copy to your project

```bash
# From your project root
mkdir -p scripts/ralph
cp /path/to/ralph/ralph.sh scripts/ralph/
cp /path/to/ralph/prompt.md scripts/ralph/
chmod +x scripts/ralph/ralph.sh
```

### Option 2: Install skills globally

Copy skills to your Amp config for use across all projects:

```bash
cp -r skills/prd ~/.config/amp/skills/
cp -r skills/ralph ~/.config/amp/skills/
cp -r skills/dev-browser ~/.config/amp/skills/
```

### Configure auto-handoff (recommended)

For Amp, add to `~/.config/amp/settings.json`:

```json
{
  "amp.experimental.autoHandoff": { "context": 90 }
}
```

This enables automatic handoff when context fills up, allowing Ralph to handle large stories that exceed a single context window.

> **Note**: Auto-handoff configuration varies by provider. Check your provider's documentation for equivalent settings.

## Usage

### Basic Execution

```bash
# Default: 10 iterations with AMP
./ralph.sh

# Custom iteration count
./ralph.sh 20

# Different provider
RALPH_PROVIDER=claude-code ./ralph.sh 10
RALPH_PROVIDER=antigravity ./ralph.sh 10
RALPH_PROVIDER=codex ./ralph.sh 10
```

### Sandboxed Mode

Run with restricted permissions for safer execution:

```bash
RALPH_SANDBOXED=1 ./ralph.sh 10
```

Permission allowlists are defined in [`config/permissions.json`](config/permissions.json).

### Parallel Execution

Run multiple independent stories concurrently:

```bash
# Run with 3 parallel workers
./scripts/ralph-parallel.sh -w 3

# Run specific stories only
./scripts/ralph-parallel.sh -s "US-001,US-002"
```

> **Note**: Only use for stories without dependencies on each other.

### Docker Sandbox

Run Ralph in an isolated container:

```bash
# Build the container
docker build -t ralph-sandbox -f docker/Dockerfile .

# Run with default provider
docker run --rm -it -v "$PWD:/workspace" -w /workspace ralph-sandbox ./ralph.sh 10

# Run with different provider
docker run --rm -it -e RALPH_PROVIDER=claude-code -v "$PWD:/workspace" -w /workspace ralph-sandbox ./ralph.sh 10
```

See [`docker/README.md`](docker/README.md) for details.

## Workflow

### 1. Create a PRD

Use the PRD skill to generate a detailed requirements document:

```
Load the prd skill and create a PRD for [your feature description]
```

Answer the clarifying questions. The skill saves output to `tasks/prd-[feature-name].md`.

### 2. Convert PRD to Ralph format

Use the Ralph skill to convert the markdown PRD to JSON:

```
Load the ralph skill and convert tasks/prd-[feature-name].md to prd.json
```

This creates `prd.json` with user stories structured for autonomous execution.

### 3. Run Ralph

```bash
./ralph.sh [max_iterations]
```

Ralph will:

1. Create a feature branch (from PRD `branchName`)
2. Pick the highest priority story where `passes: false`
3. Implement that single story
4. Run quality checks (typecheck, tests)
5. Commit if checks pass
6. Update `prd.json` to mark story as `passes: true`
7. Append learnings to `progress.txt`
8. Repeat until all stories pass or max iterations reached

## Project Structure

| File/Directory | Purpose |
|----------------|---------|
| `ralph.sh` | Main loop that spawns fresh agent instances |
| `prompt.md` | Instructions given to each agent instance |
| `prd.json` | User stories with `passes` status (task list) |
| `prd.json.example` | Example PRD format for reference |
| `progress.txt` | Append-only learnings for future iterations |
| **config/** | |
| `config/providers.json` | Provider definitions (commands, flags) |
| `config/permissions.json` | Permission allowlists for sandboxed mode |
| `config/ralph.config.sh` | Configuration loader script |
| **skills/** | |
| `skills/prd/` | Skill for generating PRDs |
| `skills/ralph/` | Skill for converting PRDs to JSON |
| `skills/dev-browser/` | Browser verification skill |
| `skills/discovery/` | Codebase discovery skill |
| **scripts/** | |
| `scripts/ralph-parallel.sh` | Parallel execution orchestrator |
| `scripts/ralph-run-worktree.sh` | Git worktree runner for parallel execution |
| **hooks/** | |
| `hooks/install.sh` | Install git hooks |
| `hooks/pre-commit` | Block deletions, secrets, large diffs |
| `hooks/pre-push` | Enforce branch naming |
| `hooks/safe-rm` | Move files to TRASH/ instead of deleting |
| **docker/** | |
| `docker/Dockerfile` | Container definition for sandboxed execution |
| **flowchart/** | Interactive React Flow visualization |

## Interactive Flowchart

[![Ralph Flowchart](ralph-flowchart.png)](https://deepakdgupta1.github.io/ralph/)

**[View Interactive Flowchart](https://deepakdgupta1.github.io/ralph/)**

The flowchart shows how Ralph processes each user story. Click through to see each step with animations.

To run locally:

```bash
cd flowchart
npm install
npm run dev
```

## Critical Concepts

### Fresh Context Per Iteration

Each iteration spawns a **new agent instance** with clean context. Memory between iterations comes only from:

- Git history (commits from previous iterations)
- `progress.txt` (learnings and context)
- `prd.json` (which stories are done)
- `AGENTS.md` files (discovered patterns)

### Right-Sized Stories

Each PRD item should be small enough to complete in one context window. If a task is too big, the LLM runs out of context before finishing.

**Good story sizes:**
- Add a database column and migration
- Add a UI component to an existing page
- Update a server action with new logic
- Add a filter dropdown to a list

**Too big (split these):**
- "Build the entire dashboard"
- "Add authentication"
- "Refactor the API"

### AGENTS.md Updates

After each iteration, Ralph updates `AGENTS.md` files with learnings. This is critical because agents automatically read these files, so future iterations benefit from discovered patterns, gotchas, and conventions.

Examples of what to add:
- Patterns discovered ("this codebase uses X for Y")
- Gotchas ("do not forget to update Z when changing W")
- Useful context ("the settings panel is in component X")

### Feedback Loops

Ralph requires feedback loops to work effectively:

- Typecheck catches type errors
- Tests verify behavior
- CI must stay green (broken code compounds across iterations)

### Browser Verification

Frontend stories should include "Verify in browser using dev-browser skill" in acceptance criteria. Ralph will navigate to the page, interact with the UI, and confirm changes work.

### Git Hooks

Install hooks for deterministic quality enforcement:

```bash
./hooks/install.sh
```

Hooks block commits with deletions (use TRASH/), secrets, large diffs, and test edits. See [`hooks/README.md`](hooks/README.md) for details.

### Stop Condition

When all stories have `passes: true`, Ralph outputs `<promise>COMPLETE</promise>` and the loop exits.

## Debugging

```bash
# See which stories are done
jq '.userStories[] | {id, title, passes}' prd.json

# See learnings from previous iterations
cat progress.txt

# Check git history
git log --oneline -10
```

## Customization

Edit `prompt.md` to customize Ralph's behavior:

- Add project-specific quality check commands
- Include codebase conventions
- Add common gotchas for your stack

## Archiving

Ralph automatically archives previous runs when you start a new feature branch (different `branchName`). Archives are saved to `archive/YYYY-MM-DD-feature-name/`.

## References

- [Geoffrey Huntley's Ralph article](https://ghuntley.com/ralph/)
- [AMP documentation](https://ampcode.com/manual)
- [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code)
- [CODEX documentation](https://github.com/openai/codex)
