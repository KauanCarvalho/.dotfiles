#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
TOOLS_FILE="$DOTFILES_DIR/default-go-tools"

if ! command -v go >/dev/null 2>&1; then
  echo "Go not installed, skipping tools install"
  exit 0
fi

if [ ! -f "$TOOLS_FILE" ]; then
  echo "No default-go-tools file found"
  exit 0
fi

echo "Installing Go tools..."
while read -r tool; do
  [ -z "$tool" ] && continue
  echo "→ Installing: $tool"
  go install "$tool"
done < "$TOOLS_FILE"

# Tools land in GOBIN/shims managed by asdf's golang plugin — without a
# reshim the new binaries stay invisible to the shim wrappers on PATH.
if command -v asdf >/dev/null 2>&1 && asdf plugin list 2>/dev/null | grep -qx golang; then
  echo "Reshimming asdf golang..."
  asdf reshim golang
fi

echo "Go tools installed"
