# AI-assisted tooling

All AI assistant config lives under `ai/`. Claude Code, VS Code and Cursor
read from the same source instead of duplicating config per tool.

## Instructions: `ai/AGENTS.md`

General instructions live in one file. `ai/claude/CLAUDE.md` contains a
single line: `@~/.dotfiles/ai/AGENTS.md`. Claude Code resolves this import
at read time.

Cursor and other AGENTS.md-aware tools read `ai/AGENTS.md` directly when
it's present at a project's root. Globally, Cursor loads
`ai/cursor/rules/agents.mdc` (linked into `~/.cursor/rules/`), pointing at
the same `ai/AGENTS.md`. Extra User Rules typed in the Cursor UI stay
machine-local.

## MCP servers: `ai/mcp/servers.json`

VS Code (`config/vscode/mcp.json`) and Cursor (`ai/cursor/mcp.json`) read
this file directly via symlink.

Claude Code doesn't read `mcpServers` from a plain file. Servers are
registered through `claude mcp add`. Run:

```bash
bin/claude/install-mcp.sh
```

This reads `ai/mcp/servers.json` and registers each entry with
`claude mcp add-json ... -s user`, skipping ones already configured. Paths
using Cursor/VS Code interpolation (`${userHome}`, `${env:HOME}`) are
expanded to `$HOME` first. Not run automatically by `setup.sh`. Verify with
`claude mcp list`.

Only put servers here with no secrets embedded. See
[Local-only extras](local-overrides.md) for anything work-specific or that
needs a token/PAT.

---

[Back to README](../README.md)
