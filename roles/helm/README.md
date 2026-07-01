# helm role

Installs [Helm](https://helm.sh), the Kubernetes package manager.

| Platform        | Method                                          |
| --------------- | ----------------------------------------------- |
| macOS           | Homebrew (`helm`)                                |
| Debian / Ubuntu | Official `get-helm-3` script → `/usr/local/bin`  |
| RHEL family     | Official `get-helm-3` script → `/usr/local/bin`  |

Idempotent on Linux: the script runs only when `helm` is missing (or
`helm_force: true`). Homebrew is ensured by the `homebrew` role dependency.

## Variables

| Variable                  | Default                       | Description                          |
| ------------------------- | ----------------------------- | ------------------------------------ |
| `helm_install_script_url` | official get-helm-3 URL       | Linux installer (installs latest).   |
| `helm_force`              | `false`                       | Re-run the installer to upgrade.     |
