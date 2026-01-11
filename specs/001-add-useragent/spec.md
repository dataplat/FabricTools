```markdown
# Feature Specification: Add UserAgent attribute to all request to Fabric API

**Feature Branch**: `001-add-useragent`
**Created**: 2026-01-11
**Status**: Draft
**Input**: Issue: "Add UserAgent attribute to all request to Fabric API" (https://github.com/dataplat/FabricTools/issues/119)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ensure all Fabric API requests include a User-Agent header (Priority: P1)

As a module user or maintainer, I want every HTTP request sent to Microsoft Fabric to include a `User-Agent` header so that telemetry and debug logs on the Fabric side include the client and runtime details.

**Why this priority**: Improves observability, troubleshooting, and helps Fabric identify client versions and runtimes; low risk, high visibility.

**Independent Test**: Unit tests that exercise the internal HTTP wrapper(s) assert the presence and format of the `User-Agent` header. Integration tests (mock or recording) verify the header is included in real requests.

**Acceptance Scenarios**:

1. **Given** a code path that issues a Fabric API call, **When** the call is executed, **Then** the outgoing request contains a `User-Agent` header following the project's format.
2. **Given** a developer overrides or configures the user-agent (if allowed), **When** a call is made, **Then** the header reflects the override and remains valid.

---

### User Story 2 - Backwards compatibility and configurability (Priority: P2)

As an administrator, I want the `User-Agent` to be configurable or overridable so that automation or enterprise environments can adapt the header when required.

**Why this priority**: Allowing controlled overrides reduces friction for environments that require customized client identifiers.

**Independent Test**: A configuration path (module config, env var, or parameter) can override the UA; unit tests verify override behavior.

**Acceptance Scenarios**:

1. **Given** the module configuration sets a custom `User-Agent`, **When** the call is made, **Then** the outgoing header equals the configured value.

---

### Edge Cases

- What happens when runtime information (PowerShell version, OS, arch) cannot be determined? The implementation MUST fall back to sensible placeholders (e.g., `unknown`).
- Header length should be reasonable; the implementation MUST avoid excessively long values that could be rejected by servers.
- The change must not remove or break existing authentication or header logic (Authorization, Content-Type, etc.).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: All outgoing HTTP requests to Microsoft Fabric APIs MUST include an HTTP `User-Agent` header.
- **FR-002**: The `User-Agent` header MUST follow the canonical format: `powershell/<ps-version>,FabricTools/<module-version>,(<os>; <arch>)` (example: `powershell/7.5,FabricTools/0.26.0,(linux; amd64)`).
- **FR-003**: The header value MUST include PowerShell runtime version and FabricTools module version. If any value is unavailable it MUST use `unknown` in that section.
- **FR-004**: The `User-Agent` implementation MUST be applied centrally (single internal HTTP wrapper or helper) so that all public commands automatically inherit the header without per-cmdlet changes.
- **FR-005**: There MUST be unit tests asserting the `User-Agent` header is present and matches the expected pattern for the internal HTTP layer.
- **FR-006**: The `User-Agent` header MUST NOT be user-overridable; the module manages the header centrally and enforces the canonical format.
- **FR-007**: No existing public behavior (parameters, returned values, authorization) MUST be altered by this change.

*Notes / Assumptions:* The module build produces a version (manifest `ModuleVersion`) that can be read at runtime; the implementation may read it from the loaded module manifest or from a build constant.

## Key Entities

- **HTTP Wrapper / Fabric Client**: The internal helper responsible for issuing HTTP requests (e.g., `Invoke-FabricRestMethod` helper). This is the preferred place to inject the header.
- **User-Agent string**: Structured value composed of runtime, module version, and environment.
- **Config source**: Module-level config or environment variables that allow override of default UA value.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of unit-tested outgoing HTTP requests include a `User-Agent` header.
- **SC-002**: Unit tests cover the UA header presence and pattern with at least one unit test per HTTP wrapper.
- **SC-003**: Integration test(s) (recorded or mocked) verify that an HTTP request to a test endpoint contains the header.
- **SC-004**: No regression in existing tests; all CI checks remain green after the change.

## Implementation Notes

Implementation details have been moved to `implementation-notes.md` in this feature folder. That file contains developer guidance, suggested runtime lookups, testing guidance, and header constraints. The high-level specification intentionally avoids tool- and function-level details.

## UA override policy (decision)

Decision: **Option A — Default-only (no override)**

Rationale: the project will manage `User-Agent` centrally to guarantee consistent telemetry and reduce configuration surface. The header will not be exposed for override via environment variables, module config, or per-call parameters. If enterprise requirements arise later, the policy may be revisited in a new change request.

---

## Tasks (high level)

- T001: Identify the central HTTP helper(s) that issue Fabric API requests.
- T002: Add logic to construct the `User-Agent` string from runtime and module metadata.
- T003: Inject the header in the central HTTP helper and ensure it's sent with every request.
- T004: Add unit tests for header presence and format.
- T005: Add an integration test (mock or recording) verifying header arrival.
- T006: Update documentation (`docs/en-US` entry or a short README section) describing the UA format and override policy.

---

## Success Checklist (for implementation)

- [ ] Central HTTP helper updated to include `User-Agent`.
- [ ] Unit tests added and passing.
- [ ] Integration test added and passing (recorded or mocked).
- [ ] Documentation updated with UA format and override instructions.
- [ ] PR includes `CHANGELOG.md` entry under `Unreleased`.

---

**Prepared by**: automation (`/speckit.specify`) on 2026-01-11

```
# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each user story/journey must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.
  
  Assign priorities (P1, P2, P3, etc.) to each story, where P1 is the most critical.
  Think of each story as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more user stories as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]  
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Measurable metric, e.g., "Users can complete account creation in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users without degradation"]
- **SC-003**: [User satisfaction metric, e.g., "90% of users successfully complete primary task on first attempt"]
- **SC-004**: [Business metric, e.g., "Reduce support tickets related to [X] by 50%"]
