# helm role

Installs [Helm](https://helm.sh), the Kubernetes package manager.

| Platform        | Method                                              |
| --------------- | --------------------------------------------------- |
| macOS           | Homebrew (`helm`)                                   |
| Debian / Ubuntu | Official release tarball → `/usr/local/bin/helm`    |
| RHEL family     | Official release tarball → `/usr/local/bin/helm`    |

Homebrew is ensured by the `homebrew` role dependency. On Linux the role is
idempotent: it only re-installs when `helm version --short` doesn't match
`helm_version` (or `helm_force: true`).

## Variables

| Variable            | Default          | Description                               |
| ------------------- | ---------------- | ----------------------------------------- |
| `helm_version`      | `3.21.1`         | Helm release to install on Linux.         |
| `helm_install_dir`  | `/usr/local/bin` | Where the binary is installed (Linux).    |
| `helm_download_url` | get.helm.sh URL  | Derived tarball URL (arch auto-detected). |
| `helm_force`        | `false`          | Re-install even if already present.       |
