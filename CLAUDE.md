# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FabricTools is a PowerShell module (~211 public cmdlets) for automating Microsoft Fabric and Power BI administration. It is currently in **Public Preview** and targets PowerShell 5.1+ on Windows and Linux. PRs go against the `batch_changes` branch.

## Build & Development Commands

**All work must be done in `/source`, never in `/output` (which is generated).**

```powershell
# First time / fresh session: resolve all dependencies
./build.ps1 -ResolveDependency -Tasks noop -UsePSResourceGet

# Build the module (outputs to /output, also imports into session)
./build.ps1 -Tasks build

# Build then run all tests
./build.ps1 -Tasks build,test

# Regenerate cmdlet help docs from built module
./build.ps1 -Tasks Generate_help_from_built_module
```

```powershell
# Run all Pester tests (after building)
Invoke-Pester ./tests/

# Run tests by tag
Invoke-Pester ./tests/ -Tag UnitTests
Invoke-Pester ./tests/ -Tag Public
Invoke-Pester ./tests/ -Tag Changelog
Invoke-Pester ./tests/ -Tag ParameterTypes
Invoke-Pester ./tests/Integration/ -Tag Integration

# Run a single test file
Invoke-Pester ./tests/Unit/Public/Get-FabricWorkspace.Tests.ps1
```

## Architecture

### Core API Layer (`src/Private/`)

All public cmdlets funnel through these private helpers:

- **`Invoke-FabricRestMethod`** — Universal REST client. Handles pagination (continuation tokens), throttling (HTTP 429), long-running operation polling, and token refresh. Every public cmdlet calls this.
- **`Test-FabricApiResponse`** — Validates API responses and standardizes error handling.
- **`Confirm-TokenState`** — Checks token expiration before each request.
- **`Write-Message`** — Centralized logging via PSFramework.
- **`Get-FabricContinuationToken`** — Pagination support for list operations.
- **`Get-FileDefinitionParts`** — Parses file definitions for item creation/update.

### Authentication Flow

`Connect-FabricAccount` (supports user, service principal, credential auth) → `Get-FabricAuthToken` → `Confirm-TokenState` validates on each call → token stored in PSFramework config.

### Public Cmdlets (`src/Public/`)

211 cmdlets organized by feature area folders: Capacity, Capacity Assignment, Dashboard, Data Pipeline, Datamart, Deployment Pipeline, Domain, Environment, Eventhouse, Gateway, Item, KQL Database, Lakehouse, ML Experiment, ML Model, Mirrored Database, Notebook, Report, Semantic Model, Spark, Spark Job Definition, Warehouse, Workspace, and more.

Naming convention: `Verb-FabricNoun` (e.g., `Get-FabricWorkspace`, `New-FabricLakehouse`, `Remove-FabricCapacity`).

### Configuration

PSFramework is used for all configuration values (not custom config). Key config keys follow the pattern `FabricTools.FabricApi.*` and `FabricTools.FabricSession.*`. Access via `Get-PSFConfigValue`.

### Module Dependencies

```
Az.Accounts              # Azure authentication
Az.Resources             # Azure resource management  
MicrosoftPowerBIMgmt.Profile  # Power BI backward compat
PSFramework              # Logging & configuration
```

## Adding a New Cmdlet

1. Create `src/Public/<FeatureArea>/Verb-FabricNoun.ps1`
2. Add comprehensive comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`)
3. Use `Invoke-FabricRestMethod` for all API calls
4. Use `Write-Message` (PSFramework) for logging, not `Write-Verbose`/`Write-Host`
5. Create matching test file at `tests/Unit/Verb-FabricNoun.Tests.ps1`
6. Build, then regenerate docs: `./build.ps1 -Tasks Generate_help_from_built_module`
7. Update `CHANGELOG.md` under `## [Unreleased]` using Keep a Changelog format

## Testing

- Minimum code coverage threshold: **50%** (configured in `build.yaml`)
- Test files live at `tests/Unit/<CmdletName>.Tests.ps1` — one file per cmdlet
- Tests use Pester 5.x syntax with `Describe`/`Context`/`It` blocks and `BeforeAll`/`AfterAll`

## Commit Message Style

Follow `.github/copilot-commit-message-instructions.md`:
- Subject line max 50 characters, capitalized, no trailing period
- Use imperative mood ("Add workspace support", not "Added")
- Blank line between subject and body
- Body explains what and why
