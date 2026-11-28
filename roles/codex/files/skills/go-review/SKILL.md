---
name: go-review
description: Review Go changes for behavioral regressions, API contract issues, concurrency bugs, and test gaps.
---

Read the changed code, callers, and focused tests under the module's actual Go version and build tags. Follow values and ownership across interface, goroutine, and I/O boundaries.

- Check error propagation and wrapping, nil behavior, cancellation and deadlines, and cleanup of resources on early returns.
- Examine goroutine lifetime, channel ownership, shared mutation, and lock ordering where relevant. Account for retries, partial failure, and persistent state.
- Check compatibility for exported contracts, wire formats, and returned values consumed elsewhere. Use the project's test commands and enable race detection when supported and pertinent.

Lead with specific findings, their consequences, and file references. Use the Go review guide for idioms when those affect correctness or maintainability. [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments)
