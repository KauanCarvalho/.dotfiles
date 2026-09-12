# VS Code

VS Code configuration is stored in `config/vscode` and linked to the expected
location under `~/.config/Code/User`.

## Extensions

Extensions are managed explicitly via a versioned list:

```
config/vscode/extensions.txt
```

Two helper scripts are provided.

Install extensions (dotfiles to machine):
```bash
bin/vscode/install-extensions.sh
```

Sync extensions (machine to dotfiles):
```bash
bin/vscode/sync-extensions.sh
```

Both scripts check if `code` is installed and are safe to run multiple times.
Extensions are not installed automatically by `setup.sh`. Cursor installs
from this same list via `bin/cursor/install-extensions.sh`. See
[Cursor](cursor.md).

## MCP servers

`config/vscode/mcp.json` is a symlink into the shared MCP source of truth.
See [AI-assisted tooling](ai-shared.md).

---

[Back to README](../README.md)
