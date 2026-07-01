# neovim role

Installs Neovim and deploys the personal configuration.

## Install behaviour

| Platform            | Method                                                        |
| ------------------- | ------------------------------------------------------------- |
| macOS               | Homebrew (`brew install neovim`); installs Homebrew if absent |
| Debian / Ubuntu     | Compile from source at the pinned tag                         |
| RHEL family         | Compile from source at the pinned tag                         |

On Linux the role installs all build dependencies, clones the Neovim source at
`neovim_version`, and rebuilds only when the installed version differs (idempotent).

## Variables

| Variable                 | Default            | Description                                  |
| ------------------------ | ------------------ | -------------------------------------------- |
| `neovim_config_dir`      | `~/.config/nvim`   | Target directory for the config.             |
| `neovim_version`         | `v0.12.3`          | Git tag built from source on Linux.          |
| `neovim_build_dir`       | `/usr/local/src/neovim` | Source clone / build directory.         |
| `neovim_install_prefix`  | `/usr/local`       | Install prefix (`<prefix>/bin/nvim`).        |
| `neovim_build_type`      | `RelWithDebInfo`   | CMake build type.                            |
| `homebrew_prefix`        | arch-dependent     | `/opt/homebrew` (arm64) or `/usr/local`.     |

## Requirements

- `community.general` collection (for the `homebrew` module on macOS) —
  see `requirements.yml` at the repo root.
- Privilege escalation (`become`) on Linux to install packages and run
  `make install`.

## Layout

- `tasks/main.yml` — dispatches by OS, then deploys config.
- `tasks/install-macos.yml` — Homebrew install path.
- `tasks/install-linux.yml` — source build for Debian/Ubuntu and RHEL family.
- `tasks/config.yml` — copies the config to `neovim_config_dir`.
- `files/config/nvim/` — the Neovim config that gets copied to the target.
- `vars/main.yml` — per-distro build dependency lists.
