# Ralph Scripts

Utility scripts for running Ralph in different modes.

## ralph-parallel.sh

Run multiple Ralph instances on independent stories concurrently.

### Usage

```bash
./scripts/ralph-parallel.sh [options]

Options:
  -w, --workers NUM      Number of parallel workers (default: 2)
  -s, --stories ID,...   Comma-separated list of story IDs to run
  -m, --max-iterations   Max iterations per worker (default: 10)
  -h, --help             Show help message
```

### Examples

```bash
# Run 3 workers on the first 3 available stories
./scripts/ralph-parallel.sh -w 3

# Run specific stories in parallel
./scripts/ralph-parallel.sh -s US-001,US-002,US-003

# Run with custom iteration limit
./scripts/ralph-parallel.sh -w 2 -m 5
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `RALPH_PARALLEL_WORKERS` | Number of parallel workers | 2 |
| `RALPH_MAX_ITERATIONS` | Max iterations per worker | 10 |
| `RALPH_PROVIDER` | AI provider to use | amp |
| `RALPH_WORKER_ID` | Set automatically for each worker | - |

### How It Works

1. Reads `prd.json` to find stories not yet passing
2. Checks provider supports parallel execution (see `config/providers.json`)
3. Checks for file conflicts between stories (via `touchesFiles` field)
4. Spawns one worker per story, each with:
   - Separate progress file in `.agent/parallel/worker-N/`
   - Unique `RALPH_WORKER_ID` environment variable
   - Isolated prd.json with only that story
5. Waits for all workers to complete
6. Merges progress files back to main `progress.txt`
7. Updates main `prd.json` with completed stories

### When to Use Parallel vs Sequential

**Use Parallel When:**
- Stories are independent and don't touch the same files
- You want to complete multiple stories faster
- Stories work on separate features/modules
- You have sufficient API rate limits

**Use Sequential (default `ralph.sh`) When:**
- Stories have dependencies (one must complete before another)
- Stories modify the same files
- You need strict ordering of changes
- You're debugging or want predictable execution

### Limitations

1. **File Conflicts**: Don't parallelize stories that touch the same files. Use the `touchesFiles` field in prd.json to declare file dependencies:

```json
{
  "id": "US-001",
  "title": "Add priority field",
  "touchesFiles": ["src/db/schema.ts", "src/types.ts"]
}
```

2. **Git Conflicts**: Each worker operates on the same branch. Parallel execution may cause merge conflicts. Consider using separate branches per story.

3. **Rate Limits**: Multiple workers hit the API simultaneously. Watch for rate limit errors, especially with Claude Code and CODEX.

4. **Resource Usage**: Each worker is a full Ralph instance. Monitor CPU/memory on your machine.

5. **Provider Support**: Not all providers officially support parallel execution. See `supportsParallel` in `config/providers.json`:

| Provider | Parallel Support | Notes |
|----------|-----------------|-------|
| AMP | ✅ Yes | Fully supported, separate threads |
| Claude Code | ✅ Yes | Supported, watch rate limits |
| Antigravity | ❌ No | Not verified |
| CODEX | ✅ Yes | Supported, watch rate limits |

### Output

Worker logs are prefixed with `[WN]` where N is the worker ID:

```
[W1] Starting work on story: US-001
[W2] Starting work on story: US-002
[W1] Iteration 1 complete. Continuing...
[W2] Ralph completed all tasks!
```

Progress is merged into `progress.txt` with worker sections:

```markdown
# Parallel Execution Results - Thu Jan 22 2026

## Worker 1
[content from worker 1]

## Worker 2
[content from worker 2]
```

## ralph-run-worktree.sh

Run Ralph in a git worktree for isolated execution.

### Usage

```bash
./scripts/ralph-run-worktree.sh [max_iterations]
```

Creates a worktree at `.agent/worktrees/<branch-name>` and runs Ralph there, keeping the main working directory clean.
