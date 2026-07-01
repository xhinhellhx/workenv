# shfmt role

Installs [shfmt](https://github.com/mvdan/sh).

| Platform        | Method                                       |
| --------------- | -------------------------------------------- |
| macOS           | Homebrew (`shfmt`)                            |
| Debian / Ubuntu | Official release binary → `/usr/local/bin`   |
| RHEL family     | Official release binary → `/usr/local/bin`   |

Idempotent on Linux (skips when `shfmt --version` matches). Homebrew is ensured
by the `homebrew` role dependency.

## Variables

| Variable            | Default          | Description                    |
| ------------------- | ---------------- | ------------------------------ |
| `shfmt_version`     | `3.13.1`         | Release to install on Linux.   |
| `shfmt_install_dir` | `/usr/local/bin` | Install directory (Linux).     |
