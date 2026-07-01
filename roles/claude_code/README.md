# claude_code role

Installs [Claude Code](https://claude.ai/code).

| Platform        | Method                                                    |
| --------------- | --------------------------------------------------------- |
| macOS           | Homebrew (`claude_code_brew_package`)                     |
| Debian / Ubuntu | Official install script (`https://claude.ai/install.sh`)  |
| RHEL family     | Official install script                                   |

On macOS, Homebrew is ensured by the `homebrew` role dependency. On Linux the
install is per-user (no `become`) and lands the binary in `~/.local/bin/claude`.

## Variables

| Variable                    | Default                        | Description                                       |
| --------------------------- | ------------------------------ | ------------------------------------------------- |
| `claude_code_brew_package`  | `claude-code`                  | Homebrew formula/cask name (macOS).               |
| `claude_code_install_url`   | `https://claude.ai/install.sh` | Installer URL (Linux).                            |
| `claude_code_version`       | `stable`                       | Version arg: `stable`, `latest`, or `X.Y.Z` (Linux). |
| `claude_code_bin`           | `~/.local/bin/claude`          | Expected binary path for the idempotency check (Linux). |
| `claude_code_force`         | `false`                        | Re-run the installer even if present (Linux upgrade). |

## Notes

- Ensure `~/.local/bin` is on `PATH` so the `claude` command is found after a
  Linux install.
