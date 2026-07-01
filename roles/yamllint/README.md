# yamllint role

Installs [yamllint](https://github.com/adrienverge/yamllint), a linter for YAML
files.

| Platform        | Method                                                       |
| --------------- | ------------------------------------------------------------ |
| macOS           | Homebrew (`yamllint`)                                         |
| Debian / Ubuntu | pipx (`apt install pipx` → `pipx install yamllint`)          |
| RHEL family     | pipx (EPEL → `dnf install pipx` → `pipx install yamllint`)   |

On Linux yamllint is installed in an isolated pipx environment (per-user) and
the binary lands in `~/.local/bin`. Homebrew is ensured by the `homebrew` role
dependency.

> Ensure `~/.local/bin` is on `PATH` (run `pipx ensurepath` once, or it's added
> by the `pyenv` role's shell block).
