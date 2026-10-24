# docker role

Installs Docker.

| Platform        | Method                                                          |
| --------------- | --------------------------------------------------------------- |
| macOS           | Docker CLI + Colima runtime via Homebrew formulae; Compose and Buildx linked as CLI plugins |
| Debian / Ubuntu | Official `get.docker.com` script → Engine, CLI, Compose, Buildx |
| Rocky Linux / AlmaLinux / CentOS | Docker's CentOS RPM repository via DNF → Engine, CLI, containerd, Compose, Buildx |
| RHEL            | Docker's RHEL RPM repository via DNF → Engine, CLI, containerd, Compose, Buildx |

On macOS the Compose and Buildx plugins are standalone Homebrew formulae
installed under `docker_cli_plugins_dir`. The role registers that directory in
`~/.docker/config.json` (`cliPluginsExtraDirs`, merged non-destructively so
`auths`/`credsStore`/`currentContext` are preserved) to enable `docker compose`
and `docker buildx`. On Linux the RPM repository or convenience script installs
the equivalent `*-plugin` packages system-wide.

On Rocky Linux and the RHEL family, the role configures Docker's stable RPM
repository with GPG signature checking and installs all required packages with
DNF on every run (`state: present`). Repository paths use the distribution's
major version, so a Rocky release such as 9.5 uses the EL 9 packages. An existing
Docker CLI does not skip Engine or plugin installation. Conflicting packages
such as `podman-docker` must be removed before installing Docker; the role does
not automatically erase an existing container runtime.

Because `~/.docker/cli-plugins` outranks `cliPluginsExtraDirs` in the docker CLI
search order, a machine that previously ran Docker Desktop can have stale
symlinks there (pointing into a now-removed `/Applications/Docker.app`) that
shadow the Homebrew plugins and make `docker buildx` report "not a docker
command". The role prunes broken plugin symlinks so the Homebrew plugins
resolve; valid links are left untouched.

On macOS, registry credentials are stored in the macOS Keychain rather than
base64-encoded in `config.json`: the role installs `docker-credential-helper`
(which ships `docker-credential-osxkeychain`) and sets `credsStore` to
`{{ docker_creds_store }}` (default `osxkeychain`) in `~/.docker/config.json`.

The default Colima startup mounts `/Volumes` writable (`/Volumes:w`) so Docker
containers can bind-mount external macOS volumes. Override
`docker_colima_mounts` to change the Colima `--mount` arguments.

The Docker daemon is launched at start:

- **Linux**: the `docker` systemd service is enabled (`enabled: true`).
- **macOS**: the Colima VM (which runs the Docker daemon) is started immediately
  and a per-user LaunchAgent
  (`~/Library/LaunchAgents/com.workenv.colima-autostart.plist`) starts it again
  at each login (`RunAtLoad`).

On Linux the role also adds `docker_users` to the `docker` group. Homebrew is
ensured by the `homebrew` role dependency.

> Mutually exclusive with the [`podman`](../podman) role in spirit — enable one
> in `site.yml`.

## Variables

| Variable              | Default                   | Description                                 |
| --------------------- | ------------------------- | ------------------------------------------- |
| `docker_brew_formulae`| `[docker, docker-compose, docker-buildx, colima]` | Homebrew formulae installed (macOS). |
| `docker_cli_plugins_dir` | `{{ homebrew_prefix }}/lib/docker/cli-plugins` | Plugins dir added to `cliPluginsExtraDirs` in `~/.docker/config.json` (macOS). |
| `docker_creds_store`  | `osxkeychain`             | `credsStore` written to `~/.docker/config.json` (macOS); stores registry creds in the Keychain. |
| `docker_colima_mounts`| `[/Volumes:w]`            | Colima `--mount` values used when starting the macOS Docker VM. |
| `docker_users`        | `[ {{ ansible_facts['user_id'] }} ]` | Users added to the `docker` group (Linux). |
| `docker_rpm_repository_url` | `https://download.docker.com/linux/centos` (RHEL: `.../rhel`) | RPM repository root for the RHEL family, including Rocky Linux. |
| `docker_rpm_packages` | `[docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin]` | Packages installed via DNF on the RHEL family. |
| `docker_install_url`  | `https://get.docker.com`  | Convenience-script URL for Linux outside the RHEL family. |

> Log out/in (or `newgrp docker`) after the first run for group membership to
> take effect.
