#!/usr/bin/env bash

set -e

EXTENSIONS_FILE="$HOME/.dotfiles/config/vscode/extensions.txt"
LOCAL_EXTENSIONS_FILE="$HOME/.cursor/extensions.local.txt"

if ! command -v cursor >/dev/null 2>&1; then
  echo "Cursor not installed, skipping extensions install"

  exit 0
fi

install_from() {
  local file="$1"

  [ -f "$file" ] || return 0

  while read -r extension; do
    [ -z "$extension" ] && continue

    echo "→ Installing extension: $extension"

    cursor --install-extension "$extension" --force
  done < "$file"
}

echo "Installing Cursor extensions..."

install_from "$EXTENSIONS_FILE"
install_from "$LOCAL_EXTENSIONS_FILE"

echo "Cursor extensions installed"
