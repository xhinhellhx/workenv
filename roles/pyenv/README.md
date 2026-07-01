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

Delivered as a zsh fragment at `~/.config/zsh/early.d/10-pyenv.zsh` (sourced by
the `zsh_config` skeleton *before* oh-my-zsh):

```sh
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
```

It runs before oh-my-zsh on purpose: the oh-my-zsh `pyenv` plugin loads pyenv
during startup and expects the shims to already be on `$PATH`, otherwise it
warns `Found pyenv, but it is badly configured`. This fragment only sets up
`$PATH` (`pyenv init --path`); the interactive init (`pyenv init -`, rehash,
completions, virtualenv) is left to that plugin.

> Requires the `zsh_config` role to source the fragment.

## Variables

| Variable             | Default          | Description                                   |
| -------------------- | ---------------- | --------------------------------------------- |
| `pyenv_root`         | `~/.pyenv`       | pyenv install location (Linux clone target).  |
| `pyenv_version`      | `""`             | Git ref to check out (empty = latest).        |
| `pyenv_update`       | `false`          | Update an existing checkout on re-run.        |
| `pyenv_brew_packages`| pyenv + deps     | Homebrew formulae installed on macOS.         |

## Usage

After the first run, open a new shell, then e.g.:

```sh
pyenv install 3.13.2
pyenv global 3.13.2
```
