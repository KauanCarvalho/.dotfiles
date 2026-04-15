#!/usr/bin/env bash

set -e

# Directory where all .snip files are stored
SNIPPETS_DIR="$HOME/.dotfiles/snippets"

# Copy stdin to system clipboard
# Supports Wayland (wl-copy), X11 (xclip) and macOS (pbcopy)
copy_to_clipboard() {
  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  elif command -v pbcopy >/dev/null 2>&1; then
    pbcopy
  else
    echo "No clipboard tool found" >&2
    exit 1
  fi
}

# Build the searchable index for fzf (file TAB title)
build_index() {
  local found=0
  for path in "$SNIPPETS_DIR"/*.snip; do
    [ -e "$path" ] || continue
    found=1
    awk -v file="$(basename "$path" .snip)" '
      /^## / {
        if (in_snippet) print file "\t" title
        title = substr($0, 4)
        in_snippet = 1
        next
      }
      END {
        if (in_snippet) print file "\t" title
      }
    ' "$path"
  done
  [ "$found" -eq 1 ] || { echo "No snippets found in $SNIPPETS_DIR" >&2; exit 1; }
}

# Run fzf with a live preview panel showing the full snippet content
set +e
selection="$(
  build_index |
  fzf \
    --prompt="snippet> " \
    --delimiter='\t' \
    --with-nth=1,2 \
    --preview="
      file=\$(printf '%s' {} | cut -f1)
      title=\$(printf '%s' {} | cut -f2)
      awk -v t=\"\$title\" '
        /^\#\# / { found = (\$0 == \"## \" t); next }
        found { print }
      ' \"$SNIPPETS_DIR/\$file.snip\"
    " \
    --preview-window=right:50%:wrap
)"
fzf_status=$?
set -e

# If fzf was cancelled (Esc / Ctrl+C), exit silently
if [ "$fzf_status" -ne 0 ] || [ -z "$selection" ]; then
  exit 0
fi

# Extract file and title from selection
category=$(cut -f1 <<<"$selection")
title=$(cut -f2 <<<"$selection")

# Extract the exact snippet content from the source file
snippet="$(
  awk -v title="$title" '
    /^## / {
      if ($0 == "## " title) {
        found = 1
        next
      }
      if (found) exit
    }
    found { print }
  ' "$SNIPPETS_DIR/$category.snip"
)"

# Remove all trailing newline characters
snippet="${snippet%"${snippet##*[!$'\n']}"}"

# If running inside tmux, paste directly into the original pane
if [ -n "$TMUX" ]; then
  printf '%s' "$snippet" | tmux load-buffer -
  tmux paste-buffer -p -t "$TMUX_PANE"
else
  # Fallback for non-tmux environments
  printf '%s' "$snippet" | copy_to_clipboard
fi
