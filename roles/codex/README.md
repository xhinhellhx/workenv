# codex role

Installs [codex](https://github.com/openai/codex) (the OpenAI Codex CLI).

| Platform        | Method                                                        |
| --------------- | -------------------------------------------------------------|
| macOS           | Homebrew cask                                                |
| Debian / Ubuntu | Official release tarball (musl, static) → `/usr/local/bin`   |
| RHEL family     | Official release tarball (musl, static) → `/usr/local/bin`   |

On macOS, Homebrew itself is ensured by the `homebrew` role dependency. Linux
installs remain idempotent by only reinstalling when the running
`codex --version` doesn't match `codex_version`.

## Variables

| Variable                   | Default          | Description                                        |
| -------------------------- | ---------------- | ---------------------------------------------------|
| `codex_version`            | `0.142.5`        | Codex release to install on Linux.                 |
| `codex_brew_cask`          | `codex`          | Homebrew cask to install on macOS.                 |
| `codex_install_dir`        | `/usr/local/bin` | Where the Linux binary is installed.               |
| `codex_arch`               | derived          | `aarch64` or `x86_64`, from the host architecture. |
| `codex_linux_download_url` | derived          | Release tarball URL (Linux).                       |
