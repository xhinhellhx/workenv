---
name: security-design
description: Threat-model a proposed architecture or design security controls for a new feature, trust boundary, or privileged operation.
---

Identify the assets, actors, entry points, and data flows relevant to the design. Mark trust boundaries and assumptions about identity, infrastructure, and deployment. Trace normal and failure paths across them.

- For APIs and Go services, locate object and tenant authorization, service identity, credential and secret lifecycles, abuse limits, and audit ownership. For web clients, account for browser trust boundaries, sessions, untrusted content, and client-side exposure. [OWASP Threat Modeling](https://owasp.org/www-project-threat-modeling/) · [OWASP ASVS](https://asvs.owasp.org/) · [OWASP API Security](https://api-security.owasp.org/)
- For embedded Linux, native services, or firmware, consider untrusted formats and peripherals, process and device privileges, boot trust, update authenticity, rollback policy, and recovery. Identify ownership of signing and production debug access when those surfaces exist. [NIST SP 800-193](https://csrc.nist.gov/pubs/sp/800/193/final)
- Tie each consequential threat to an enforceable control, where it lives, and a way to verify it. Prioritize by impact and realistic exposure. Record missing evidence and residual risks separately from confirmed facts.

Deliver the smallest threat model that supports a decision. Include a data-flow diagram when system boundaries are hard to follow. Use project standards when supplied and cite external standards when they materially inform a control.
