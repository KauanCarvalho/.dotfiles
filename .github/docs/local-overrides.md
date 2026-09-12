# Local-only extras

Some things are deliberately not part of this repo, the same way
`~/.zsh_env` is sourced by `zshrc` but never committed. This is for machine-
or work-specific content that shouldn't be shared or shouldn't be public.

| Extra | Where it lives | Picked up by |
|---|---|---|
| Local command/agent | `~/.claude/commands/*.md`, `~/.claude/agents/*.md` | Claude Code, automatically |
| Local skill | `~/.claude/skills/<name>/` | Claude Code, automatically |
| Local plugin/marketplace | `~/.claude/plugins.local.txt`, `~/.claude/marketplaces.local.txt` | `bin/claude/install-plugins.sh` |
| Local MCP server | `~/.claude/mcp.local.json` | `bin/claude/install-mcp.sh` |
| Local settings override | `~/.claude/settings.local.json` | Claude Code, automatically |
| Local Cursor command/agent/skill/rule | `~/.cursor/commands/`, `agents/`, `skills/`, `rules/` | Cursor, automatically |
| Local Cursor extension | `~/.cursor/extensions.local.txt` | `bin/cursor/install-extensions.sh` |

`commands/`, `agents/` and `skills/` (and Cursor's `rules/`) are real
directories with one symlink per shared item, not a single symlinked
directory. See [Claude Code](claude-code.md) and [Cursor](cursor.md). You can
drop an extra file or folder straight into `~/.claude/<dir>/` or
`~/.cursor/<dir>/` on any machine and it will never show up in `git status`
here.

The same applies to secrets: a MCP server that needs a token (e.g. a GitHub
PAT) belongs in `~/.claude/mcp.local.json`, never in `ai/mcp/servers.json`.
See [AI-assisted tooling](ai-shared.md).

---

[Back to README](../README.md)
