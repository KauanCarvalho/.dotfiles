#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
PLUGINS_FILE="$DOTFILES_DIR/claude/plugins.txt"
MARKETPLACES_FILE="$DOTFILES_DIR/claude/marketplaces.txt"

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code not installed, skipping plugins install"
  exit 0
fi

if [ -f "$MARKETPLACES_FILE" ]; then
  echo "Adding Claude Code marketplaces..."
  while read -r marketplace; do
    [ -z "$marketplace" ] && continue
    echo "→ Adding marketplace: $marketplace"
    claude plugin marketplace add "$marketplace"
  done < "$MARKETPLACES_FILE"
fi

if [ ! -f "$PLUGINS_FILE" ]; then
  echo "No Claude Code plugins file found"
  exit 0
fi

echo "Installing Claude Code plugins..."
while read -r plugin; do
  [ -z "$plugin" ] && continue
  echo "→ Installing plugin: $plugin"
  claude plugin install "$plugin"
done < "$PLUGINS_FILE"

echo "Claude Code plugins installed"
