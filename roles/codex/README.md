# codex role

Installs or upgrades [codex](https://github.com/openai/codex) (the OpenAI Codex
CLI) on each provisioning run.

| Platform | Method |
| --- | --- |
| macOS (Intel / Apple Silicon) | Latest Homebrew cask, with Homebrew metadata refreshed |
| Debian / Ubuntu / RHEL family (x86_64 / ARM64) | Official standalone installer |

On Linux, the role downloads and runs OpenAI's
[standalone installer](https://learn.chatgpt.com/docs/codex/cli) without prompts
on every provisioning run. The installer resolves the latest release, detects
the architecture, verifies downloads, and reuses complete installed packages.
It downloads from OpenAI's release service with a GitHub Releases fallback.
Node.js and npm are not required.

The role ensures `ca-certificates`, `curl`, and `tar` are installed using sudo.
The installer runs as the target user, stores packages under
`~/.codex/packages/standalone`, and exposes commands in `~/.local/bin` by default.
Version changes and migration from a regular binary to the standalone symlink
are reported as changes. Installer downloads are temporary and cleaned up even
when installation fails. Check mode skips downloading and running the installer.

On macOS, Homebrew itself is ensured by the `homebrew` role dependency.

Set `codex_version` to a specific version (for example, `"0.164.0"`) to pin Linux
installations. Its default is `"latest"`. macOS always uses the latest available
Homebrew cask.

The repository's `zsh_config` role puts `~/.local/bin` first on PATH. When running
this role alone, ensure `codex_install_dir` precedes any older Codex installation
on PATH. Existing binaries from the previous `/usr/local/bin` installation are
left in place; use the new per-user command. If you previously overrode
`codex_install_dir` with a system directory, update that override to a directory
writable by the target user.

## Variables

| Variable | Default | Description |
| --- | --- | --- |
| `codex_version` | `latest` | Latest stable release or an explicit Linux version. |
| `codex_install_url` | `https://chatgpt.com/codex/install.sh` | Official Linux installer. |
| `codex_brew_cask` | `codex` | Homebrew cask to upgrade on macOS. |
| `codex_install_dir` | `~/.local/bin` | Per-user Linux command directory. |
