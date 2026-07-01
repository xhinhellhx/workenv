# nvm role

Installs [nvm](https://github.com/nvm-sh/nvm) (Node Version Manager) by cloning
the repo to `~/.nvm` and checking out the latest release tag, then adds the nvm
init block to the shell rc. Uniform across macOS and Linux (git is installed on
Linux as a prerequisite). Idempotent: the install is skipped if `~/.nvm/nvm.sh`
already exists.

## Shell integration

A managed block is added to `nvm_shellrc` (default `~/.zshrc`):

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

## Variables

| Variable      | Default      | Description                                       |
| ------------- | ------------ | ------------------------------------------------- |
| `nvm_dir`     | `~/.nvm`     | Install location (`NVM_DIR`).                     |
| `nvm_repo`    | nvm repo URL | Source repository.                                |
| `nvm_version` | `""`         | Git ref to install (empty = latest release tag).  |
| `nvm_shellrc` | `~/.zshrc`   | Shell rc file to add the init block to.           |
