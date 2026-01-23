# Ralph Hooks

Deterministic quality enforcement for Ralph. Unlike AGENTS.md guidance (advisory), hooks **guarantee** actions happen every time.

## Philosophy

| Approach | Enforcement | Use Case |
|----------|-------------|----------|
| AGENTS.md | Advisory | Coding style, conventions |
| Hooks | Deterministic | Security, safety, quality gates |

Hooks catch mistakes that would otherwise require human review.

## Git Hooks (Installed)

### `pre-commit` (Git Commit Protection)

**What it enforces:**
- Blocks tracked file deletions unless the path is under `TRASH/`
- Blocks committing secrets (`.env*`, keys/certs, etc.)
- Blocks very large diffs (>500 lines) unless explicitly allowed
- If `RALPH_HUMANS_WRITE_TESTS=1`, blocks edits to test files

**Environment variables:**
- `RALPH_HOOKS_BYPASS=1` - Skip all checks (emergency override)
- `RALPH_ALLOW_LARGE_DIFF=1` - Allow large file changes
- `RALPH_MAX_CHANGED_LINES=N` - Change the large diff threshold (default: 500)
- `RALPH_HUMANS_WRITE_TESTS=1` - Block test file modifications

### `pre-push` (Branch Discipline)

**What it enforces:**
- If `prd.json` exists, blocks pushing from a branch that doesn't match `prd.json.branchName`

**Environment variables:**
- `RALPH_HOOKS_BYPASS=1` - Skip check

## Utility Scripts

### `safe-rm` (TRASH Pattern)

Replacement for destructive deletes. Enforces the "NEVER use `rm`" rule from prompt.md.

```bash
./hooks/safe-rm path/to/file-or-dir
```

**Behavior:**
- Creates `TRASH/` directory if it doesn't exist
- Moves files with timestamp prefix: `TRASH/20240115-143022-filename`
- Skips missing paths with warning

**Environment variables:**
- `RALPH_TRASH_DIR=custom-trash` - Use a different trash directory

## Example Hooks (Copy and Customize)

### `post-edit.example` (Auto-Format After Edit)

Runs formatters on edited files. Invoke from editor plugins or agent wrappers.

```bash
./hooks/post-edit.example src/component.tsx
```

**Supported formats:** JS/TS (prettier), Python (black/ruff), Go (gofmt), Rust (rustfmt), JSON/MD (prettier), Shell (shfmt)

**Environment variables:**
- `RALPH_FORMAT_JS`, `RALPH_FORMAT_TS`, etc. - Override formatter commands

### `guardrails.example` (Block Sensitive File Edits)

Pre-flight check before editing files. Returns exit 1 if any file is protected.

```bash
./hooks/guardrails.example .env config/secrets.json
# ❌ BLOCKED: .env (protected by guardrails)
```

**Default protected patterns:**
- `.env`, `.env.*` - Environment files
- `*.pem`, `*.key`, `*.p12`, `*.pfx` - Certificates and keys
- `*id_rsa*`, `*id_ed25519*` - SSH keys
- `*credentials*`, `*secrets*` - Credential files

**Environment variables:**
- `RALPH_PROTECTED_PATTERNS="*.lock terraform/*"` - Add protected patterns
- `RALPH_ALLOWED_PATTERNS="TRASH/* temp/*"` - Override protection for specific paths
- `RALPH_HOOKS_BYPASS=1` - Skip all guardrails

## Installation

Install git hooks into the current repo:

```bash
./hooks/install.sh
```

This creates symlinks in `.git/hooks/` pointing to the hooks in this directory.

To use example hooks, copy and customize:

```bash
cp hooks/post-edit.example hooks/post-edit
cp hooks/guardrails.example hooks/guardrails
chmod +x hooks/post-edit hooks/guardrails
```

## Integration Patterns

### Agent Wrapper Integration

```bash
# Before edit_file
./hooks/guardrails "$FILE" || exit 1

# After edit_file
./hooks/post-edit "$FILE"
```

### CI Integration

```yaml
# .github/workflows/pr.yml
- name: Check guardrails
  run: |
    CHANGED=$(git diff --name-only origin/main)
    ./hooks/guardrails.example $CHANGED
```

### Editor Integration

Configure your editor to run `post-edit` on save for automatic formatting.

## Extending

To add a new hook:

1. Create the script in `hooks/`
2. Make it executable: `chmod +x hooks/my-hook`
3. For git hooks, add to `install.sh`
4. Document in this README

Follow the pattern of existing hooks:
- Use `set -euo pipefail`
- Support `RALPH_HOOKS_BYPASS=1` for emergency override
- Print clear error messages with ❌ prefix
- Exit 0 on success, 1 on failure
