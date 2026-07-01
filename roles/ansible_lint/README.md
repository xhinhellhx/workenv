# ansible_lint role

Installs [ansible-lint](https://github.com/ansible/ansible-lint), a linter for
Ansible playbooks and roles.

| Platform        | Method                                                             |
| --------------- | ------------------------------------------------------------------ |
| macOS           | Homebrew (`ansible-lint`)                                          |
| Debian / Ubuntu | pipx (`apt install pipx` → `pipx install ansible-lint`)            |
| RHEL family     | pipx (EPEL → `dnf install pipx` → `pipx install ansible-lint`)    |

On Linux ansible-lint is installed in an isolated pipx environment (per-user)
and the binary lands in `~/.local/bin`. Homebrew is ensured by the `homebrew`
role dependency.

> Ensure `~/.local/bin` is on `PATH` (run `pipx ensurepath` once, or it's added
> by the `pyenv` role's shell block).
