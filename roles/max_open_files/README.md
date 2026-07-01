# max_open_files role

Raises the maximum open file descriptors limit to `max_open_files_limit` (default: 131072).

| Platform        | Mechanism                                                                    |
| --------------- | ---------------------------------------------------------------------------- |
| macOS           | LaunchDaemon plist (`/Library/LaunchDaemons/limit.maxfiles.plist`)           |
| Debian / Ubuntu | PAM limits drop-in (`/etc/security/limits.d/`) + `sysctl fs.file-max`       |
| RHEL family     | PAM limits drop-in (`/etc/security/limits.d/`) + `sysctl fs.file-max`       |

Both the soft and hard limits are set to the same value. The limit takes effect
immediately on first apply and persists across reboots.

## Variables

| Variable               | Default  | Description                              |
| ---------------------- | -------- | ---------------------------------------- |
| `max_open_files_limit` | `131072` | Soft and hard `nofile` / `maxfiles` cap. |

## Notes

- macOS: requires `become: true` to write to `/Library/LaunchDaemons/`.
- Linux: requires `become: true` to write to `/etc/security/limits.d/` and
  `/etc/sysctl.d/`. The `ansible.posix` collection must be installed
  (`ansible-galaxy collection install ansible.posix`).
