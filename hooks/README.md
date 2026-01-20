# Ralph Hooks

This directory contains safety and workflow hooks for Ralph.

## Hooks (P0/P1)

### `pre-commit` (Git Commit Protection)
Default behavior is safe-by-default for autonomous runs:
- Blocks tracked file deletions unless the path is under `TRASH/`
- Blocks committing secrets (`.env*`, keys/certs, etc.)
- Blocks very large diffs unless explicitly allowed
- If `RALPH_HUMANS_WRITE_TESTS=1`, blocks edits to test files

### `pre-push` (Branch Discipline)
- If `prd.json` exists, blocks pushing from a branch that doesn't match `prd.json.branchName`

### `safe-rm` (TRASH Pattern)
Replacement for destructive deletes:
```bash
./hooks/safe-rm path/to/file-or-dir
```

## Usage

Install into the current repo:
```bash
./hooks/install.sh
```

Hooks can also be symlinked manually into `.git/hooks/`.
