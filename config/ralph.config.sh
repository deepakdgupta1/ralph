#!/bin/bash
# =============================================================================
# Ralph Configuration Loader
# =============================================================================
# Loads provider-specific configuration from providers.json and exports
# standardized environment variables for use by ralph.sh.
#
# Usage:
#   source config/ralph.config.sh
#   load_provider_config
#
# Environment Variables:
#   RALPH_PROVIDER   - Select provider (amp, claude-code, antigravity, codex)
#                      Default: amp (for backward compatibility)
#   RALPH_SANDBOXED  - Set to 1 to use sandboxedFlags instead of defaultFlags
#                      Default: 0 (full autonomy mode)
#
# Exported Variables (after load_provider_config):
#   RALPH_PROVIDER_NAME  - Human-readable provider name
#   RALPH_AGENT_CMD      - Base command to invoke the agent
#   RALPH_AGENT_FLAGS    - Flags for execution (sandboxed or default)
#   RALPH_SKILLS_DIR     - Unified skills directory
#   RALPH_PROVIDER_DOCS  - Documentation URL
#   RALPH_SANDBOXED      - Whether sandboxed mode is active (0 or 1)
# =============================================================================

set -e

# Directory containing this script
RALPH_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROVIDERS_FILE="$RALPH_CONFIG_DIR/providers.json"

# -----------------------------------------------------------------------------
# load_provider_config
# -----------------------------------------------------------------------------
# Reads provider settings from providers.json and exports unified env vars.
# Call this function after sourcing this file.
# -----------------------------------------------------------------------------
load_provider_config() {
  # Check if jq is available
  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required for provider configuration. Install with: brew install jq (macOS) or apt install jq (Linux)" >&2
    exit 1
  fi

  # Check if providers.json exists
  if [ ! -f "$PROVIDERS_FILE" ]; then
    echo "Error: Provider configuration not found at $PROVIDERS_FILE" >&2
    exit 1
  fi

  # Select provider (env var or default from JSON)
  local default_provider
  default_provider="$(jq -r '.default // "amp"' "$PROVIDERS_FILE")"
  export RALPH_PROVIDER="${RALPH_PROVIDER:-$default_provider}"

  # Sandboxed mode (default: 0 = full autonomy)
  export RALPH_SANDBOXED="${RALPH_SANDBOXED:-0}"

  # Validate provider exists
  if ! jq -e ".providers[\"$RALPH_PROVIDER\"]" "$PROVIDERS_FILE" >/dev/null 2>&1; then
    local available
    available="$(jq -r '.providers | keys | join(", ")' "$PROVIDERS_FILE")"
    echo "Error: Unknown provider '$RALPH_PROVIDER'. Available providers: $available" >&2
    exit 1
  fi

  # Export provider configuration
  export RALPH_PROVIDER_NAME="$(jq -r ".providers[\"$RALPH_PROVIDER\"].name" "$PROVIDERS_FILE")"
  export RALPH_AGENT_CMD="$(jq -r ".providers[\"$RALPH_PROVIDER\"].command" "$PROVIDERS_FILE")"
  
  # Select flags based on sandboxed mode
  if [ "$RALPH_SANDBOXED" = "1" ]; then
    export RALPH_AGENT_FLAGS="$(jq -r ".providers[\"$RALPH_PROVIDER\"].sandboxedFlags | join(\" \")" "$PROVIDERS_FILE")"
  else
    export RALPH_AGENT_FLAGS="$(jq -r ".providers[\"$RALPH_PROVIDER\"].defaultFlags | join(\" \")" "$PROVIDERS_FILE")"
  fi
  
  export RALPH_SKILLS_DIR="$(jq -r ".providers[\"$RALPH_PROVIDER\"].skillsDir // \"~/.ralph/skills\"" "$PROVIDERS_FILE")"
  export RALPH_PROVIDER_DOCS="$(jq -r ".providers[\"$RALPH_PROVIDER\"].documentation // \"\"" "$PROVIDERS_FILE")"

  # Expand tilde in skills dir
  RALPH_SKILLS_DIR="${RALPH_SKILLS_DIR/#\~/$HOME}"
  export RALPH_SKILLS_DIR
}

# -----------------------------------------------------------------------------
# build_agent_command
# -----------------------------------------------------------------------------
# Builds the AGENT_CMD array for executing the AI agent.
# Sets global array: AGENT_CMD
#
# Usage:
#   build_agent_command
#   "${AGENT_CMD[@]}" < prompt
# -----------------------------------------------------------------------------
build_agent_command() {
  # Split flags string into array (handles quoted strings correctly)
  local cmd="$RALPH_AGENT_CMD"
  local flags="$RALPH_AGENT_FLAGS"
  
  # Build command array
  # shellcheck disable=SC2206
  AGENT_CMD=($cmd $flags)
  
  # Add timeout wrapper if available and configured
  if [ -n "${ITERATION_TIMEOUT_MINUTES:-}" ]; then
    if command -v timeout >/dev/null 2>&1; then
      AGENT_CMD=(timeout --preserve-status "${ITERATION_TIMEOUT_MINUTES}m" "${AGENT_CMD[@]}")
    fi
  fi
}

# -----------------------------------------------------------------------------
# print_provider_info
# -----------------------------------------------------------------------------
# Displays current provider configuration (for debugging/info).
# -----------------------------------------------------------------------------
print_provider_info() {
  echo "Provider: $RALPH_PROVIDER_NAME ($RALPH_PROVIDER)"
  if [ "$RALPH_SANDBOXED" = "1" ]; then
    echo "Mode: SANDBOXED (permission allowlists)"
  else
    echo "Mode: Full autonomy"
  fi
  echo "Command: $RALPH_AGENT_CMD $RALPH_AGENT_FLAGS"
  echo "Skills: $RALPH_SKILLS_DIR"
  [ -n "$RALPH_PROVIDER_DOCS" ] && echo "Docs: $RALPH_PROVIDER_DOCS"
}
