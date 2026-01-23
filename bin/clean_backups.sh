#!/usr/bin/env bash

set -euo pipefail

cleanup_backups() {
  local backups

  backups=$(find "$HOME" \
    -type d -name "*_backup_*" \
    -o -type f -name "*_backup_*" 2>/dev/null)

  if [ -z "$backups" ]; then
    echo "No backups found."
    return 0
  fi

  echo "Backups found:"
  echo "$backups"
  echo

  read -r -p "Remove ALL backups listed above? [y/N] " confirm
  if [ "$confirm" = "y" ]; then
    rm -rf $backups
    echo "Backups removed."
  else
    echo "Aborted."
  fi
}

cleanup_backups
