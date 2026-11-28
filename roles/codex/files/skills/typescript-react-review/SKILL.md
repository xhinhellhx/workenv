---
name: typescript-react-review
description: Review TypeScript and React changes for runtime contract, rendering, state, lifecycle, and accessibility regressions.
---

Read the repository's TypeScript settings, React version, and test commands. Follow the component or API through its callers and entry points.

- Check types against runtime sources such as API responses and persisted state. Inspect narrowing, null and missing values, error cases, and shared types that could hide a contract change.
- Check ownership and reset of state, stable keys, effect dependencies and cleanup, stale closures, and async race conditions. Account for conditional rendering, loading, empty, and error states actually affected. [React Rules](https://react.dev/reference/rules) · [TypeScript strict options](https://www.typescriptlang.org/tsconfig/strict.html)
- For interaction changes, check keyboard behavior, focus, semantics, and accessible names. Run the affected typecheck and tests using the repository's package manager. [WCAG 2.2](https://www.w3.org/TR/WCAG22/)

Lead with evidenced findings and their visible or runtime consequences. Separate style preferences from bugs.
