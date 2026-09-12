#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CLAUDE_DIR="$HOME/.claude"
PLUGINS_FILE="$DOTFILES_DIR/ai/claude/plugins.txt"
MARKETPLACES_FILE="$DOTFILES_DIR/ai/claude/marketplaces.txt"
LOCAL_PLUGINS_FILE="$CLAUDE_DIR/plugins.local.txt"
LOCAL_MARKETPLACES_FILE="$CLAUDE_DIR/marketplaces.local.txt"

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code not installed, skipping plugins install"
  exit 0
fi

add_marketplaces() {
  local file="$1"

  [ -f "$file" ] || return 0

  echo "Adding Claude Code marketplaces from $file..."
  while read -r marketplace; do
    [ -z "$marketplace" ] && continue
    echo "→ Adding marketplace: $marketplace"
    claude plugin marketplace add "$marketplace"
  done < "$file"
}

install_plugins() {
  local file="$1"

  [ -f "$file" ] || return 0

  echo "Installing Claude Code plugins from $file..."
  while read -r plugin; do
    [ -z "$plugin" ] && continue
    echo "→ Installing plugin: $plugin"
    claude plugin install "$plugin"
  done < "$file"
}

add_marketplaces "$MARKETPLACES_FILE"
add_marketplaces "$LOCAL_MARKETPLACES_FILE"
install_plugins "$PLUGINS_FILE"
install_plugins "$LOCAL_PLUGINS_FILE"

echo "Claude Code plugins installed"
