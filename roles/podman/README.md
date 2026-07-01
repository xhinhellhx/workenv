# podman role

Installs [Podman](https://podman.io), a daemonless, rootless-friendly container
engine with Docker-compatible CLI.

| Platform        | Method                                  |
| --------------- | --------------------------------------- |
| macOS           | Homebrew formula (`podman`)             |
| Debian / Ubuntu | `apt install podman`                    |
| RHEL family     | `dnf install podman`                    |

Homebrew is ensured by the `homebrew` role dependency. On macOS initialise and
start a VM after install with `podman machine init && podman machine start`.

> Mutually exclusive with the [`docker`](../docker) role in spirit — enable one
> in `site.yml`.
