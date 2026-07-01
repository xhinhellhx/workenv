# dockle role

Installs [dockle](https://github.com/goodwithtech/dockle).

| Platform        | Method                                       |
| --------------- | -------------------------------------------- |
| macOS           | Homebrew (`goodwithtech/r/dockle`)           |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin`  |
| RHEL family     | Official release tarball → `/usr/local/bin`  |

Idempotent on Linux (skips when `dockle --version` matches). Homebrew is
ensured by the `homebrew` role dependency; the fully-qualified formula name
auto-taps `goodwithtech/r` on install.

## Variables

| Variable             | Default          | Description                  |
| -------------------- | ---------------- | ---------------------------- |
| `dockle_version`     | `0.4.15`         | Release to install on Linux. |
| `dockle_install_dir` | `/usr/local/bin` | Install directory (Linux).   |
