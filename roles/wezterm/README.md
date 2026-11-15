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
| `ghostty_force_software_opengl` | `auto`         | Force Mesa llvmpipe software OpenGL (Linux). See below. |

## Software OpenGL on VMs

Ghostty refuses to start without an **OpenGL 4.3** context, and virtual GPUs
(QEMU/virgl, VMware SVGA3D, VirtualBox VMSVGA, Parallels, many cloud instances)
cap hardware GL below that. Inside a VM the role forces Mesa's llvmpipe software
rasterizer (which exposes GL 4.5) via `LIBGL_ALWAYS_SOFTWARE=1`, applied two
ways so **both** launch paths work:

- a wrapper at `ghostty_bin` that exports the variable before exec'ing the snap
  (covers shells / `$TERMINAL`), and
- an override of the snap's desktop entry in `/usr/share/applications` whose
  `Exec` routes through that wrapper (covers the **GNOME dock / app grid**).

`ghostty_force_software_opengl` controls this. Left at `auto` (default) the role
decides at runtime whether it is in a VM guest. It does **not** trust Ansible's
`virtualization_role` fact alone — that misses some hypervisors and on Fedora
guests often comes back `NA`/`host`, which disabled the workaround and left
Ghostty failing to launch from the dock. Detection therefore falls back to
`systemd-detect-virt`, authoritative on systemd distros. Set the variable to
`true`/`false` to force the choice and skip detection.

## Default terminal

On **Linux** the role makes Ghostty the default terminal using every mechanism
that applies to the host:

- **Debian/Ubuntu** — registers Ghostty as the `x-terminal-emulator` alternative
  at priority 100 (above the distro terminals), so `sensible-terminal` and apps
  that spawn it pick Ghostty.
- **All Linux** — writes `/etc/profile.d/ghostty-default-terminal.sh` exporting
  `TERMINAL={{ ghostty_bin }}`, honoured by TUI launchers and the emerging
  `xdg-terminal-exec` spec. This is the primary lever on RHEL/GNOME, which has
  no `x-terminal-emulator`.
- **GNOME** — best-effort: sets the legacy
  `org.gnome.desktop.default-applications.terminal` dconf key where the schema
  exists. Modern GNOME has deprecated this key, so it is non-fatal if ignored.

> **macOS** has no supported way to set a system-wide default terminal
> ([Apple does not expose one](https://github.com/ghostty-org/ghostty/discussions/7364)),
> so the role does not attempt it there.

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
- `tasks/default-terminal.yml` — sets Ghostty as the default terminal on Linux (x-terminal-emulator, `$TERMINAL`, GNOME dconf).
- `tasks/config.yml` — deploys the config file and bundled themes.
- `vars/main.yml` — snapd / EPEL package names.
- `files/config/ghostty/config` — the deployed Ghostty config.
- `files/config/ghostty/themes/` — bundled theme files (e.g. `Solarized Dark
  Patched`) deployed to `~/.config/ghostty/themes/`, so the theme resolves
  regardless of the installed Ghostty version.
