# Dotfiles

Personal dotfiles focused on a clean, keyboard-driven, terminal-first workflow.

This repository contains my daily-use configuration for shell, editor, terminal
and CLI tools. The goal is to keep everything minimal, readable and reproducible,
without unnecessary abstractions or hidden automation.

---

## What's included

### Shell

- zsh configuration
- aliases and environment defaults

### Editors

- **Neovim**: Lua-based config, no LSP setup. Used for small edits, git
  conflict resolution and commits, not as a full IDE. VS Code is the daily
  editor.
- **[VS Code](docs/vscode.md)**: settings, keybindings, snippets, versioned extensions.
- **[Claude Code](docs/claude-code.md)**: global settings, instructions, commands, agents, skills, plugins.
- **[Cursor](docs/cursor.md)**: MCP, global rules, editor settings/keybindings/snippets/extensions shared with VS Code.

### AI-assisted tooling

Claude Code, VS Code and Cursor share one source of truth instead of
duplicating config. See **[AI-assisted tooling](docs/ai-shared.md)** and
**[Local-only extras](docs/local-overrides.md)**, the `~/.zsh_env`-style
overlay for anything machine- or work-specific.

### Terminal

- Kitty configuration, Flexoki Dark color scheme.

### Multiplexer

- tmux configuration (modular), clipboard integration.

### CLI tools
- fzf integration, custom helper scripts.
- **[Go tooling](docs/go-tooling.md)**: gopls/dlv/golangci-lint, versioned like Ruby's default-gems.

---

## Repository structure

```
ai/              → all AI assistant config
  AGENTS.md      → shared instructions (imported by claude/CLAUDE.md via @)
  mcp/           → servers.json, shared MCP server config
  claude/        → Claude Code global configuration
  cursor/        → Cursor global configuration (mcp.json, rules)
bin/             → executable helper scripts
  claude/        → Claude Code helper scripts
  cursor/        → Cursor helper scripts
  go/            → Go tooling helper scripts
  vscode/        → VS Code helper scripts
config/          → XDG-compliant configs (nvim, kitty, vscode)
tmux/            → tmux configuration (modular)
snippets/        → custom snippets
default-go-tools → versioned list of go install targets (gopls, dlv, golangci-lint)
.github/         → this README + docs/
```

---

## Installation

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/KauanCarvalho/.dotfiles/main/bin/setup.sh)"
```

Safe to run multiple times. Full details, requirements and cleanup: see **[Installation](docs/installation.md)**.

---

## Documentation

| Doc | Scope |
|---|---|
| [Installation](docs/installation.md) | Setup script, requirements, cleanup |
| [VS Code](docs/vscode.md) | Config, extensions, MCP |
| [Claude Code](docs/claude-code.md) | Config, plugins, MCP |
| [Cursor](docs/cursor.md) | MCP, rules, editor settings, extensions |
| [AI-assisted tooling](docs/ai-shared.md) | Shared `AGENTS.md` and MCP servers across tools |
| [Local-only extras](docs/local-overrides.md) | Machine/work-specific overrides that never enter the repo |
| [Go tooling](docs/go-tooling.md) | gopls/dlv/golangci-lint install and VS Code/Cursor settings |

---

## Notes

- Clipboard integration is handled via tmux.
- VS Code forks (VSCodium, Antigravity Editor) use their own config paths and are
  intentionally not coupled to this setup. Cursor is the exception: it reuses
  `config/vscode` for editor settings, keybindings, snippets and extensions.
- Claude Code runtime data (`sessions/`, `cache/`, `history.jsonl`, etc.) is
  intentionally not synced. Only portable configuration is versioned.
- This repository reflects my personal workflow and evolves over time.
- Changes are added only when they provide clear, long-term value.

---

## License

MIT
