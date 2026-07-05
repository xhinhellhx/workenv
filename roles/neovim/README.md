# neovim role

Installs Neovim, deploys the personal configuration, and configures git to use
Neovim for editor, difftool, and mergetool workflows.

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
| `neovim_git_editor`      | `nvim`             | Git editor for commits and interactive rebase. |
| `neovim_git_diff_tool`   | `nvimdiff`         | Git diff/merge tool.                         |
| `neovim_git_settings`    | see defaults       | Full list of git config keys applied.        |
| `neovim_version`         | `v0.12.3`          | Git tag built from source on Linux.          |
| `neovim_build_dir`       | `/usr/local/src/neovim` | Source clone / build directory.         |
| `neovim_install_prefix`  | `/usr/local`       | Install prefix (`<prefix>/bin/nvim`).        |
| `neovim_build_type`      | `RelWithDebInfo`   | CMake build type.                            |
| `homebrew_prefix`        | arch-dependent     | `/opt/homebrew` (arm64) or `/usr/local`.     |

## Requirements

- `community.general` collection (for `homebrew` on macOS and `git_config`) —
  see `requirements.yml` at the repo root.
- Privilege escalation (`become`) on Linux to install packages and run
  `make install`.

## Layout

- `tasks/main.yml` — dispatches by OS, then deploys config.
- `tasks/install-macos.yml` — Homebrew install path.
- `tasks/install-linux.yml` — source build for Debian/Ubuntu and RHEL family.
- `tasks/config.yml` — copies the config to `neovim_config_dir`.
- `tasks/git.yml` — applies global git settings for Neovim.
- `files/config/nvim/` — the Neovim config that gets copied to the target.
- `vars/main.yml` — per-distro build dependency lists.
