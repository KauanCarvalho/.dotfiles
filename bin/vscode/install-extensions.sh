#!/usr/bin/env bash

set -e

EXTENSIONS_FILE="$HOME/.dotfiles/config/vscode/extensions.txt"

if ! command -v code >/dev/null 2>&1; then
  echo "VS Code not installed, skipping extensions install"
  exit 0
fi

if [ ! -f "$EXTENSIONS_FILE" ]; then
  echo "No VS Code extensions file found"
  exit 0
fi

echo "Installing VS Code extensions..."

while read -r extension; do
  [ -z "$extension" ] && continue
  echo "→ Installing extension: $extension"
  code --install-extension "$extension" --force
done < "$EXTENSIONS_FILE"

echo "VS Code extensions installed"
