# codebase_memory_mcp role

Installs [codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp),
an MCP server that builds a knowledge graph of the codebase for coding agents.

All platforms use the official release tarball. The role extracts it to a
temporary directory and runs the binary's own `install` subcommand, which:

- copies the binary to `~/.local/bin/codebase-memory-mcp` (per-user, no root),
- registers the MCP server with every coding agent it detects (Claude Code,
  Codex CLI, VS Code, …) — MCP entries, instruction files, skills, and hooks,
- adds `~/.local/bin` to `PATH` in `~/.zshrc` if it isn't there already.

Because of the agent auto-detection, `provision.sh` places this role **after**
`claude_code` and `codex`, so those agents exist by the time registration runs.

The role stays idempotent by only reinstalling when the running
`codebase-memory-mcp --version` doesn't match `codebase_memory_mcp_version`.
Note that the `ui` and headless builds report the same version, so toggling
`codebase_memory_mcp_ui` alone won't trigger a reinstall — remove
`~/.local/bin/codebase-memory-mcp` first to switch builds.

## Variables

| Variable                            | Default                            | Description                                                     |
| ----------------------------------- | ---------------------------------- | --------------------------------------------------------------- |
| `codebase_memory_mcp_version`       | `0.9.0`                            | Release to install.                                             |
| `codebase_memory_mcp_ui`            | `true`                             | Install the `ui` build with the embedded 3D graph frontend      |
|                                     |                                    | (`codebase-memory-mcp --ui=true --port=9749`, then open         |
|                                     |                                    | `http://localhost:9749`). `false` installs the headless build.  |
| `codebase_memory_mcp_bin`           | `~/.local/bin/codebase-memory-mcp` | Where the `install` subcommand puts the binary.                 |
| `codebase_memory_mcp_variant`       | derived                            | Release asset family, from `codebase_memory_mcp_ui`.            |
| `codebase_memory_mcp_os`            | derived                            | `darwin` or `linux`, from the host system.                      |
| `codebase_memory_mcp_arch`          | derived                            | `arm64` or `amd64`, from the host architecture.                 |
| `codebase_memory_mcp_download_url`  | derived                            | Release tarball URL.                                            |
