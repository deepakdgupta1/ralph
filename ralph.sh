#!/bin/bash
# Ralph Wiggum - Long-running AI agent loop
# Usage: ./ralph.sh [max_iterations]

set -e
set -o pipefail

MAX_ITERATIONS=${1:-${RALPH_MAX_ITERATIONS:-10}}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRD_FILE="$SCRIPT_DIR/prd.json"
PROGRESS_FILE="$SCRIPT_DIR/progress.txt"
ARCHIVE_DIR="$SCRIPT_DIR/archive"
LAST_BRANCH_FILE="$SCRIPT_DIR/.last-branch"
STATE_DIR="$SCRIPT_DIR/.agent"
SCRATCHPAD_FILE="$STATE_DIR/scratchpad.md"
LAST_SESSION_FILE="$STATE_DIR/last-session"

# ------------------------------------------------------------------
# Config (override via env vars)
# ------------------------------------------------------------------
MAX_NO_PROGRESS="${RALPH_MAX_NO_PROGRESS:-3}"
MAX_CONSECUTIVE_ERRORS="${RALPH_MAX_CONSECUTIVE_ERRORS:-5}"
ITERATION_TIMEOUT_MINUTES="${RALPH_ITERATION_TIMEOUT_MINUTES:-60}"
SLEEP_SECONDS="${RALPH_SLEEP_SECONDS:-2}"

export RALPH_MODE="${RALPH_MODE:-production}"                 # playground | pair | production
export RALPH_AUTO_APPROVE="${RALPH_AUTO_APPROVE:-1}"         # 1 = proceed after plan in autonomous mode
export RALPH_HUMANS_WRITE_TESTS="${RALPH_HUMANS_WRITE_TESTS:-1}" # 1 = never edit test files (default)

file_fingerprint() {
  local filepath="$1"
  if [ ! -f "$filepath" ]; then
    echo "missing"
    return 0
  fi

  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$filepath" | awk '{print $1}'
    return 0
  fi

  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$filepath" | awk '{print $1}'
    return 0
  fi

  wc -c < "$filepath" | tr -d ' '
}

# Ensure state directory exists
mkdir -p "$STATE_DIR"
touch "$SCRATCHPAD_FILE"

# Archive previous run if branch changed
if [ -f "$PRD_FILE" ] && [ -f "$LAST_BRANCH_FILE" ]; then
  CURRENT_BRANCH=$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")
  LAST_BRANCH=$(cat "$LAST_BRANCH_FILE" 2>/dev/null || echo "")

  if [ -n "$CURRENT_BRANCH" ] && [ -n "$LAST_BRANCH" ] && [ "$CURRENT_BRANCH" != "$LAST_BRANCH" ]; then
    DATE=$(date +%Y-%m-%d)
    FOLDER_NAME=$(echo "$LAST_BRANCH" | sed 's|^ralph/||')
    ARCHIVE_FOLDER="$ARCHIVE_DIR/$DATE-$FOLDER_NAME"

    echo "Archiving previous run: $LAST_BRANCH"
    mkdir -p "$ARCHIVE_FOLDER"
    [ -f "$PRD_FILE" ] && cp "$PRD_FILE" "$ARCHIVE_FOLDER/"
    [ -f "$PROGRESS_FILE" ] && cp "$PROGRESS_FILE" "$ARCHIVE_FOLDER/"
    [ -f "$SCRATCHPAD_FILE" ] && cp "$SCRATCHPAD_FILE" "$ARCHIVE_FOLDER/scratchpad.md"
    echo "   Archived to: $ARCHIVE_FOLDER"

    # Reset progress + scratchpad for new run
    echo "# Ralph Progress Log" > "$PROGRESS_FILE"
    echo "Started: $(date)" >> "$PROGRESS_FILE"
    echo "---" >> "$PROGRESS_FILE"
    : > "$SCRATCHPAD_FILE"
  fi
fi

# Track current branch
if [ -f "$PRD_FILE" ]; then
  CURRENT_BRANCH=$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")
  if [ -n "$CURRENT_BRANCH" ]; then
    echo "$CURRENT_BRANCH" > "$LAST_BRANCH_FILE"
  fi
fi

# Session lineage
export RALPH_PARENT_SESSION_ID=""
if [ -f "$LAST_SESSION_FILE" ]; then
  RALPH_PARENT_SESSION_ID="$(cat "$LAST_SESSION_FILE" 2>/dev/null || echo "")"
fi

RAND_SUFFIX=$(( (RANDOM % 900) + 100 ))
if command -v shuf >/dev/null 2>&1; then
  RAND_SUFFIX="$(shuf -i 100-999 -n 1)"
fi
export RALPH_SESSION_ID="run-$(date +%Y%m%d-%H%M%S)-$RAND_SUFFIX"
echo "$RALPH_SESSION_ID" > "$LAST_SESSION_FILE"

# Initialize progress file if it doesn't exist
if [ ! -f "$PROGRESS_FILE" ]; then
  echo "# Ralph Progress Log" > "$PROGRESS_FILE"
  echo "Started: $(date)" >> "$PROGRESS_FILE"
  echo "Session: $RALPH_SESSION_ID" >> "$PROGRESS_FILE"
  [ -n "$RALPH_PARENT_SESSION_ID" ] && echo "ParentSession: $RALPH_PARENT_SESSION_ID" >> "$PROGRESS_FILE"
  echo "---" >> "$PROGRESS_FILE"
fi

