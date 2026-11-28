---
name: golangci-lint
description: Run, diagnose, or configure golangci-lint for a Go repository, including CI mismatches and config migration.
---

Check the repository's pinned golangci-lint and Go versions, working directory, config, build tags, and CI invocation. Reproduce the normal lint entry point before changing config. Multi-module repositories may run the linter once per module.

On supported v2 versions, use `golangci-lint config path` to confirm the active file, `golangci-lint config verify` for schema failures, and `golangci-lint linters` to inspect selection. Run the same package set as CI. For incremental lint, use the repository's baseline and verify that Git history is available. [CLI reference](https://golangci-lint.run/docs/configuration/cli/)

Resolve findings at their source. Keep any necessary suppression narrow and explain its rationale. Distinguish lint findings from compilation, toolchain, and config failures. For an authorized migration, compare enabled checks and exclusions before and after, and verify the config and lint run using the pinned version. [Configuration](https://golangci-lint.run/docs/configuration/file/) · [Migration](https://golangci-lint.run/docs/product/migration-guide/)
