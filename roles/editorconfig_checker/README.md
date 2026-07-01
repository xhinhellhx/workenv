# editorconfig_checker role

Installs [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker)
(`ec`), a linter that verifies files are in harmony with your `.editorconfig`.

| Platform        | Method                                          |
| --------------- | ----------------------------------------------- |
| macOS           | Homebrew (`editorconfig-checker`)               |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin/ec`  |
| RHEL family     | Official release tarball → `/usr/local/bin/ec`  |

Idempotent on Linux (skips when `ec --version` matches). The release tarball
ships the binary as `bin/ec-linux-<arch>`; it is installed as `ec` to match the
name the Homebrew formula uses. Homebrew is ensured by the `homebrew` role
dependency; `editorconfig-checker` ships in homebrew-core.

## Variables

| Variable                           | Default          | Description                  |
| ---------------------------------- | ---------------- | ---------------------------- |
| `editorconfig_checker_version`     | `3.7.0`          | Release to install on Linux. |
| `editorconfig_checker_install_dir` | `/usr/local/bin` | Install directory (Linux).   |
