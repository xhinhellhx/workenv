# powerlevel10k role

Installs and configures the [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
prompt. Plugin installation/enablement lives in separate roles
(`oh_my_zsh_plugins`, `zsh_autosuggestions`, …). Depends on `zsh_config`.

## What it does

1. Clones Powerlevel10k into `~/.oh-my-zsh/custom/themes/powerlevel10k`.
2. Generates `~/.p10k.zsh` from the chosen wizard template (`p10k_style`) and
   applies the configured tweaks.
3. Delivers three shell fragments (the by-parts pieces it owns):
   - `early.d/00-p10k-instant-prompt.zsh` — instant prompt
   - `plugins.d/10-powerlevel10k-theme.zsh` — `ZSH_THEME=…`
   - `rc.d/90-powerlevel10k.zsh` — sources `~/.p10k.zsh`

## Prompt configuration (current values)

| Variable            | Value      | Effect                                              |
| ------------------- | ---------- | --------------------------------------------------- |
| `p10k_style`        | `classic`  | Base wizard template (classic/lean/rainbow/pure).   |
| `p10k_one_line`     | `true`     | Single-line prompt (removes the `newline` element). |
| `p10k_compact`      | `true`     | No blank line between prompts.                      |
| `p10k_show_time`    | `false`    | No clock segment.                                   |
| `p10k_icon_padding` | `moderate` | Extra icon spacing — fixes glyph overlap (SauceCodePro). |

> `~/.p10k.zsh` is generated with `force: false`, so it is not overwritten once
> present. Delete it (or run `p10k configure`) to regenerate.
