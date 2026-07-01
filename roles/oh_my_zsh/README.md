# oh_my_zsh role

Installs [Oh My Zsh](https://ohmyz.sh) using the official installer in
`--unattended` mode. Per-user install to `~/.oh-my-zsh`; idempotent (skipped if
that directory already exists).

`--unattended` disables the installer's own `chsh` and shell auto-launch — the
[`zsh`](../zsh) role (a dependency of this one) owns the default shell.

| Platform        | Prerequisites          |
| --------------- | ---------------------- |
| macOS           | git + curl ship with the OS |
| Debian / Ubuntu | `apt install git curl` |
| RHEL family     | `dnf install git curl` |

## Variables

| Variable               | Default                | Description                                       |
| ---------------------- | ---------------------- | ------------------------------------------------- |
| `oh_my_zsh_dir`        | `~/.oh-my-zsh`         | Install location / idempotency marker.            |
| `oh_my_zsh_keep_zshrc` | `true`                 | Keep an existing `~/.zshrc` (`KEEP_ZSHRC=yes`).   |
| `oh_my_zsh_install_url`| ohmyzsh install.sh URL | Installer URL.                                    |
