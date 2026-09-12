# Go tooling

Go's version comes from `asdf` (see `.tool-versions` per project). This
covers the auxiliary binaries built with that toolchain: `gopls` (LSP),
`dlv` (debugger) and `golangci-lint`.

## Install

```bash
bin/go/install-tools.sh
```

Reads `default-go-tools` (one Go module path per line, same idea as
`default-gems` for Ruby) and runs `go install` for each, then
`asdf reshim golang` so the shims on `PATH` pick up the new binaries. Not run
automatically by `setup.sh`.

Requires the editor to inherit the shell's `PATH`: launch it from a terminal
(`code .` / `cursor .`) that already sourced `zshrc` and its asdf shims.
Launching from a desktop icon/dock skips that and `gopls` won't be found.

## VS Code / Cursor settings

In `config/vscode/settings.json`:

```json
"go.lintTool": "golangci-lint",
"go.lintOnSave": "package",
"gopls": {
  "staticcheck": true,
  "analyses": {
    "unusedparams": true,
    "shadow": true
  }
}
```

`golangci-lint` replaces the extension's default lint tool. `staticcheck`
and the extra `gopls` analyses are enabled on top of the default set.

---

[Back to README](../README.md)
