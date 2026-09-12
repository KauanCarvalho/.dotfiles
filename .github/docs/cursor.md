# Cursor

Cursor has two config surfaces. Agent/MCP config lives in `ai/cursor/` and is
linked item-by-item into `~/.cursor/`. Editor settings reuse
[VS Code](vscode.md) (`config/vscode`) and are linked into
`~/.config/Cursor/User`, not the whole `~/.config/Cursor` directory (which
also holds cache and UI state).

## What is synced

| File/Dir | Purpose |
|---|---|
| `ai/cursor/mcp.json` | Symlink to shared MCP servers. See [AI-assisted tooling](ai-shared.md) |
| `ai/cursor/rules/` | User-level rules (one `.mdc` file per rule), including the pointer at `ai/AGENTS.md` |
| `config/vscode/settings.json` | Editor settings (shared with VS Code) |
| `config/vscode/keybindings.json` | Keybindings (shared with VS Code) |
| `config/vscode/snippets/` | Snippets, linked item-by-item (shared with VS Code) |
| `config/vscode/extensions.txt` | Extension list (shared with VS Code) |

`commands/`, `agents/`, `skills/` and `rules/` are linked item-by-item inside
a real `~/.cursor/<dir>` directory. See
[Local-only extras](local-overrides.md).

Runtime data under `~/.cursor/` (`projects/`, `ai-tracking/`, `argv.json`,
installed extensions, and so on) is not versioned.

## Extensions

The shared list is `config/vscode/extensions.txt`. Install into Cursor with:

```
bin/cursor/install-extensions.sh
```

Safe to run multiple times. Not run automatically by `setup.sh`. Cursor-only
extensions belong in `~/.cursor/extensions.local.txt`. See
[Local-only extras](local-overrides.md). To refresh the shared list from VS
Code, use `bin/vscode/sync-extensions.sh`.

## MCP servers

`ai/cursor/mcp.json` is a symlink into the shared MCP source of truth. See
[AI-assisted tooling](ai-shared.md).

---

[Back to README](../README.md)
