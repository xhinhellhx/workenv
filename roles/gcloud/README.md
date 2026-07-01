# gcloud role

Installs the [Google Cloud CLI](https://cloud.google.com/sdk/gcloud) (`gcloud`).

| Platform | Method                                              |
| -------- | --------------------------------------------------- |
| macOS    | Homebrew cask (`google-cloud-sdk`)                  |
| Linux    | Official pinned tarball from `dl.google.com` → `/opt` |

Homebrew is ensured by the `homebrew` role dependency.

On Linux the SDK is installed from Google's official versioned tarball rather
than the apt/yum repositories. This keeps a single code path across all distros
and architectures, needs no GPG keyring or repository setup, and — unlike the
distro packages — leaves `gcloud components update` enabled, so the CLI and its
components self-update.

The pinned `gcloud_version` is extracted to `gcloud_install_dir`
(`/opt/google-cloud-sdk`), and `/etc/profile.d/gcloud.sh` adds it to `PATH` and
sources shell completion. The install is idempotent: it re-extracts only when
the pinned version differs from what is installed (or when `gcloud_force: true`).

| Variable             | Default                | Purpose                                  |
| -------------------- | ---------------------- | ---------------------------------------- |
| `gcloud_version`     | `573.0.0`              | Pinned release to install on Linux       |
| `gcloud_install_dir` | `/opt/google-cloud-sdk`| Where the SDK is extracted               |
| `gcloud_force`       | `false`                | Reinstall even if the version matches    |
| `gcloud_arch`        | auto (`x86_64`/`arm`)  | Tarball arch suffix; auto from host facts |

> ARM64 hosts automatically use the `arm` tarball. To upgrade, bump
> `gcloud_version` (see the [release notes](https://cloud.google.com/sdk/docs/release-notes)).
> After install, run `gcloud init` to authenticate.
