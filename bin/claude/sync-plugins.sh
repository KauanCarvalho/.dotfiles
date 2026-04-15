#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
PLUGINS_FILE="$DOTFILES_DIR/claude/plugins.txt"
MARKETPLACES_FILE="$DOTFILES_DIR/claude/marketplaces.txt"
DEFAULT_MARKETPLACE="anthropics/claude-plugins-official"

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code not installed, skipping plugins sync"
  exit 0
fi

mkdir -p "$(dirname "$PLUGINS_FILE")"

echo "Syncing Claude Code marketplaces..."
claude plugin marketplace list 2>/dev/null \
  | grep -oP '(?<=GitHub \()[^)]+(?=\))' \
  | grep -v "^$DEFAULT_MARKETPLACE$" \
  | sort > "$MARKETPLACES_FILE"
echo "Marketplaces synced to $MARKETPLACES_FILE"

echo "Syncing Claude Code plugins..."
raw=$(claude plugin list 2>/dev/null)

if echo "$raw" | grep -qi "no plugins"; then
  echo "No plugins installed, clearing plugins file"
  > "$PLUGINS_FILE"
else
  echo "$raw" | grep '❯' | awk '{print $2}' | sort > "$PLUGINS_FILE"
fi

echo "Plugins synced to $PLUGINS_FILE"
