# zsh_config role

Owns the `~/.zshrc` skeleton and provides the **by-parts** framework that other
roles use to deliver their shell configuration. Depends on the `oh_my_zsh` role.

## How it works

The skeleton sources `*.zsh` fragments (lexical order) from three directories
under `{{ zsh_fragment_dir }}` (default `~/.config/zsh`):

| Directory    | When sourced            | Used for                                   |
| ------------ | ----------------------- | ------------------------------------------ |
| `early.d/`   | first                   | Powerlevel10k instant prompt               |
| `plugins.d/` | before `oh-my-zsh.sh`   | `ZSH_THEME`, `plugins+=(...)`              |
| `rc.d/`      | after `oh-my-zsh.sh`    | tool init (pyenv, nvm), prompt config      |

Roles contribute by dropping a numbered fragment (e.g. `30-bundled.zsh`) into
the relevant directory. The number controls ordering — important for plugins
like `zsh-syntax-highlighting` (must be near the end) and
`history-substring-search` (must be after it).

> This role overwrites `~/.zshrc`; all customisation lives in fragments.
