#!/usr/bin/env bash
# Ralph Parallel - Run multiple Ralph instances on independent stories concurrently
# Usage: ./scripts/ralph-parallel.sh [options]
#
# Options:
#   -w, --workers NUM      Number of parallel workers (default: 2)
#   -s, --stories ID,...   Comma-separated list of story IDs to run
#   -m, --max-iterations   Max iterations per worker (default: 10)
#   -h, --help             Show this help message
#
# Environment variables:
#   RALPH_PARALLEL_WORKERS      Default number of workers
#   RALPH_MAX_ITERATIONS        Max iterations per worker
#   RALPH_PROVIDER              AI provider to use
#
# Example:
#   ./scripts/ralph-parallel.sh -w 3 -s US-001,US-002,US-003

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PRD_FILE="$ROOT_DIR/prd.json"
PROGRESS_DIR="$ROOT_DIR/.agent/parallel"
MERGED_PROGRESS="$ROOT_DIR/progress.txt"

# Defaults
WORKERS="${RALPH_PARALLEL_WORKERS:-2}"
MAX_ITERATIONS="${RALPH_MAX_ITERATIONS:-10}"
STORY_IDS=""

usage() {
  head -20 "$0" | grep '^#' | sed 's/^# \?//'
  exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -w|--workers)
      WORKERS="$2"
      shift 2
      ;;
    -s|--stories)
      STORY_IDS="$2"
      shift 2
      ;;
    -m|--max-iterations)
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Validate prd.json exists
if [ ! -f "$PRD_FILE" ]; then
  echo "❌ Missing $PRD_FILE"
  echo "Create prd.json first (see prd.json.example)."
  exit 1
fi

# Check provider supports parallel
check_parallel_support() {
  local provider="${RALPH_PROVIDER:-amp}"
  local supports
  supports=$(jq -r ".providers[\"$provider\"].supportsParallel // true" "$ROOT_DIR/config/providers.json" 2>/dev/null || echo "true")
  
  if [ "$supports" = "false" ]; then
    echo "⚠️  Warning: Provider '$provider' does not officially support parallel execution."
    echo "   See config/providers.json for details."
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
}

# Get stories that are ready to work on (not yet passing)
get_available_stories() {
  jq -r '.userStories[] | select(.passes != true) | .id' "$PRD_FILE" 2>/dev/null
}

# Check if stories have dependencies that conflict
check_story_dependencies() {
  local story_list="$1"
  
  # Get files touched by each story (from notes field if present)
  # This is a basic check - stories should document their file dependencies
  local has_conflict=false
  local -a stories
  IFS=',' read -ra stories <<< "$story_list"
  
  for story in "${stories[@]}"; do
    local files
    files=$(jq -r --arg id "$story" '.userStories[] | select(.id == $id) | .touchesFiles // [] | .[]' "$PRD_FILE" 2>/dev/null || true)
    
    for other in "${stories[@]}"; do
      if [ "$story" != "$other" ]; then
        local other_files
        other_files=$(jq -r --arg id "$other" '.userStories[] | select(.id == $id) | .touchesFiles // [] | .[]' "$PRD_FILE" 2>/dev/null || true)
        
        # Check for overlapping files
        for f in $files; do
          if echo "$other_files" | grep -qx "$f"; then
            echo "⚠️  Warning: Stories $story and $other both touch file: $f"
            has_conflict=true
          fi
        done
      fi
    done
  done
  
  if [ "$has_conflict" = true ]; then
    echo ""
    echo "Stories that touch the same files should not run in parallel."
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
}

# Create a temporary prd.json with only the specified story
create_worker_prd() {
  local worker_id="$1"
  local story_id="$2"
  local worker_dir="$PROGRESS_DIR/worker-$worker_id"
  
  mkdir -p "$worker_dir"
  
  # Create prd.json with only this story
  jq --arg id "$story_id" '
    .userStories = [.userStories[] | select(.id == $id)] |
    .branchName = .branchName + "-worker-" + ($id | gsub("[^a-zA-Z0-9]"; "-"))
  ' "$PRD_FILE" > "$worker_dir/prd.json"
  
  # Initialize worker progress file
  echo "# Ralph Parallel Worker $worker_id - Story: $story_id" > "$worker_dir/progress.txt"
  echo "Started: $(date)" >> "$worker_dir/progress.txt"
  echo "---" >> "$worker_dir/progress.txt"
  
  echo "$worker_dir"
}

# Run a single worker
run_worker() {
  local worker_id="$1"
  local story_id="$2"
  local worker_dir="$3"
  
  echo "[Worker $worker_id] Starting work on story: $story_id"
  
  export RALPH_WORKER_ID="$worker_id"
  export RALPH_PARALLEL_MODE="1"
  
  # Run ralph.sh with the worker-specific prd.json
  (
    cd "$ROOT_DIR"
    
    # Override prd.json location for this worker
    PRD_FILE="$worker_dir/prd.json" \
    PROGRESS_FILE="$worker_dir/progress.txt" \
    RALPH_SESSION_ID="parallel-w${worker_id}-$(date +%Y%m%d-%H%M%S)" \
      "$ROOT_DIR/ralph.sh" "$MAX_ITERATIONS" 2>&1 | \
      sed "s/^/[W$worker_id] /"
  )
  
  local exit_code=$?
  echo "[Worker $worker_id] Completed with exit code: $exit_code"
  return $exit_code
}

