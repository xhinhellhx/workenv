# homebrew role

Ensures [Homebrew](https://brew.sh) is installed on macOS. On non-macOS hosts
the role is a no-op.

Other roles depend on this one (via `meta/main.yml`) so the `brew` command is
available before they install packages.

## Variables

| Variable          | Default        | Description                                |
| ----------------- | -------------- | ------------------------------------------ |
| `homebrew_prefix` | arch-dependent | `/opt/homebrew` (arm64) or `/usr/local`.   |
