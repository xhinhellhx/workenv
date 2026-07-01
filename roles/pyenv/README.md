# pyenv role

Installs [pyenv](https://github.com/pyenv/pyenv) along with all the build
dependencies needed to compile Python versions, and wires pyenv into the shell.

| Platform        | Install                                                  |
| --------------- | -------------------------------------------------------- |
| macOS           | Homebrew (`pyenv` + build-dep formulae)                  |
| Debian / Ubuntu | `apt` build deps + git clone to `~/.pyenv`               |
| RHEL family     | `dnf` build deps + git clone to `~/.pyenv`               |

Build dependencies follow the pyenv wiki's
[suggested build environment](https://github.com/pyenv/pyenv/wiki#suggested-build-environment).
Homebrew is ensured by the `homebrew` role dependency.

## Shell integration

A managed block is added to `pyenv_shellrc` (default `~/.zshrc`):

```sh
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
```

## Variables

| Variable             | Default          | Description                                   |
| -------------------- | ---------------- | --------------------------------------------- |
| `pyenv_root`         | `~/.pyenv`       | pyenv install location (Linux clone target).  |
| `pyenv_version`      | `""`             | Git ref to check out (empty = latest).        |
| `pyenv_update`       | `false`          | Update an existing checkout on re-run.        |
| `pyenv_brew_packages`| pyenv + deps     | Homebrew formulae installed on macOS.         |
| `pyenv_shellrc`      | `~/.zshrc`       | Shell rc file to add the init block to.       |

## Usage

After the first run, open a new shell, then e.g.:

```sh
pyenv install 3.13.2
pyenv global 3.13.2
```
