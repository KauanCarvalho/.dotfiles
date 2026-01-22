#! /usr/bin/env bash

set -eu pipefail

install_dotfiles () {
  dotfiles=( aliases asdfrc default-gems gemrc gitattributes gitignore solargraph.yml zshrc )

  for dotfile in "${dotfiles[@]}";
  do
    ln_file_to_home_directory "$dotfile"
  done
}

install_configs () {
  for dir in "$HOME/.dotfiles/config"/*; do
    echo "Installing $(basename "$dir")"

    install_config "$(basename "$dir")"
  done
}

install_config () {
  local source_full_path="$HOME/.dotfiles/config/$1"
  local target_full_path="$HOME/.config/$1"

  if [ -e "$target_full_path/.dotfile" ]; then
    echo "Removing existing $target_full_path folder"

    rm -rf "$target_full_path"
  elif [ -d "$target_full_path" ]; then
    echo "Backing up existing $target_full_path folder"

    mv "$target_full_path" "$target_full_path"_backup_"$(date +%s%3N)"
  fi

  mkdir -p "$target_full_path"
  touch "$target_full_path"/.dotfile

  ln -s "${source_full_path}"/* "${target_full_path}/"
}

ln_file_to_home_directory () {
  source_full_path="$HOME/.dotfiles/$1"
  target_full_path=${2:-"$HOME/.$1"}

  if [ -e "$target_full_path" ]; then
    echo "backing up $target_full_path"

    cp "$target_full_path" "${target_full_path}_backup_$(date +%s)"
  fi

  if [ -L "$target_full_path" ]; then
    echo "Removing existing symlink $target_full_path"

    rm "$target_full_path"
  fi

  ln -s "$source_full_path" "$target_full_path"
}

install_tmux () {
  local source="$HOME/.dotfiles/tmux/tmux.conf"
  local target="$HOME/.tmux.conf"
  local backup="${target}_backup_$(date +%Y%m%d_%H%M%S)"

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Backing up ~/.tmux.conf"

    cp -L "$target" "$backup"

    rm -f "$target"
  fi

  ln -s "$source" "$target"
}

install_vscode() {
  local vscode_config="$HOME/.config/vscode"
  local code_dir="$HOME/.config/Code"
  local code_user_dir="$code_dir/User"

  if [ ! -d "$vscode_config" ]; then
    echo "VS Code config not found, skipping"
    return 0
  fi

  if [ -e "$code_user_dir" ] && [ ! -L "$code_user_dir" ]; then
    echo "Backing up existing VS Code User directory"
    mv "$code_user_dir" "${code_user_dir}_backup_$(date +%s)"
  fi

  mkdir -p "$code_dir"
  ln -sfn "$vscode_config" "$code_user_dir"

  echo "VS Code config linked"
}

main() {
  if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/KauanCarvalho/.dotfiles.git "$HOME/.dotfiles"
  fi

  install_dotfiles
  install_configs
  install_tmux
  install_vscode

  echo "Finished installation"
}

main
