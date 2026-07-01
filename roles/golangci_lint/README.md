# golangci_lint role

Installs [golangci-lint](https://golangci-lint.run).

| Platform        | Method                                          |
| --------------- | ----------------------------------------------- |
| macOS           | Homebrew (`golangci-lint`)                       |
| Debian / Ubuntu | GitHub release tarball → `/usr/local/bin`        |
| RHEL family     | GitHub release tarball → `/usr/local/bin`        |

Idempotent on Linux (skips when `golangci-lint --version` matches). Homebrew is
ensured by the `homebrew` role dependency.

## Variables

| Variable                    | Default          | Description                          |
| --------------------------- | ---------------- | ------------------------------------ |
| `golangci_lint_version`     | `2.12.2`         | Release to install on Linux.         |
| `golangci_lint_install_dir` | `/usr/local/bin` | Install directory (Linux).           |
