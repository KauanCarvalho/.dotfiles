#!/usr/bin/env bash

set -eu

cleanup_backups() {
  local backups

  backups=$(find "$HOME" -maxdepth 1 -type f -name ".*_backup_*")

  if [ -z "$backups" ]; then
    echo "No backup files found."
    return 0
  fi

  echo "Backup files found:"
  echo "$backups"
  echo

  read -r -p "Remove all backups? [y/N] " confirm
  if [ "$confirm" = "y" ]; then
    rm -f $backups
    echo "Backups removed."
  else
    echo "Aborted."
  fi
}

main() {
  cleanup_backups
}

main
