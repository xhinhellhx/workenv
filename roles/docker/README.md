# docker role

Installs Docker.

| Platform        | Method                                                          |
| --------------- | --------------------------------------------------------------- |
| macOS           | Docker Desktop via Homebrew cask (`docker_brew_cask`)           |
| Debian / Ubuntu | Official `get.docker.com` script → Engine, CLI, Compose, Buildx |
| RHEL family     | Official `get.docker.com` script                                |

The Docker daemon is launched at start:

- **Linux**: the `docker` systemd service is enabled (`enabled: true`).
- **macOS**: a per-user LaunchAgent (`~/Library/LaunchAgents/com.workenv.docker-autostart.plist`)
  opens Docker Desktop at login (the daemon runs inside the app).

On Linux the role also adds `docker_users` to the `docker` group. Homebrew is
ensured by the `homebrew` role dependency.

> Mutually exclusive with the [`podman`](../podman) role in spirit — enable one
> in `site.yml`.

## Variables

| Variable            | Default                   | Description                                 |
| ------------------- | ------------------------- | ------------------------------------------- |
| `docker_brew_cask`  | `docker`                  | Homebrew cask (macOS).                       |
| `docker_users`      | `[ {{ ansible_facts['user_id'] }} ]` | Users added to the `docker` group (Linux). |
| `docker_install_url`| `https://get.docker.com`  | Linux convenience-script URL.               |

> Log out/in (or `newgrp docker`) after the first run for group membership to
> take effect.
