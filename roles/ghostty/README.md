# ghostty role

Installs the [Ghostty](https://ghostty.org) terminal emulator.

| Platform        | Method                                                      |
| --------------- | ----------------------------------------------------------- |
| macOS           | Homebrew cask (`ghostty_brew_cask`)                         |
| Debian / Ubuntu | Self-contained AppImage (pkgforge-dev), extracted to `/opt` |
| RHEL family     | Self-contained AppImage (pkgforge-dev), extracted to `/opt` |

On Linux the role downloads the [pkgforge-dev AppImage](https://github.com/pkgforge-dev/ghostty-appimage)
at `ghostty_version`, extracts it under `ghostty_appimage_dir` (no system FUSE
needed), and symlinks `AppRun` to `ghostty_bin` on PATH. The AppImage bundles
its own GTK4/libadwaita, so it runs cleanly where the **system GTK is too old to
build/run Ghostty from source** (notably RHEL, where a source build hits GTK
theme-parser and GDK `color-mgmt` errors). Because AppImages do not register
themselves, the role installs a desktop entry into `/usr/share/applications`
with an **absolute `Exec`** (GNOME hides relative-Exec entries), mirrors the
bundled icons into `/usr/share/icons/hicolor`, restores SELinux contexts on
RHEL, and refreshes the desktop/icon caches so Ghostty appears in the launcher.
Homebrew is ensured by the `homebrew` role dependency.

> The AppImage is published by the unofficial pkgforge-dev project, not the
> Ghostty team. On a GNOME/Wayland session a fresh entry may only appear after a
> log out / log in.

## Variables

| Variable                  | Default            | Description                                   |
| ------------------------- | ------------------ | --------------------------------------------- |
| `ghostty_brew_cask`       | `ghostty`          | Homebrew cask name (macOS).                   |
| `ghostty_version`         | `1.3.1`            | AppImage release version (Linux).             |
| `ghostty_appimage_arch`   | derived            | `x86_64` or `aarch64` from the host arch.     |
| `ghostty_appimage_url`    | pkgforge-dev URL   | AppImage download URL.                         |
| `ghostty_appimage_dir`    | `/opt/ghostty`     | Download + extraction directory.              |
| `ghostty_bin`             | `/usr/local/bin/ghostty` | Launcher symlink on PATH (desktop `Exec`). |

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
- `tasks/install-linux.yml` — AppImage download + extraction, launcher symlink, desktop entry, icon mirror, SELinux, cache refresh.
- `tasks/config.yml` — deploys the config file and bundled themes.
- `vars/main.yml` — per-distro desktop-integration package lists.
- `files/config/ghostty/config` — the deployed Ghostty config.
- `files/config/ghostty/themes/` — bundled theme files (e.g. `Solarized Dark
  Patched`) deployed to `~/.config/ghostty/themes/`, so the theme resolves
  regardless of the installed Ghostty version.
