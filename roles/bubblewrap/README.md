# bubblewrap role

Installs [bubblewrap](https://github.com/containers/bubblewrap), a low-level
Linux namespaces sandboxing tool.

| Platform        | Install                  |
| --------------- | ------------------------ |
| Debian / Ubuntu | `apt install bubblewrap` |
| RHEL family     | `dnf install bubblewrap` |

This role is Linux-only. bubblewrap depends on Linux kernel namespace features,
so the role does not install anything on macOS.
