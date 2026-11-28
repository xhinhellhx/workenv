---
name: conventional-commits
description: Plan, write, or validate Conventional Commit messages and split authorized Git commits into coherent changes.
---

Inspect the repository's instructions, commit history, Git status, and staged changes. Follow local conventions for scopes, required trailers, and message limits.

Use `type(scope): description`. Choose `feat` for new behavior and `fix` for a correction. Use the repository's accepted maintenance types when applicable. Indicate breaking changes with `!` or a `BREAKING CHANGE:` footer and explain the compatibility impact. [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)

Group changes by independently understandable intent. Keep each commit coherent, including needed docs, tests, and wiring. Preserve unrelated changes and check staged content before creating each authorized commit. Report the resulting hashes and any hook failures. Treat drafting messages, committing, and pushing as separate actions governed by the user's request.
