# claude_code role

Installs [Claude Code](https://claude.ai/code).

| Platform        | Method                  |
| --------------- | ----------------------- |
| macOS           | Official install script |
| Debian / Ubuntu | Official install script |
| RHEL family     | Official install script |

The install is per-user (no `become`) and lands the binary in `~/.local/bin/claude`.

## Variables

| Variable                  | Default                                                           | Description                                         |
| ------------------------- | ----------------------------------------------------------------- | --------------------------------------------------- |
| `claude_code_install_url` | `https://downloads.claude.ai/claude-code-releases/bootstrap.sh`  | Installer URL.                                      |
| `claude_code_version`     | `latest`                                                          | Version arg: `stable`, `latest`, or `X.Y.Z`.       |
| `claude_code_bin`         | `~/.local/bin/claude`                                             | Expected binary path for the idempotency check.    |
| `claude_code_force`       | `false`                                                           | Re-run the installer even if already present.      |

## Notes

- Ensure `~/.local/bin` is on `PATH` so the `claude` command is found after install.
- Set `claude_code_force: true` to upgrade an existing installation.
