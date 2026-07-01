# golang role

Installs a pinned [Go](https://go.dev) toolchain from the official binary
distribution (`https://go.dev/dl`). The same tarball path works on macOS and
Linux, so the version is identical across platforms (Homebrew/package managers
can't pin an exact version as reliably).

Go is installed to `{{ golang_install_dir }}` (default `/usr/local/go`) and
added to `PATH` system-wide. The role is idempotent: it only re-installs when
the running `go version` doesn't match `golang_version`.

## Variables

| Variable             | Default          | Description                                       |
| -------------------- | ---------------- | ------------------------------------------------- |
| `golang_version`     | `1.26.4`         | Go release (no leading `v`; e.g. `1.26.4`).       |
| `golang_install_dir` | `/usr/local/go`  | Install directory.                                |
| `golang_download_url`| go.dev URL       | Derived tarball URL (os/arch auto-detected).      |

## PATH

- **Linux**: `/etc/profile.d/go.sh` adds `/usr/local/go/bin` and `$HOME/go/bin`.
- **macOS**: `/etc/paths.d/go` adds `/usr/local/go/bin`.

Open a new shell after the first install to pick up the updated `PATH`.
