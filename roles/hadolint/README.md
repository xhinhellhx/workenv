# hadolint role

Installs [hadolint](https://github.com/hadolint/hadolint).

| Platform        | Method                                       |
| --------------- | -------------------------------------------- |
| macOS           | Homebrew (`hadolint`)                         |
| Debian / Ubuntu | Official release binary → `/usr/local/bin`   |
| RHEL family     | Official release binary → `/usr/local/bin`   |

Idempotent on Linux (skips when `hadolint --version` matches). Homebrew is
ensured by the `homebrew` role dependency.

## Variables

| Variable               | Default          | Description                  |
| ---------------------- | ---------------- | ---------------------------- |
| `hadolint_version`     | `2.12.0`         | Release to install on Linux. |
| `hadolint_install_dir` | `/usr/local/bin` | Install directory (Linux).   |
