#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GIT_HOOKS_DIR="$ROOT_DIR/.git/hooks"

if [ ! -d "$GIT_HOOKS_DIR" ]; then
  echo "❌ .git/hooks not found. Run this from inside a git repository."
  exit 1
fi

install_hook() {
  local name="$1"
  local src="$ROOT_DIR/hooks/$name"
  local dst="$GIT_HOOKS_DIR/$name"

  if [ ! -f "$src" ]; then
    echo "❌ Missing hook script: $src"
    exit 1
  fi

  ln -sf "$src" "$dst"
  chmod +x "$src"
  echo "✅ Installed $name → .git/hooks/$name"
}

install_hook pre-commit
install_hook pre-push
