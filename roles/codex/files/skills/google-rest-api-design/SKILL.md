---
name: google-rest-api-design
description: Design or review REST and JSON API contracts using Google's resource-oriented API Improvement Proposals.
---

Read the current contract, its consumers, and any local API standards. Apply Google AIPs to the requested surface and call out deliberate deviations required by compatibility.

- Model resource identity, ownership, and lifecycle before choosing paths. Use standard Get, List, Create, Update, and Delete semantics where they fit. Reserve custom methods for domain actions with distinct semantics. [AIP-121](https://google.aip.dev/121) · [AIP-136](https://google.aip.dev/136)
- For proto-backed APIs, verify HTTP bindings, path variables, and body mapping. For OpenAPI-only services, apply the equivalent HTTP behavior and follow the repository's schema conventions. [AIP-127](https://google.aip.dev/127)
- Specify list ordering and filtering where relevant, opaque pagination tokens, and how parameters remain consistent across pages. For updates, define field-mask behavior. Define retry behavior and request IDs for operations that need deduplication. [AIP-132](https://google.aip.dev/132) · [AIP-158](https://google.aip.dev/158) · [AIP-134](https://google.aip.dev/134) · [AIP-155](https://google.aip.dev/155)
- Check status codes and structured errors, compatibility with existing clients, and long-running operation semantics when relevant. [AIP-193](https://google.aip.dev/193) · [AIP-180](https://google.aip.dev/180) · [AIP-151](https://google.aip.dev/151)

For a design, provide the affected methods, paths, request and response shapes, and behavior clients rely on. For a review, report concrete contract issues with evidence and the relevant AIP. Include focused contract checks for behaviors being changed.