echo "Starting Ralph - Max iterations: $MAX_ITERATIONS"
echo "Session ID: $RALPH_SESSION_ID"
[ -n "$RALPH_PARENT_SESSION_ID" ] && echo "Parent Session ID: $RALPH_PARENT_SESSION_ID"
echo "Mode: $RALPH_MODE (auto-approve=$RALPH_AUTO_APPROVE, humans-write-tests=$RALPH_HUMANS_WRITE_TESTS)"

# Circuit Breaker Initialization
NO_PROGRESS_COUNT=0
CONSECUTIVE_ERROR_COUNT=0
CURRENT_PROGRESS_FINGERPRINT="$(file_fingerprint "$PROGRESS_FILE")"

for i in $(seq 1 $MAX_ITERATIONS); do
  export RALPH_ITERATION="$i"
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  Ralph Iteration $i of $MAX_ITERATIONS (Session: $RALPH_SESSION_ID)"
  echo "═══════════════════════════════════════════════════════"

  AMP_STATUS=0
  AMP_CMD=(amp --dangerously-allow-all)
  if command -v timeout >/dev/null 2>&1; then
    AMP_CMD=(timeout --preserve-status "${ITERATION_TIMEOUT_MINUTES}m" "${AMP_CMD[@]}")
  fi

  OUTPUT=$(
    envsubst '$RALPH_SESSION_ID $RALPH_PARENT_SESSION_ID $RALPH_ITERATION $RALPH_MODE $RALPH_AUTO_APPROVE $RALPH_HUMANS_WRITE_TESTS' \
      < "$SCRIPT_DIR/prompt.md" \
      | "${AMP_CMD[@]}" 2>&1 | tee /dev/stderr
  ) || AMP_STATUS=$?

  # ------------------------------------------------------------------
  # Circuit Breaker & Safety Checks
  # ------------------------------------------------------------------

  # 1. Stuck Loop Detection (No Progress)
  NEW_PROGRESS_FINGERPRINT="$(file_fingerprint "$PROGRESS_FILE")"
  if [ "$NEW_PROGRESS_FINGERPRINT" = "$CURRENT_PROGRESS_FINGERPRINT" ]; then
    NO_PROGRESS_COUNT=$((NO_PROGRESS_COUNT + 1))
    echo "⚠️ Warning: No progress detected in progress.txt (Counter: $NO_PROGRESS_COUNT/$MAX_NO_PROGRESS)"
  else
    NO_PROGRESS_COUNT=0
    CURRENT_PROGRESS_FINGERPRINT="$NEW_PROGRESS_FINGERPRINT"
  fi

  if [ "$NO_PROGRESS_COUNT" -ge "$MAX_NO_PROGRESS" ]; then
    echo "❌ CIRCUIT BREAKER TRIPPED: No progress for $MAX_NO_PROGRESS iterations."
    echo "Stopping loop to prevent infinite retry cycles."
    exit 1
  fi

  # 2. Error Burst Detection
  if [ "$AMP_STATUS" -ne 0 ]; then
    CONSECUTIVE_ERROR_COUNT=$((CONSECUTIVE_ERROR_COUNT + 1))
    echo "⚠️ Warning: amp exited with status $AMP_STATUS (Counter: $CONSECUTIVE_ERROR_COUNT/$MAX_CONSECUTIVE_ERRORS)"
  else
    CONSECUTIVE_ERROR_COUNT=0
  fi

  if [ "$CONSECUTIVE_ERROR_COUNT" -ge "$MAX_CONSECUTIVE_ERRORS" ]; then
    echo "❌ CIRCUIT BREAKER TRIPPED: $MAX_CONSECUTIVE_ERRORS consecutive amp errors."
    echo "Stopping loop to avoid runaway failures."
    exit 1
  fi

  # 3. Usage / Rate Limit Detection (pause required)
  if echo "$OUTPUT" | grep -q -i -E "usage limit|5-?hour|rate limit|too many requests|429"; then
    echo "⏸️ Detected rate/usage limit in output. Exiting so you can retry later."
    exit 2
  fi

  # 4. Explicit Blocked Signal (human action required)
  if echo "$OUTPUT" | grep -q "<promise>BLOCKED</promise>"; then
    echo "⛔️ Ralph blocked: agent reported a hard blocker that requires human action."
    exit 3
  fi

  # ------------------------------------------------------------------

  # Intelligent Exit Detection:
  # Require BOTH an explicit exit signal AND deterministic completion indicators.
  HAS_COMPLETE_PROMISE=false
  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    HAS_COMPLETE_PROMISE=true
  fi

  REMAINING_STORIES=""
  if [ -f "$PRD_FILE" ]; then
    REMAINING_STORIES="$(jq '[.userStories[] | select(.passes != true)] | length' "$PRD_FILE" 2>/dev/null || echo "")"
  fi

  if [ "$HAS_COMPLETE_PROMISE" = true ] && [ "$REMAINING_STORIES" = "0" ]; then
    echo ""
    echo "Ralph completed all tasks!"
    echo "Completed at iteration $i of $MAX_ITERATIONS"
    exit 0
  fi

  if [ "$HAS_COMPLETE_PROMISE" = true ] && [ -n "$REMAINING_STORIES" ] && [ "$REMAINING_STORIES" != "0" ]; then
    echo "⚠️ Warning: <promise>COMPLETE</promise> seen but prd.json still has $REMAINING_STORIES remaining story(ies). Continuing."
  fi

  echo "Iteration $i complete. Continuing..."
  sleep "$SLEEP_SECONDS"
done

echo ""
echo "Ralph reached max iterations ($MAX_ITERATIONS) without completing all tasks."
echo "Check $PROGRESS_FILE for status."
exit 1
