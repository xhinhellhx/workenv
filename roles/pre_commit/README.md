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
> by the `pyenv` role's shell block).

## Automatic hook installation

The role configures git's global `init.templateDir` (`{{ git_template_dir }}`,
default `~/.config/git/template`) and installs the pre-commit hook into it via
`pre-commit init-templatedir`. As a result, **every `git clone` / `git init`**
auto-installs the hooks for any repo that has a `.pre-commit-config.yaml` — no
need to run `pre-commit install` manually.

| Variable           | Default                   | Description                          |
| ------------------ | ------------------------- | ------------------------------------ |
| `pre_commit_bin`   | Homebrew / `~/.local/bin` | Path to the `pre-commit` binary.     |
| `git_template_dir` | `~/.config/git/template`  | Git template dir (`init.templateDir`). |
