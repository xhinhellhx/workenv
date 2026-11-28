# codex role

Installs or upgrades [codex](https://github.com/openai/codex) (the OpenAI Codex
CLI) on each provisioning run.

| Platform | Method |
| --- | --- |
| macOS (Intel / Apple Silicon) | Latest Homebrew cask, with Homebrew metadata refreshed |
| Debian / Ubuntu / RHEL family (x86_64 / ARM64) | Official standalone installer |

On Linux, the role downloads and runs OpenAI's
[standalone installer](https://learn.chatgpt.com/docs/codex/cli) without prompts
on every provisioning run. The installer resolves the latest release, detects
the architecture, verifies downloads, and reuses complete installed packages.
It downloads from OpenAI's release service with a GitHub Releases fallback.
Node.js and npm are not required.

The role ensures `ca-certificates`, `curl`, and `tar` are installed using sudo.
The installer runs as the target user, stores packages under
`~/.codex/packages/standalone`, and exposes commands in `~/.local/bin` by default.
Version changes and migration from a regular binary to the standalone symlink
are reported as changes. Installer downloads are temporary and cleaned up even
when installation fails. Check mode skips downloading and running the installer.

On macOS, Homebrew itself is ensured by the `homebrew` role dependency.

Set `codex_version` to a specific version (for example, `"0.164.0"`) to pin Linux
installations. Its default is `"latest"`. macOS always uses the latest available
Homebrew cask.

The repository's `zsh_config` role puts `~/.local/bin` first on PATH. When running
this role alone, ensure `codex_install_dir` precedes any older Codex installation
on PATH. Existing binaries from the previous `/usr/local/bin` installation are
left in place; use the new per-user command. If you previously overrode
`codex_install_dir` with a system directory, update that override to a directory
writable by the target user.

## Work across local checkouts

From your primary checkout, name the other Git checkouts the task needs:

```sh
codex-repos ../web -- 'Add pagination to the Go API and use it in the React list.'
```

List several checkout paths before `--` when needed. Paths can point at the
root or a subdirectory of a checkout, including linked Git worktrees. Quote
paths containing spaces. The launcher keeps the primary working directory and
grants workspace write access to each named checkout with `--add-dir`. It tells
Codex to read the other repos' applicable `AGENTS.md` or `AGENTS.override.md`
files and report verification for each one. Each checkout keeps its own Git
status, history, and build commands. Start `codex` directly for single-repo work.

## Code discovery and model routing

Use a narrow search for known files or symbols. For dependency discovery, use
`codebase-memory-mcp` with the selected checkout's absolute path when indexing
and its project ID when querying. Keep result counts small and confirm findings
against the source or language server, especially for C/C++ macros or templates
and dynamic React code. The graph role registers the server with Codex when
Codex is selected in `provision.sh`.

For a directory containing many separate checkouts, build one local project
index per checkout, then link supported service calls:

```sh
codex-index-workspace /path/to/workspace
codex-index-workspace /path/to/workspace --link
codex-index-workspace /path/to/workspace --list
```

The indexer runs locally and stores graphs in the same cache as the Codex MCP
server. Run the first two commands again to refresh the workspace. Cross-repo
links cover recognized service calls and messaging. For Git dependencies such
as Go modules, CMake targets, or TypeScript packages, confirm dependency paths
in the manifests and query the corresponding projects separately.

Set `codex_graph_workspaces` to a list of absolute workspace paths when
provisioning to add scoped guidance to the active personal `AGENTS.md` or
`AGENTS.override.md`. A `codex` launch inside any listed workspace still picks
up its own repository instructions. Use `codex-repos` when a task also needs
write access to named sibling checkouts.

The launcher uses your active Codex configuration for the primary session.
Its prompt routes independent read-only lookups to the installed `workenv-scout`
agent when the lookup would take several tool calls. The scout uses GPT-6 Luna.
The primary model handles changes and verification. With a ChatGPT sign-in the
workflow uses your Codex subscription, including any subagent work. Use `/model`
to select a different primary model for harder work and `/status` to inspect
session token use.

## Elephant–Goldfish review

The role installs Google's `egm@egm` plugin from its upstream marketplace.
Start a fresh CLI session and select `egm-review` for a design document or
`egm-lite` for a small refactor or bug fix. Give the skill the draft or change
and the files reviewers should read. Fresh reviewers consume subscription quota.

## Global coding skills

The role copies its skills into `~/.agents/skills`, where Codex can discover
them across repositories. Each skill can be invoked by name with `$`, and
Codex can select it automatically when the task matches its description.

| Workflow | Skills |
| --- | --- |
| API contracts and interfaces | `google-rest-api-design`, `ui-design` |
| Language reviews | `go-review`, `c-cpp-review`, `typescript-react-review` |
| Development tools | `golangci-lint`, `conventional-commits` |

## Variables

| Variable | Default | Description |
| --- | --- | --- |
| `codex_version` | `latest` | Latest stable release or an explicit Linux version. |
| `codex_install_url` | `https://chatgpt.com/codex/install.sh` | Official Linux installer. |
| `codex_brew_cask` | `codex` | Homebrew cask to upgrade on macOS. |
| `codex_install_dir` | `~/.local/bin` | Per-user launcher directory and Linux command directory. |
| `codex_user_home` | `$CODEX_HOME` or `~/.codex` | Directory for user agent files and plugin installation. |
| `codex_egm_enabled` | `true` | Install Elephant–Goldfish if missing. Set to `false` to skip plugin setup. |
| `codex_graph_workspaces` | `[]` | Absolute workspace paths to include in personal graph guidance. |
