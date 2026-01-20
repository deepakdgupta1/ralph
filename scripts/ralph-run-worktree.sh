#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MAX_ITERATIONS="${1:-${RALPH_MAX_ITERATIONS:-10}}"
WORKTREES_DIR="${RALPH_WORKTREES_DIR:-$ROOT_DIR/.agent/worktrees}"

PRD_FILE="$ROOT_DIR/prd.json"
if [ ! -f "$PRD_FILE" ]; then
  echo "❌ Missing $PRD_FILE"
  echo "Create prd.json first (see prd.json.example)."
  exit 1
fi

BRANCH_NAME="$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || true)"
if [ -z "$BRANCH_NAME" ]; then
  echo "❌ Missing prd.json.branchName"
  exit 1
fi

SAFE_BRANCH_DIR="$(echo "$BRANCH_NAME" | tr '/' '-')"
WORKTREE_PATH="$WORKTREES_DIR/$SAFE_BRANCH_DIR"

mkdir -p "$WORKTREES_DIR"

if [ ! -d "$WORKTREE_PATH/.git" ] && [ ! -f "$WORKTREE_PATH/ralph.sh" ]; then
  echo "Creating worktree for $BRANCH_NAME at $WORKTREE_PATH"
  git worktree add -B "$BRANCH_NAME" "$WORKTREE_PATH"
fi

cp "$PRD_FILE" "$WORKTREE_PATH/prd.json"
if [ -f "$ROOT_DIR/progress.txt" ]; then
  cp "$ROOT_DIR/progress.txt" "$WORKTREE_PATH/progress.txt"
fi

echo "Running Ralph in worktree: $WORKTREE_PATH"
(
  cd "$WORKTREE_PATH"
  ./ralph.sh "$MAX_ITERATIONS"
)
