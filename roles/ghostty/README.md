# ghostty role

Installs the [Ghostty](https://ghostty.org) terminal emulator.

| Platform        | Method                                          |
| --------------- | ----------------------------------------------- |
| macOS           | Homebrew cask (`ghostty_brew_cask`)             |
| Debian / Ubuntu | Snap Store, classic confinement (`snap`)        |
| RHEL family     | Snap Store, classic confinement (`snap`, EPEL)  |

On Linux the role installs the [`ghostty` snap](https://snapcraft.io/ghostty)
(published by Canonical) with **classic confinement**, which terminal emulators
require. The snap bundles its own GTK4/libadwaita, so it runs cleanly where the
**system GTK is too old to build/run Ghostty from source** (notably RHEL, where
a source build hits GTK theme-parser and GDK `color-mgmt` errors). snapd
registers the desktop entry and icons itself, so no manual desktop integration
is needed. The role symlinks `/snap/bin/ghostty` to `ghostty_bin` so the
`ghostty` command works from any shell. Homebrew is ensured by the `homebrew`
role dependency.

The role configures the package manager first:

- **Debian / Ubuntu** — installs `snapd` via `apt` and enables `snapd.socket`.
- **RHEL family** — enables **EPEL** (which provides `snapd`), installs `snapd`,
  creates the `/snap` → `/var/lib/snapd/snap` symlink that classic snaps
  require, and enables `snapd.socket`.

It then waits for snapd seeding (`snap wait system seed.loaded`) before
installing, so the run does not race a freshly bootstrapped snapd.

> Ghostty is **not on Flathub**, so flatpak is not used. On a GNOME/Wayland
> session a freshly installed snap may only appear in the launcher after a log
> out / log in.

## Variables

| Variable              | Default                  | Description                                    |
| --------------------- | ------------------------ | ---------------------------------------------- |
| `ghostty_brew_cask`   | `ghostty`                | Homebrew cask name (macOS).                    |
| `ghostty_snap_name`   | `ghostty`                | Snap package name (Linux).                     |
| `ghostty_bin`         | `/usr/local/bin/ghostty` | Launcher symlink on PATH → `/snap/bin/ghostty`. |

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
- `tasks/install-linux.yml` — snapd bootstrap (apt / EPEL+dnf), seeding wait, snap install, launcher symlink.
- `tasks/config.yml` — deploys the config file and bundled themes.
- `vars/main.yml` — snapd / EPEL package names.
- `files/config/ghostty/config` — the deployed Ghostty config.
- `files/config/ghostty/themes/` — bundled theme files (e.g. `Solarized Dark
  Patched`) deployed to `~/.config/ghostty/themes/`, so the theme resolves
  regardless of the installed Ghostty version.
