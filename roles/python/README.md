# python role

Installs a Python version with [pyenv](../pyenv) and (optionally) sets it as the
global default. Depends on the `pyenv` role, which installs pyenv and all the
Python build dependencies first.

## Behaviour

1. Resolves `python_version` to the latest matching patch (`pyenv latest -k`).
2. Installs it (`pyenv install -s`; skipped if already built — idempotent).
3. Sets it as the pyenv global version when `python_set_global` is true.

## Variables

| Variable            | Default   | Description                                                |
| ------------------- | --------- | ---------------------------------------------------------- |
| `python_version`    | `3.12`    | Version prefix or exact version to install.                |
| `python_set_global` | `true`    | Make the installed version the pyenv global default.       |
| `pyenv_bin`         | derived   | Path to the `pyenv` binary (Linux clone vs Homebrew).      |

> Works across macOS and Linux because it drives pyenv, which is installed
> per-platform by the `pyenv` role.
