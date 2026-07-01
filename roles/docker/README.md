# docker role

Installs Docker.

| Platform        | Method                                                          |
| --------------- | --------------------------------------------------------------- |
| macOS           | Docker CLI + Colima runtime via Homebrew formulae; Compose and Buildx linked as CLI plugins |
| Debian / Ubuntu | Official `get.docker.com` script → Engine, CLI, Compose, Buildx |
| RHEL family     | Official `get.docker.com` script → Engine, CLI, Compose, Buildx |

On macOS the Compose and Buildx plugins are standalone Homebrew formulae
installed under `docker_cli_plugins_dir`. The role registers that directory in
`~/.docker/config.json` (`cliPluginsExtraDirs`, merged non-destructively so
`auths`/`credsStore`/`currentContext` are preserved) to enable `docker compose`
and `docker buildx`. On Linux the convenience script installs the equivalent
`*-plugin` packages system-wide.

The Docker daemon is launched at start:

- **Linux**: the `docker` systemd service is enabled (`enabled: true`).
- **macOS**: a per-user LaunchAgent (`~/Library/LaunchAgents/com.workenv.docker-autostart.plist`)
  opens Docker Desktop at login (the daemon runs inside the app).

On Linux the role also adds `docker_users` to the `docker` group. Homebrew is
ensured by the `homebrew` role dependency.

> Mutually exclusive with the [`podman`](../podman) role in spirit — enable one
> in `site.yml`.

## Variables

| Variable              | Default                   | Description                                 |
| --------------------- | ------------------------- | ------------------------------------------- |
| `docker_brew_formulae`| `[docker, docker-compose, docker-buildx, colima]` | Homebrew formulae installed (macOS). |
| `docker_cli_plugins_dir` | `{{ homebrew_prefix }}/lib/docker/cli-plugins` | Plugins dir added to `cliPluginsExtraDirs` in `~/.docker/config.json` (macOS). |
| `docker_users`        | `[ {{ ansible_facts['user_id'] }} ]` | Users added to the `docker` group (Linux). |
| `docker_install_url`  | `https://get.docker.com`  | Linux convenience-script URL.               |

> Log out/in (or `newgrp docker`) after the first run for group membership to
> take effect.
