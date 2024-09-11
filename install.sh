#! /usr/bin/env bash

set -eu pipefail

install_dotfiles () {
  dotfiles=( aliases asdfrc default-gems gemrc gitattributes zshrc )

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

main() {
  if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/KauanCarvalho/.dotfiles.git "$HOME/.dotfiles"
  fi

  install_dotfiles
  install_configs

  echo "Finished installation"
}

main

