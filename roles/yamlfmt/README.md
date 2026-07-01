# yamlfmt role

Installs [yamlfmt](https://github.com/google/yamlfmt), an extensible command
line tool / library to format YAML files.

| Platform        | Method                                               |
| --------------- | ---------------------------------------------------- |
| macOS           | Homebrew (`yamlfmt`)                                  |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin/yamlfmt`  |
| RHEL family     | Official release tarball → `/usr/local/bin/yamlfmt`  |

Idempotent on Linux (skips when `yamlfmt -version` matches). The release tarball
ships the `yamlfmt` binary at its root. Homebrew is ensured by the `homebrew`
role dependency; `yamlfmt` ships in homebrew-core.

## Variables

| Variable               | Default          | Description                  |
| ---------------------- | ---------------- | ---------------------------- |
| `yamlfmt_version`      | `0.21.0`         | Release to install on Linux. |
| `yamlfmt_install_dir`  | `/usr/local/bin` | Install directory (Linux).   |
