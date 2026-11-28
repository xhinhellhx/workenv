---
name: c-cpp-review
description: Review C and C++ changes for memory, lifetime, ABI, concurrency, and platform-dependent regressions.
---

Identify the language mode, build flags, supported targets, and relevant feature guards. Read declarations, actual callers, and tests so findings reflect the compiled code paths.

- Trace ownership and lifetimes, size units and conversions, bounds, allocation failure, cleanup, and thread or interrupt context where relevant. For C++, check invalidated references and iterators and whether RAII expresses the intended ownership.
- Inspect ABI, layout, alignment, endianness, and integer widths where code crosses a binary or hardware boundary. Check effects on supported toolchains and configurations.
- Use the repository's focused build or tests. Consider compiler diagnostics or sanitizers when compatible with the target and scope. Explain target-dependent assumptions that could not be verified.

Report actionable findings with file and line references. Apply C++-specific guidance only to C++ code. [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
