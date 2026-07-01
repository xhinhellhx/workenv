# bazel role

Installs [Bazel](https://bazel.build) (a fast, multi-language build system).

| Platform        | Method                                              |
| --------------- | --------------------------------------------------- |
| macOS           | Homebrew (`bazel` formula)                           |
| Debian / Ubuntu | Official standalone release binary → `/usr/local/bin`|
| RHEL family     | Official standalone release binary → `/usr/local/bin`|

On Linux the role downloads the standalone `bazel` binary from the
[GitHub releases](https://github.com/bazelbuild/bazel/releases) (matching the
host architecture) and installs it to `/usr/local/bin` (needs `become`).
Idempotent — it skips when `bazel --version` already matches `bazel_version`.

## Variables

| Variable             | Default          | Description                                     |
| -------------------- | ---------------- | ----------------------------------------------- |
| `bazel_version`      | `9.1.1`          | Release to install on Linux.                    |
| `bazel_install_dir`  | `/usr/local/bin` | Install directory (Linux).                      |
| `bazel_arch`         | derived          | `arm64` or `x86_64`, from the host architecture.|
| `bazel_download_url` | derived          | Release binary URL (Linux).                     |
| `bazel_force`        | `false`          | Re-download even if already present (upgrade).  |
