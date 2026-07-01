# trivy role

Installs [trivy](https://github.com/aquasecurity/trivy).

| Platform        | Method                                       |
| --------------- | -------------------------------------------- |
| macOS           | Homebrew (`trivy`)                           |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin`  |
| RHEL family     | Official release tarball → `/usr/local/bin`  |

Idempotent on Linux (skips when `trivy --version` matches). Homebrew is
ensured by the `homebrew` role dependency; `trivy` ships in homebrew-core.

## Variables

| Variable            | Default          | Description                  |
| ------------------- | ---------------- | ---------------------------- |
| `trivy_version`     | `0.71.2`         | Release to install on Linux. |
| `trivy_install_dir` | `/usr/local/bin` | Install directory (Linux).   |
