# glab role

Installs [glab](https://gitlab.com/gitlab-org/cli), the GitLab CLI.

| Platform        | Method                                                        |
| --------------- | ------------------------------------------------------------- |
| macOS           | Homebrew (`glab`)                                             |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin/glab`              |
| RHEL family     | Official release tarball → `/usr/local/bin/glab`              |

Homebrew is ensured by the `homebrew` role dependency. On Linux the role is
idempotent: it only re-installs when the running `glab --version` doesn't match
`glab_version`.

The role also installs the core `glab` skill into `~/.agents/skills` when it
is missing. For an older binary without `glab skills`, set `glab_install_skill`
to `false` until the CLI is upgraded.

## Variables

| Variable           | Default          | Description                                   |
| ------------------ | ---------------- | --------------------------------------------- |
| `glab_version`     | `1.133.0`        | glab release to install on Linux.             |
| `glab_install_skill` | `true`        | Install the core skill bundled with glab.     |
| `glab_install_dir` | `/usr/local/bin` | Where the binary is installed (Linux).        |
| `glab_download_url`| gitlab.com URL   | Derived tarball URL (arch auto-detected).     |
