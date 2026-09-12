#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"
CLAUDE_DIR="$HOME/.claude"
SERVERS_FILE="$DOTFILES_DIR/ai/mcp/servers.json"
LOCAL_SERVERS_FILE="$CLAUDE_DIR/mcp.local.json"

if ! command -v claude >/dev/null 2>&1; then
  echo "Claude Code not installed, skipping MCP install"
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq not installed, skipping MCP install"
  exit 0
fi

add_servers() {
  local file="$1"

  [ -f "$file" ] || return 0

  echo "Adding Claude Code MCP servers from $file..."

  local names
  names=$(jq -r '.mcpServers // {} | keys[]' "$file")

  while read -r name; do
    [ -z "$name" ] && continue

    if claude mcp get "$name" >/dev/null 2>&1; then
      echo "→ $name already configured, skipping"
      continue
    fi

    local config
    config=$(jq -c --arg name "$name" '.mcpServers[$name]' "$file")
    config="${config//\$\{userHome\}/$HOME}"
    config="${config//\$\{env:HOME\}/$HOME}"
    echo "→ Adding MCP server: $name"
    claude mcp add-json "$name" "$config" -s user
  done <<< "$names"
}

add_servers "$SERVERS_FILE"
add_servers "$LOCAL_SERVERS_FILE"

echo "Claude Code MCP servers installed"
