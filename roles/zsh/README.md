# zsh role

Ensures zsh is installed and sets it as the default login shell for the
connecting user.

| Platform        | Install                                |
| --------------- | -------------------------------------- |
| macOS           | ships with the OS (no install)         |
| Debian / Ubuntu | `apt install zsh`                      |
| RHEL family     | `dnf install zsh`                      |

The role locates the `zsh` binary, ensures it is listed in `/etc/shells`, and
sets it as `zsh_user`'s shell (idempotent — only changes when different).
Requires `become` (root) to install packages and change the login shell.

## Variables

| Variable    | Default              | Description                                  |
| ----------- | -------------------- | -------------------------------------------- |
| `zsh_user`  | `{{ ansible_user_id }}` | User whose default shell is switched to zsh. |

> Log out and back in for the new default shell to take effect.
