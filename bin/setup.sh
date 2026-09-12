#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

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

link_dir_item() {
  local source="$1"
  local target="$2"

  if [ -L "$target" ]; then
    if [ "$(readlink "$target")" = "$source" ]; then
      echo "$(basename "$target") already linked"
      return
    fi
    echo "$(basename "$target") points elsewhere, relinking"
    rm "$target"
  elif [ -e "$target" ]; then
    backup "$target"
  fi

  link "$source" "$target"
  echo "Installed $(basename "$target")"
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
  local claude_src="$DOTFILES_DIR/ai/claude"
  local claude_dst="$HOME/.claude"

  if [ ! -d "$claude_src" ]; then
    echo "Skipping Claude Code (not found)"
    return
  fi

  mkdir -p "$claude_dst"

  for item in settings.json CLAUDE.md statusline-command.sh; do
    if [ ! -e "$claude_src/$item" ]; then
      continue
    fi

    link_dir_item "$claude_src/$item" "$claude_dst/$item"
  done

  for dir in commands agents skills; do
    install_subdir_items "$claude_src/$dir" "$claude_dst/$dir" "Claude $dir"
  done
}

install_subdir_items() {
  local source_dir="$1"
  local target_dir="$2"
  local label="$3"

  if [ ! -d "$source_dir" ]; then
    return
  fi

  if [ -L "$target_dir" ]; then
    echo "Migrating $label from whole-dir symlink to per-item links"
    backup "$target_dir"
  fi

  mkdir -p "$target_dir"

  for path in "$source_dir"/*; do
    link_dir_item "$path" "$target_dir/$(basename "$path")"
  done
}

install_cursor() {
  local cursor_src="$DOTFILES_DIR/ai/cursor"
  local cursor_dst="$HOME/.cursor"

  if [ ! -d "$cursor_src" ]; then
    echo "Skipping Cursor (not found)"
    return
  fi

  mkdir -p "$cursor_dst"

  for path in "$cursor_src"/*; do
    local name
    name="$(basename "$path")"
    case "$name" in
      commands|agents|skills|rules)
        continue
        ;;
    esac
    link_dir_item "$path" "$cursor_dst/$name"
  done

  for dir in commands agents skills rules; do
    install_subdir_items "$cursor_src/$dir" "$cursor_dst/$dir" "Cursor $dir"
  done

  install_cursor_editor
}

install_cursor_editor() {
  local vscode_src="$CONFIG_SRC/vscode"
  local cursor_user="$HOME/.config/Cursor/User"

  if [ ! -d "$vscode_src" ]; then
    echo "Skipping Cursor editor settings (VS Code config not found)"
    return
  fi

  mkdir -p "$cursor_user"

  for item in settings.json keybindings.json; do
    if [ ! -e "$vscode_src/$item" ]; then
      continue
    fi
    link_dir_item "$vscode_src/$item" "$cursor_user/$item"
  done

  if [ -d "$vscode_src/snippets" ]; then
    mkdir -p "$cursor_user/snippets"
    for path in "$vscode_src/snippets"/*; do
      link_dir_item "$path" "$cursor_user/snippets/$(basename "$path")"
    done
  fi
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
  install_cursor
  install_claude

  echo "Dotfiles installation complete"
}

main
