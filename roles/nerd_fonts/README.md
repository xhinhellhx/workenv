# nerd_fonts role

Installs [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) by cloning the
upstream repo (depth=1, tag `nerd_fonts_version`) and running its `install.sh`.

| Platform        | Install location          | Cache refresh        |
| --------------- | ------------------------- | -------------------- |
| macOS           | `~/Library/Fonts`         | handled by the OS    |
| Debian / Ubuntu | `~/.local/share/fonts`    | `fc-cache -f`        |
| RHEL family     | `~/.local/share/fonts`    | `fc-cache -f`        |

Per-user install (no `become`, except to install the `git`/`fontconfig`
prerequisites on Linux). A marker file makes the role idempotent per version.

## Variables

| Variable                | Default                  | Description                                         |
| ----------------------- | ------------------------ | --------------------------------------------------- |
| `nerd_fonts_version`    | `v3.4.0`                 | Git tag to clone.                                   |
| `nerd_fonts_list`       | FiraCode, JetBrainsMono, Hack, Meslo, SourceCodePro | Patched-font dir names to install; empty = all. |
| `nerd_fonts_repo`       | ryanoasis/nerd-fonts URL | Source repository.                                  |
| `nerd_fonts_clone_dir`  | `~/.cache/nerd-fonts`    | Clone destination.                                  |
| `nerd_fonts_force`      | `false`                  | Re-clone and re-install regardless of the marker.   |

> `SourceCodePro` installs the "SauceCodePro Nerd Font" family.
