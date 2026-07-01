# goreleaser role

Installs [GoReleaser](https://goreleaser.com).

| Platform        | Method                                          |
| --------------- | ----------------------------------------------- |
| macOS           | Homebrew (`goreleaser`)                          |
| Debian / Ubuntu | GitHub release tarball → `/usr/local/bin`        |
| RHEL family     | GitHub release tarball → `/usr/local/bin`        |

Idempotent on Linux (skips when `goreleaser --version` matches). Homebrew is
ensured by the `homebrew` role dependency.

## Variables

| Variable                 | Default          | Description                         |
| ------------------------ | ---------------- | ----------------------------------- |
| `goreleaser_version`     | `2.16.0`         | Release to install on Linux.        |
| `goreleaser_install_dir` | `/usr/local/bin` | Install directory (Linux).          |

> Installs the open-source edition. For GoReleaser Pro, point the download URL
> at the `goreleaser-pro` assets.
