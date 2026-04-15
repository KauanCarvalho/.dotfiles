#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_SRC="$DOTFILES_DIR/config"
CONFIG_DST="$HOME/.config"

timestamp() {
  date +%Y%m%d_%H%M%S
}

backup() {
  local target="$1"
  echo "Backing up $target"
  mv "$target" "${target}_backup_$(timestamp)"
}

link() {
  local source="$1"
  local target="$2"

  ln -s "$source" "$target"
}

install_config() {
  local name="$1"
  local source="$CONFIG_SRC/$name"
  local target="$CONFIG_DST/$name"

  if [ ! -e "$source" ]; then
    echo "Skipping $name (not found in dotfiles)"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup "$target"
  fi

  link "$source" "$target"
  echo "Installed $name"
}

install_configs() {
  mkdir -p "$CONFIG_DST"

  for path in "$CONFIG_SRC"/*; do
    install_config "$(basename "$path")"
  done
}

install_home_dotfile() {
  local name="$1"
  local source="$DOTFILES_DIR/$name"
  local target="$HOME/.$name"

  if [ ! -e "$source" ]; then
    echo "Skipping .$name (not found)"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup "$target"
  fi

  link "$source" "$target"
  echo "Installed .$name"
}

install_home_dotfiles() {
  local dotfiles=(
    aliases
    asdfrc
    default-gems
    gemrc
    gitattributes
    gitignore
    solargraph.yml
    zshrc
  )

  for file in "${dotfiles[@]}"; do
    install_home_dotfile "$file"
  done
}

install_tmux() {
  local source="$DOTFILES_DIR/tmux/tmux.conf"
  local target="$HOME/.tmux.conf"

  if [ ! -e "$source" ]; then
    echo "Skipping tmux (not found)"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup "$target"
  fi

  link "$source" "$target"
  echo "Installed tmux"
}

install_claude() {
  local claude_src="$DOTFILES_DIR/claude"
  local claude_dst="$HOME/.claude"

  if [ ! -d "$claude_src" ]; then
    echo "Skipping Claude Code (not found)"
    return
  fi

  mkdir -p "$claude_dst"

  for item in settings.json CLAUDE.md commands agents statusline-command.sh; do
    local source="$claude_src/$item"
    local target="$claude_dst/$item"

    if [ ! -e "$source" ]; then
      continue
    fi

    if [ -L "$target" ]; then
      echo "Claude $item already linked"
      continue
    fi

    if [ -e "$target" ]; then
      backup "$target"
    fi

    link "$source" "$target"
    echo "Installed Claude $item"
  done
}

install_vscode() {
  local source="$CONFIG_SRC/vscode"
  local target="$HOME/.config/Code/User"

  if [ ! -d "$source" ]; then
    echo "Skipping VS Code (not found)"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup "$target"
  fi

  mkdir -p "$(dirname "$target")"
  link "$source" "$target"
  echo "Installed VS Code"
}

clone_dotfiles() {
  if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles..."
    git clone https://github.com/KauanCarvalho/.dotfiles.git "$DOTFILES_DIR"
  fi
}

main() {
  clone_dotfiles

  install_home_dotfiles
  install_configs
  install_tmux
  install_vscode
  install_claude

  echo "Dotfiles installation complete"
}

main
