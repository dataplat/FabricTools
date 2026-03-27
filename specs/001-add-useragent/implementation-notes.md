# Implementation Notes: Add UserAgent attribute to Fabric API requests

This file contains developer-focused guidance and implementation details moved out of the high-level specification.

1) Where to inject the header

- Locate the central HTTP layer used by the module (the single place where HTTP requests are created and sent). Examples in the codebase include request helper functions and wrappers; update that location so the `User-Agent` header is injected before sending.

2) User-Agent composition

- Canonical format (enforced by spec):

  powershell/<ps-version>,FabricTools/<module-version>,(<os>; <arch>)

- Recommended runtime lookups:

  - PowerShell runtime: `$PSVersionTable.PSVersion` (fallback: `unknown`)
  - Module version: read from the loaded module manifest `ModuleVersion` or embed via build-time substitution (fallback: `unknown`)
  - OS: use platform API (e.g., `[System.Runtime.InteropServices.RuntimeInformation]::OSDescription`) and normalize to a short token (e.g., `linux`, `windows`, `darwin`)
  - Arch: detect 64-bit vs 32-bit (e.g., `([System.Environment]::Is64BitOperatingSystem ? 'amd64' : 'x86')`), or map runtime architecture values to a short token

3) Header constraints and validation

- Ensure header value length is reasonable; trim or normalize fields if necessary to avoid server rejections.
- Do not overwrite or remove existing headers such as `Authorization` or `Content-Type`.

4) Testing guidance

- Unit tests: mock the HTTP layer and assert the header exists and follows the canonical pattern. Avoid referencing specific test frameworks in the high-level spec; implement tests using the project's testing conventions (Pester in this repo).
- Integration tests: use a recording/mocking approach to verify header transmitted in end-to-end flows where feasible.

5) Configuration policy

- Per spec decision, the `User-Agent` will NOT be user-overridable. Do not add an environment variable or module config parameter for overriding UA in this change.

6) Backwards compatibility

- Implement the header in a non-breaking way. Existing public function signatures and behaviors MUST NOT change.

7) Developer notes

- Keep code changes centralized and minimal. Add comments referencing the spec and include changelog entry.
