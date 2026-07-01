# gcloud role

Installs the [Google Cloud CLI](https://cloud.google.com/sdk/gcloud) (`gcloud`).

| Platform        | Method                                            |
| --------------- | ------------------------------------------------- |
| macOS           | Homebrew cask (`google-cloud-sdk`)                |
| Debian / Ubuntu | Official apt repo → `google-cloud-cli`            |
| RHEL family     | Official yum repo → `google-cloud-cli`            |

Homebrew is ensured by the `homebrew` role dependency. The Linux package is
installed from Google's official repositories, so it updates via the system
package manager. The apt repo is configured with `deb822_repository` (requires
`python3-debian`, installed by the role).

> The yum repo URL targets `x86_64`. For `aarch64` RHEL, override
> `gcloud_yum_baseurl`. After install, run `gcloud init` to authenticate.
