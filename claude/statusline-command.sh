#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

user=$(whoami)
host=$(hostname -s)

prompt=$(printf "\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m" "$user" "$host" "$cwd")

extras=""
[ -n "$model" ] && extras="$model"
[ -n "$used" ] && extras="$extras ctx:$(printf '%.0f' "$used")%"

if [ -n "$extras" ]; then
  printf "%s [%s]" "$prompt" "$extras"
else
  printf "%s" "$prompt"
fi
