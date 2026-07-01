# just role

Installs [just](https://just.systems) (a handy command runner).

| Platform        | Method                                                     |
| --------------- | ---------------------------------------------------------- |
| macOS           | Official install script → `~/.local/bin`                   |
| Debian / Ubuntu | Official install script → `~/.local/bin`                   |
| RHEL family     | Official install script → `~/.local/bin`                   |

The installer (`https://just.systems/install.sh`) is cross-platform, so the
same per-user flow runs everywhere: no `become`, and the binary lands in
`~/.local/bin/just`. Idempotent — it skips when `just --version` already matches
`just_version`.

## Variables

| Variable           | Default                          | Description                                          |
| ------------------ | -------------------------------- | ---------------------------------------------------- |
| `just_install_url` | `https://just.systems/install.sh`| Installer URL.                                        |
| `just_version`     | `1.54.0`                         | Release to install (passed as `--tag`).              |
| `just_install_dir` | `~/.local/bin`                   | Install directory (passed as `--to`).                |
| `just_bin`         | `~/.local/bin/just`              | Expected binary path for the idempotency check.      |
| `just_force`       | `false`                          | Re-run the installer even if already present.        |

## Notes

- Ensure `~/.local/bin` is on `PATH` so the `just` command is found after install.
