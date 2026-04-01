# <!--
# Sync Impact Report
# Version change: none -> 1.0.0
# Modified principles:
# - Contributor Conduct & Community Inclusion
# - Develop-in-Source & Reproducible Builds
# - Test-First Quality Gates
# - Clear Review, Release & Change Management
# - Security, Dependency Management & Minimal Privilege
# Added sections:
# - Constraints & Security Requirements
# - Development Workflow & Quality Gates
# Removed sections: none
# Templates checked:
# - .specify/templates/plan-template.md ✅ checked
# - .specify/templates/spec-template.md ✅ checked
# - .specify/templates/tasks-template.md ✅ checked
# Follow-up TODOs:
# - Verify automated export-of-commands post-build (suggested)
# -->
# FabricTools Constitution

## Core Principles

### 1. Contributor Conduct & Community Inclusion (NON-NEGOTIABLE)

All contributors MUST follow the project's Code of Conduct. Communication and code reviews MUST be conducted respectfully and inclusively. Reports of misconduct MUST be handled confidentially by maintainers and investigated promptly. Contributors who fail to adhere to conduct expectations MAY be removed from project access.

### 2. Develop-in-Source & Reproducible Builds

All development work MUST happen in the `src/` directory. Builds MUST be reproducible using the provided `build.ps1` workflow (examples: `./build.ps1 -ResolveDependency -Tasks noop -UsePSResourceGet` and `./build.ps1 -Tasks build`). The `output/` folder is the canonical build artifact location and MUST not be edited manually; any such edits will be overwritten by the build process.

### 3. Test-First Quality Gates

Tests MUST be provided for public behaviors. Unit and integration tests are written with Pester and MUST run in CI. New or changed functionality MUST include tests that fail before implementation (Red-Green-Refactor) and MUST pass on the branch before merging. Static analysis with PSScriptAnalyzer SHALL run as part of PR checks and any critical failures MUST be addressed before merge.

### 4. Clear Review, Release & Change Management

All changes MUST be submitted via pull requests and follow the repository's templates and review process. Contributors SHOULD update `CHANGELOG.md` (Keep a Changelog format) under `Unreleased` for the proposed change. Release versioning MUST follow semantic versioning: MAJOR for breaking governance or public API changes, MINOR for new, backward-compatible features, PATCH for bug fixes and documentation.

### 5. Security, Dependency Management & Minimal Privilege

Dependencies MUST be declared and resolved using the build tools (the manifest's `RequiredModules` are authoritative). Security issues MUST be reported according to `SECURITY.md`. The project SHALL avoid unnecessary privileges in automation and SHOULD follow the principle of least privilege for any scripts or CI credentials.

## Constraints & Security Requirements

- The module supports PowerShell 5.1 and later as specified in the manifest; contributors MUST ensure compatibility with supported editions.
- The module is currently published as Public PREVIEW; it MUST NOT be used in production environments without explicit risk acceptance.
- Required modules listed in `src/FabricTools.psd1` (for example `Az.Accounts`, `MicrosoftPowerBIMgmt.Profile`, `Az.Resources`) MUST be respected; dependency resolution SHOULD use `PSResourceGet` or the included build helpers.
- All security disclosures and vulnerability reports MUST follow `SECURITY.md` and be handled confidentially.

## Development Workflow & Quality Gates

- Develop in `src/` (not in `output/`). Use the Sampler structure described in the Wiki and run dependency resolution before development.
- Dependency prep example commands (developer guidance):

	- `./build.ps1 -ResolveDependency -Tasks noop -UsePSResourceGet` — resolve dependencies only.
	- `./build.ps1 -Tasks build` — build the module and produce artifacts under `output/module/<version>/`.
	- `Invoke-Pester ./tests/` — run the test suite locally.

- PRs MUST include updated `CHANGELOG.md` entries and use PR templates from `.github/` where relevant. Use the project's commit message instructions to generate helpful commit messages.
- Code style and static analysis: `PSScriptAnalyzer` rules apply; fixes recommended before merge.
- CI gates: PRs MUST pass automated checks (linting, tests, build) before merging. For substantive governance or API changes, open a GitHub Discussion and obtain maintainers' consensus.

## Governance

Amendments to this Constitution MUST be proposed via a pull request against the repository. For non-trivial amendments that alter principles or introduce new constraints, the proposer MUST open a GitHub Discussion to surface debate and rationale. Amendments that change governance or redefine principles constitute a MAJOR change and MUST be approved by at least two maintainers and documented with a migration plan.

All PRs MUST demonstrate compliance with this Constitution by referencing relevant sections (tests, documentation, changelog updates). CI checks (linting, tests) SHALL be required for merging. The maintainers team is responsible for ensuring adherence to this Constitution and for communicating changes to the community.

Versioning policy for this Constitution:

- MAJOR: Backward-incompatible governance or principle removals/redefinitions.
- MINOR: New principle or material expansion of an existing principle.
- PATCH: Clarifications, wording improvements, or non-semantic refinements.

When in doubt about the appropriate version bump, the proposer MUST include rationale in the PR; maintainers will decide according to the policy above.

**Version**: 1.0.0 | **Ratified**: 2026-01-11 | **Last Amended**: 2026-01-11
