# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

FabricTools is a PowerShell module (~211 public cmdlets) for automating Microsoft Fabric and Power BI administration. It is currently in **Public Preview** and targets PowerShell 5.1+ on Windows and Linux. PRs always target the `develop` branch.

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

## Invoke-FabricRestMethod Conventions

In order to prepare input parameters for `Invoke-FabricRestMethod` function - **always use hash splatting** (no backtick line continuation):

```powershell
$apiEndpointUrl = "{0}/workspaces/{1}/notebooks" -f $FabricConfig.BaseUrl, $WorkspaceId

$body = @{
    displayName = $NotebookName
}
$bodyJson = $body | ConvertTo-Json -Depth 10

$apiParams = @{
    Uri            = $apiEndpointUrl
    Method         = 'Post'
    Body           = $bodyJson
    TypeName       = 'Notebook'        # item type for log messages
    ObjectIdOrName = $NotebookName     # id or name for log messages
    HandleResponse = $true             # delegate ALL response handling to the method
}
$response = Invoke-FabricRestMethod @apiParams
$response
```

**Always set `HandleResponse = $true`** — do not write manual `switch ($statusCode)` blocks, `if ($statusCode -ne 200)` checks, or LRO polling loops. `Invoke-FabricRestMethod` handles 200/201/202, HTTP 429 throttling, LRO polling, and pagination internally when this flag is set.

**`ExtractValue` for list (GET all) operations:**

- `ExtractValue = 'True'` — always extract `.value` from the response (standard Fabric API list shape)
- `ExtractValue = 'Auto'` — extract `.value` only if it exists
- Wrap the call in `@(...)` to ensure an array when a single item or empty result is returned: `$items = @(Invoke-FabricRestMethod @apiParams)`

**Table endpoint anomaly** — the `/tables` endpoint returns `.data` instead of `.value`. Use `ExtractValue = 'False'` (or omit it) and manually extract: `@(Invoke-FabricRestMethod @apiParams) | ForEach-Object { $_.data }`

**`NoWait` parameter** — for operations that support a `$waitForCompletion` bool param, map it as `NoWait = (-not $waitForCompletion)`.

## Adding a New Cmdlet

1. Create `src/Public/<FeatureArea>/Verb-FabricNoun.ps1`
2. Add comprehensive comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`). In `.EXAMPLE` blocks, use splatting when an example passes more than two or three parameters, or when a single line would be hard to read (see [Help Examples](#help-examples))
3. Use `Invoke-FabricRestMethod` for all API calls — follow the hash splatting + `HandleResponse = $true` conventions above
4. Use `Write-Message` (PSFramework) for logging, not `Write-Verbose`/`Write-Host`
5. Create matching test file at `tests/Unit/Verb-FabricNoun.Tests.ps1`
6. Build, then regenerate docs: `./build.ps1 -Tasks generate_docs` (writes `docs/en-US/<Cmdlet>.md`, including the `itemType` frontmatter key taken from the `src/Public/<FeatureArea>` folder)
7. Update `CHANGELOG.md` under `## [Unreleased]` using Keep a Changelog format

## Help Examples

If an example uses more than two or three parameters, or putting them all on one line would make it hard to read, present the parameters as a splatted hashtable (aligned `=`, no backtick line continuation). Short examples stay on one line:

```powershell
<#
.EXAMPLE
    Verb-FabricNoun -WorkspaceId 'guid' -Name $objectName

.EXAMPLE
    $params = @{
        Workspace = 'WorkspaceName'
        SetId     = 'xxxx-yyyy'
        Format    = 'json'
    }
    Verb-FabricNoun @params
#>
```

Switch parameters are passed as `$true` in the hashtable (e.g. `ReturnRawResult = $true`).

## Documentation Website

`site/Build-DocsSite.ps1` generates a static website from `docs/en-US` into `output/site` (see `site/README.md`). Commands are grouped and filtered by the `itemType` frontmatter key, so never edit `itemType` by hand — move the cmdlet to the right `src/Public` folder and regenerate docs. `.github/workflows/docs.yml` deploys the site to GitHub Pages from `main`. Preview locally with `./site/Build-DocsSite.ps1 -LocalPreview`.

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
