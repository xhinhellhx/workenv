# gitleaks role

Installs [gitleaks](https://github.com/gitleaks/gitleaks).

| Platform        | Method                                       |
| --------------- | -------------------------------------------- |
| macOS           | Homebrew (`gitleaks`)                        |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin`  |
| RHEL family     | Official release tarball → `/usr/local/bin`  |

Idempotent on Linux (skips when `gitleaks version` matches). Homebrew is
ensured by the `homebrew` role dependency; `gitleaks` ships in homebrew-core.

## Variables

| Variable               | Default          | Description                  |
| ---------------------- | ---------------- | ---------------------------- |
| `gitleaks_version`     | `8.30.1`         | Release to install on Linux. |
| `gitleaks_install_dir` | `/usr/local/bin` | Install directory (Linux).   |
