# dockerfmt role

Installs [dockerfmt](https://github.com/reteps/dockerfmt), a Dockerfile (and
`RUN` shell) formatter.

| Platform        | Method                                                  |
| --------------- | ------------------------------------------------------- |
| macOS           | Homebrew (`dockerfmt`)                                   |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin/dockerfmt`   |
| RHEL family     | Official release tarball → `/usr/local/bin/dockerfmt`   |

Idempotent on Linux (skips when `dockerfmt version` matches). The release
tarball ships the `dockerfmt` binary at its root. Homebrew is ensured by the
`homebrew` role dependency; `dockerfmt` ships in homebrew-core.

## Variables

| Variable                | Default          | Description                  |
| ----------------------- | ---------------- | ---------------------------- |
| `dockerfmt_version`     | `0.5.2`          | Release to install on Linux. |
| `dockerfmt_install_dir` | `/usr/local/bin` | Install directory (Linux).   |
