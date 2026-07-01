# gh role

Installs [gh](https://cli.github.com) (the GitHub CLI) from its official
release binaries — no Homebrew dependency.

| Platform        | Method                                                        |
| --------------- | -------------------------------------------------------------|
| macOS           | Official release zip → `/usr/local/bin`                      |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin`                  |
| RHEL family     | Official release tarball → `/usr/local/bin`                  |

The role is idempotent: it only (re-)installs when the running `gh --version`
doesn't match `gh_version`.

## Variables

| Variable                | Default          | Description                                       |
| ------------------------| ---------------- | ---------------------------------------------------|
| `gh_version`            | `2.95.0`         | gh release to install.                             |
| `gh_install_dir`        | `/usr/local/bin` | Where the binary is installed.                     |
| `gh_arch`               | derived          | `arm64` or `amd64`, from the host architecture.    |
| `gh_macos_download_url` | derived          | Release zip URL (macOS).                           |
| `gh_linux_download_url` | derived          | Release tarball URL (Linux).                       |
