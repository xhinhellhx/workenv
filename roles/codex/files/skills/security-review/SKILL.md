---
name: security-review
description: Perform a defensive application, infrastructure, or firmware security review of source code, configuration, or a proposed diff.
---

Start from the requested scope, deployment assumptions, and the baseline diff or design. Trace relevant inputs, identities, and privileges to the actual enforcement points. Compare edited paths with callers, alternate entry points, and test coverage.

- For APIs and Go services, review per-object authorization, tenant isolation, input and resource bounds, credentials, retry and concurrency behavior at security boundaries, and sensitive data in errors or logs. For React, review session handling, unsafe rendering, client storage, and the server-side enforcement for browser actions. [OWASP ASVS](https://asvs.owasp.org/) · [OWASP API Security](https://api-security.owasp.org/)
- For C/C++, embedded Linux, and firmware, inspect bounds, lifetimes, integer conversions, untrusted parsing, runtime privileges, update verification, rollback controls, and recovery where in scope. [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) · [NIST SP 800-193](https://csrc.nist.gov/pubs/sp/800/193/final)
- Support each finding with concrete code or configuration evidence, exposure assumptions, security impact, and a targeted fix. State confidence and verification limits. Use safe local regression assertions to verify defensive behavior.

Report findings in severity order with file and line references. Separate evidenced findings from open questions and controls that need runtime verification. Stay within the authorized defensive review scope.
