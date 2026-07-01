# shellcheck role

Installs [ShellCheck](https://www.shellcheck.net).

| Platform        | Method                          |
| --------------- | ------------------------------- |
| macOS           | Homebrew (`shellcheck`)         |
| Debian / Ubuntu | `apt install shellcheck`        |
| RHEL family     | EPEL → `dnf install ShellCheck` |

Homebrew is ensured by the `homebrew` role dependency. On RHEL the package is
`ShellCheck` (capitalised) and lives in EPEL, which the role enables first.
