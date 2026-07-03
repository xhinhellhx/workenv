# codex role

Installs [codex](https://github.com/openai/codex) (the OpenAI Codex CLI) from
its official release binaries — no Homebrew or npm dependency.

| Platform        | Method                                                        |
| --------------- | -------------------------------------------------------------|
| macOS           | Official release tarball → `/usr/local/bin`                  |
| Debian / Ubuntu | Official release tarball (musl, static) → `/usr/local/bin`   |
| RHEL family     | Official release tarball (musl, static) → `/usr/local/bin`   |

The role is idempotent: it only (re-)installs when the running
`codex --version` doesn't match `codex_version`.

## Variables

| Variable                   | Default          | Description                                        |
| -------------------------- | ---------------- | ---------------------------------------------------|
| `codex_version`            | `0.142.5`        | Codex release to install.                          |
| `codex_install_dir`        | `/usr/local/bin` | Where the binary is installed.                     |
| `codex_arch`               | derived          | `aarch64` or `x86_64`, from the host architecture. |
| `codex_macos_download_url` | derived          | Release tarball URL (macOS).                       |
| `codex_linux_download_url` | derived          | Release tarball URL (Linux).                       |
