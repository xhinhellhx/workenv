# oh_my_zsh_plugins role

Enables the **bundled** oh-my-zsh plugins (those shipped with oh-my-zsh, no
installation needed) plus the **platform-specific** ones. Depends on
`zsh_config`. External plugins that require cloning have their own roles
(`zsh_autosuggestions`, `zsh_syntax_highlighting`, `autoswitch_virtualenv`).

## Fragments delivered

- `plugins.d/30-bundled.zsh` — `plugins+=(<bundled> <platform>)`
- `plugins.d/99-history-substring-search.zsh` — enabled last (must load after
  `zsh-syntax-highlighting`)

## Platform plugins

| Platform    | Added           |
| ----------- | --------------- |
| macOS       | `macos`, `brew` |
| Ubuntu      | `ubuntu`        |
| Debian      | `debian`        |
| RHEL family | `dnf`           |

## Variables

| Variable                              | Default        | Description                       |
| ------------------------------------- | -------------- | --------------------------------- |
| `omz_bundled_plugins`                 | see defaults   | Bundled plugins to enable.        |
| `omz_enable_history_substring_search` | `true`         | Enable history-substring-search.  |
