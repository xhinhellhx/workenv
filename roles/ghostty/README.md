# ghostty role

Installs the [Ghostty](https://ghostty.org) terminal emulator.

| Platform        | Method                                                      |
| --------------- | ----------------------------------------------------------- |
| macOS           | Homebrew cask (`ghostty_brew_cask`)                         |
| Debian / Ubuntu | Build from source with Zig at the pinned tag               |
| RHEL family     | Build from source with Zig at the pinned tag               |

On Linux the role installs all build dependencies (GTK4, libadwaita,
blueprint-compiler, …), provisions the required Zig toolchain, clones the
Ghostty source at `ghostty_version`, and rebuilds only when the installed
version differs (idempotent). After a build it refreshes the desktop
application and icon caches (`update-desktop-database` / `gtk-update-icon-cache`)
so Ghostty appears in the application launcher. Homebrew is ensured by the
`homebrew` role dependency.

## Variables

| Variable                  | Default            | Description                                   |
| ------------------------- | ------------------ | --------------------------------------------- |
| `ghostty_brew_cask`       | `ghostty`          | Homebrew cask name (macOS).                   |
| `ghostty_version`         | `v1.1.3`           | Git tag built from source (Linux).            |
| `ghostty_build_dir`       | `/usr/local/src/ghostty` | Source clone / build directory.         |
| `ghostty_install_prefix`  | `/usr/local`       | Install prefix (`<prefix>/bin/ghostty`).      |
| `ghostty_optimize`        | `ReleaseFast`      | Zig optimisation mode.                        |
| `ghostty_zig_version`     | `0.13.0`           | Zig toolchain version (v1.1.3 → 0.13.0).      |
| `ghostty_zig_dir`         | `/opt/zig`         | Where the Zig toolchain is installed.         |
| `ghostty_zig_url`         | ziglang.org URL    | Zig tarball download URL.                     |

## Configuration

The role deploys `files/config/ghostty/config` to
`{{ ghostty_config_dir }}` (default `~/.config/ghostty/config`, read by Ghostty
on both macOS and Linux). Current settings:

- Font: `SauceCodePro Nerd Font`, size 12
- Cursor: blinking block
- Theme: `Solarized Dark Patched`
- Automatic updates enabled (`auto-update = download`; macOS/Sparkle only).
- Tab & split keybinds under the Super modifier (Cmd on macOS, Super on Linux).

## Layout

- `tasks/install-macos.yml` — Homebrew cask install.
- `tasks/install-linux.yml` — build deps, Zig toolchain, source build, desktop/icon cache refresh.
- `tasks/config.yml` — deploys the config file and bundled themes.
- `vars/main.yml` — per-distro build dependency lists.
- `files/config/ghostty/config` — the deployed Ghostty config.
- `files/config/ghostty/themes/` — bundled theme files (e.g. `Solarized Dark
  Patched`) deployed to `~/.config/ghostty/themes/`, so the theme resolves
  regardless of the installed Ghostty version.
