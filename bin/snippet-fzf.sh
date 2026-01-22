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

# Build the searchable index for fzf
build_index() {
  for path in "$SNIPPETS_DIR"/*.snip; do
    awk -v file="$(basename "$path" .snip)" '
      /^## / {
        if (in_snippet) {
          clean = body
          gsub(/\n+/, " ", clean)
          preview = substr(clean, 1, 80)
          print file "\t" title "\t" preview "\t" clean
        }
        title = substr($0, 4)
        body = ""
        in_snippet = 1
        next
      }

      in_snippet {
        body = body $0 "\n"
      }

      END {
        if (in_snippet) {
          clean = body
          gsub(/\n+/, " ", clean)
          preview = substr(clean, 1, 80)
          print file "\t" title "\t" preview "\t" clean
        }
      }
    ' "$path"
  done
}

# Run fzf and capture exit code
set +e
selection="$(
  build_index |
  fzf \
    --prompt="snippet> " \
    --delimiter='\t' \
    --with-nth=1,2,3
)"
fzf_status=$?
set -e

# If fzf was cancelled (Esc / Ctrl+C), exit silently
if [ "$fzf_status" -ne 0 ] || [ -z "$selection" ]; then
  exit 0
fi

# Extract the snippet category (file name)
category=$(cut -f1 <<<"$selection")

# Extract the snippet title
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