# Merge worker progress files into main progress.txt
merge_progress() {
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  Merging Worker Progress Files"
  echo "═══════════════════════════════════════════════════════"
  
  # Backup existing progress
  if [ -f "$MERGED_PROGRESS" ]; then
    cp "$MERGED_PROGRESS" "$MERGED_PROGRESS.backup"
  fi
  
  # Append worker progress to main file
  echo "" >> "$MERGED_PROGRESS"
  echo "---" >> "$MERGED_PROGRESS"
  echo "# Parallel Execution Results - $(date)" >> "$MERGED_PROGRESS"
  
  for worker_dir in "$PROGRESS_DIR"/worker-*; do
    if [ -d "$worker_dir" ]; then
      local worker_id
      worker_id=$(basename "$worker_dir" | sed 's/worker-//')
      echo "" >> "$MERGED_PROGRESS"
      echo "## Worker $worker_id" >> "$MERGED_PROGRESS"
      
      if [ -f "$worker_dir/progress.txt" ]; then
        # Skip the header, append the content
        tail -n +4 "$worker_dir/progress.txt" >> "$MERGED_PROGRESS"
      fi
      
      # Update main prd.json with worker results
      if [ -f "$worker_dir/prd.json" ]; then
        local story_id
        story_id=$(jq -r '.userStories[0].id' "$worker_dir/prd.json")
        local passes
        passes=$(jq -r '.userStories[0].passes' "$worker_dir/prd.json")
        local notes
        notes=$(jq -r '.userStories[0].notes // ""' "$worker_dir/prd.json")
        
        if [ "$passes" = "true" ]; then
          # Update the main prd.json
          jq --arg id "$story_id" --arg notes "$notes" '
            .userStories = [.userStories[] | 
              if .id == $id then .passes = true | .notes = $notes else . end
            ]
          ' "$PRD_FILE" > "$PRD_FILE.tmp" && mv "$PRD_FILE.tmp" "$PRD_FILE"
          echo "  ✅ Story $story_id: PASSED"
        else
          echo "  ❌ Story $story_id: NOT COMPLETED"
        fi
      fi
    fi
  done
  
  echo ""
  echo "Progress merged to: $MERGED_PROGRESS"
}

# Print summary
print_summary() {
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  Parallel Execution Summary"
  echo "═══════════════════════════════════════════════════════"
  
  local total=0
  local passed=0
  
  for worker_dir in "$PROGRESS_DIR"/worker-*; do
    if [ -d "$worker_dir" ] && [ -f "$worker_dir/prd.json" ]; then
      total=$((total + 1))
      if jq -e '.userStories[0].passes == true' "$worker_dir/prd.json" >/dev/null 2>&1; then
        passed=$((passed + 1))
      fi
    fi
  done
  
  echo "Workers: $total"
  echo "Stories Completed: $passed / $total"
  
  if [ "$passed" -eq "$total" ]; then
    echo ""
    echo "✅ All parallel stories completed successfully!"
    return 0
  else
    echo ""
    echo "⚠️  Some stories did not complete. Check worker logs in $PROGRESS_DIR"
    return 1
  fi
}

# Main execution
main() {
  echo "═══════════════════════════════════════════════════════"
  echo "  Ralph Parallel Execution"
  echo "═══════════════════════════════════════════════════════"
  echo ""
  
  check_parallel_support
  
  # Get stories to process
  local -a stories
  if [ -n "$STORY_IDS" ]; then
    IFS=',' read -ra stories <<< "$STORY_IDS"
  else
    mapfile -t stories < <(get_available_stories | head -n "$WORKERS")
  fi
  
  if [ ${#stories[@]} -eq 0 ]; then
    echo "No stories available to process."
    echo "All stories in prd.json may already be passing."
    exit 0
  fi
  
  echo "Stories to process: ${stories[*]}"
  echo "Workers: $WORKERS"
  echo "Max iterations per worker: $MAX_ITERATIONS"
  echo ""
  
  # Check for dependency conflicts
  check_story_dependencies "$(IFS=','; echo "${stories[*]}")"
  
  # Clean up previous parallel run
  rm -rf "$PROGRESS_DIR"
  mkdir -p "$PROGRESS_DIR"
  
  # Start workers
  local -a pids=()
  local -a worker_dirs=()
  local worker_id=1
  
  for story_id in "${stories[@]}"; do
    if [ $worker_id -gt "$WORKERS" ]; then
      break
    fi
    
    local worker_dir
    worker_dir=$(create_worker_prd "$worker_id" "$story_id")
    worker_dirs+=("$worker_dir")
    
    run_worker "$worker_id" "$story_id" "$worker_dir" &
    pids+=($!)
    
    worker_id=$((worker_id + 1))
  done
  
  echo ""
  echo "Started ${#pids[@]} parallel workers. Waiting for completion..."
  echo ""
  
  # Wait for all workers
  local exit_codes=()
  for pid in "${pids[@]}"; do
    wait "$pid" || true
    exit_codes+=($?)
  done
  
  # Merge results
  merge_progress
  
  # Print summary
  print_summary
}

main "$@"
