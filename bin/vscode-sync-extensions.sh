#!/usr/bin/env bash

set -e

EXTENSIONS_FILE="$HOME/.dotfiles/config/vscode/extensions.txt"

if ! command -v code >/dev/null 2>&1; then
  echo "VS Code not installed, skipping extensions sync"
  exit 0
fi

mkdir -p "$(dirname "$EXTENSIONS_FILE")"

echo "Syncing VS Code extensions..."
code --list-extensions | sort > "$EXTENSIONS_FILE"

echo "VS Code extensions synced to $EXTENSIONS_FILE"
