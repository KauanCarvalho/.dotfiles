# Claude Code

Claude Code configuration is stored in `ai/claude/` and linked individually
into `~/.claude/`. The directory is not linked as a whole, since it also
contains local runtime data such as sessions, cache and history.

`commands/`, `agents/` and `skills/` are linked item-by-item: each file (or,
for skills, each subfolder) gets its own symlink inside a real
`~/.claude/<dir>` directory. See [Local-only extras](local-overrides.md).

## What is synced

| File/Dir | Purpose |
|---|---|
| `settings.json` | Global settings, permissions, MCP servers, hooks |
| `CLAUDE.md` | `@~/.dotfiles/ai/AGENTS.md` import, global instructions for the assistant |
| `commands/` | Custom slash commands (one `.md` file per command) |
| `agents/` | Custom subagent definitions |
| `skills/` | Custom skills (one folder per skill, each with a `SKILL.md`) |
| `statusline-command.sh` | Shell script powering the Claude Code status line |
| `plugins.txt` | List of installed plugins |
| `marketplaces.txt` | List of third-party plugin marketplaces |

## Plugins

Plugins are managed via versioned lists and two helper scripts.

Install plugins (dotfiles to machine):

```bash
bin/claude/install-plugins.sh
```
Adds all marketplaces first, then installs all plugins. Also picks up
`~/.claude/plugins.local.txt` / `~/.claude/marketplaces.local.txt` if
present. See [Local-only extras](local-overrides.md).

Sync plugins (machine to dotfiles):

```bash
bin/claude/sync-plugins.sh
```

Exports currently installed marketplaces and plugins to their respective
files. Only shared ones; local-only files are never touched by this script
and must be edited by hand. Only exports plugins that are enabled and
user-scoped.

Plugins are not installed automatically by `setup.sh`.

## MCP servers

Claude Code doesn't read `mcpServers` from a plain file like VS Code and
Cursor do. `bin/claude/install-mcp.sh` bridges that. See
[AI-assisted tooling](ai-shared.md).

---

[Back to README](../README.md)
