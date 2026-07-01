# pre_commit role

Installs [pre-commit](https://pre-commit.com), the git hook framework.

| Platform        | Method                                  |
| --------------- | --------------------------------------- |
| macOS           | Homebrew (`pre-commit`)                  |
| Debian / Ubuntu | pipx (`apt install pipx` → `pipx install pre-commit`) |
| RHEL family     | pipx (EPEL → `dnf install pipx` → `pipx install pre-commit`) |

On Linux pre-commit is installed in an isolated pipx environment (per-user) and
the binary lands in `~/.local/bin`. Homebrew is ensured by the `homebrew` role
dependency.

> Ensure `~/.local/bin` is on `PATH` (run `pipx ensurepath` once, or it's added
> by the `pyenv` role's shell block). Then use `pre-commit install` in a repo.
