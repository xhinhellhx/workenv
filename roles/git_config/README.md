# git_config role

Applies global git configuration (`scope: global` → `~/.gitconfig`).

## Settings applied

| Setting                 | Value                          | Notes                                   |
| ----------------------- | ------------------------------ | --------------------------------------- |
| `init.defaultBranch`    | `master`                       | Default branch on `git init`.           |
| `push.autoSetupRemote`  | `true`                         | Auto-create the upstream on first push. |
| `pull.rebase`           | `true`                         | Rebase instead of merge on pull.        |
| `credential.helper`     | `osxkeychain` / `libsecret`    | Platform-native (macOS / Linux).        |
| `diff.tool`             | `nvimdiff`                     | Neovim diff mode (`nvim -d`).           |
| `difftool.prompt`       | `false`                        | Don't prompt before launching difftool. |

## Credential helper

- **macOS**: `osxkeychain` (built into git).
- **Linux**: `libsecret`. The role ensures the helper exists —
  `dnf install git-credential-libsecret` on RHEL, and on Debian/Ubuntu it builds
  the helper from git's bundled contrib source and installs it to
  `/usr/local/bin`.

## Variables

| Variable                    | Default                     | Description                              |
| --------------------------- | --------------------------- | ---------------------------------------- |
| `git_default_branch`        | `master`                    | `init.defaultBranch` value.              |
| `git_credential_helper`     | platform-derived            | Credential helper.                       |
| `git_diff_tool`             | `nvimdiff`                  | Diff tool.                               |
| `git_settings`              | see defaults                | Full list of `git config` keys applied.  |
| `git_libsecret_contrib_dir` | `/usr/share/doc/git/contrib/credential/libsecret` | libsecret source dir (Debian). |
