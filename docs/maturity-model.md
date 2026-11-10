# Cmdlet Maturity Model

FabricTools has more than 200 public cmdlets, written over time by many contributors. They
differ in how well they are documented, tested and aligned with the module's conventions. The
maturity model gives every cmdlet a level from 0 to 5, so that:

- **users** can see how much they can rely on a cmdlet,
- **contributors** know what is expected and how to improve a cmdlet,
- **maintainers** can see where work is needed.

The current level of every cmdlet is listed in [MATURITY.md](MATURITY.md).

## Levels

Levels are cumulative: a cmdlet reaches a level only when it meets the criteria of that level
**and of every level below it**.

| Level | Name | Meaning for users |
| ----: | ---- | ----------------- |
| 0 | Experimental | May change or be removed without notice. Often wraps a preview API. |
| 1 | Prototype | Works, but has not been aligned with the module's conventions yet. |
| 2 | Standardized | Documented and follows the module's conventions (help, error handling, logging, `-WhatIf`). |
| 3 | Unit Tested | Its logic is covered by unit tests against a mocked API. |
| 4 | Integration Tested | Exercised against the live Fabric API by an integration test. |
| 5 | Production Ready | Signed off by a maintainer: stable parameters and no known bugs. |

## Criteria

Levels 1 to 4 are **computed from the source** by
[`.build/helpers/Get-CommandMaturity.ps1`](../.build/helpers/Get-CommandMaturity.ps1), so they
cannot drift from the code. Each check has an ID, which is what [MATURITY.md](MATURITY.md) shows
in the *Missing for next level* column.

### Level 1: Prototype

| Check | Rule |
| ----- | ---- |
| `HasSynopsis` | Comment-based help has a non-empty `.SYNOPSIS`. |

### Level 2: Standardized

| Check | Rule |
| ----- | ---- |
| `HasDescription` | Comment-based help has a non-empty `.DESCRIPTION`. |
| `ParametersDocumented` | Every parameter has a `.PARAMETER` entry. |
| `HasExample` | At least one `.EXAMPLE`. |
| `HasCmdletBinding` | The function is an advanced function (`[CmdletBinding()]`). |
| `UsesFabricRestMethod` | REST calls go through `Invoke-FabricRestMethod`, never `Invoke-RestMethod` or `Invoke-WebRequest` directly. Use `ApiType` for the Power BI, Azure or Kusto APIs. |
| `HandleResponse` | Every `Invoke-FabricRestMethod` call sets `HandleResponse = $true`, directly or in its splatted hashtable. No manual status-code checks or polling loops. |
| `UsesWriteMessage` | Logging uses `Write-Message`, not `Write-Host` or `Write-Verbose`. |
| `NoBacktickContinuation` | No backtick line continuation; use splatting. |
| `SupportsShouldProcess` | Cmdlets with a state-changing verb (`Add`, `Import`, `Initialize`, `New`, `Publish`, `Refresh`, `Remove`, `Resume`, `Revoke`, `Set`, `Start`, `Stop`, `Suspend`, `Update`, `Write`) declare `SupportsShouldProcess`. |

See [CLAUDE.md](../CLAUDE.md) for the conventions behind these checks.

### Level 3: Unit Tested

| Check | Rule |
| ----- | ---- |
| `HasUnitTest` | A file `tests/Unit/<Cmdlet>.Tests.ps1` exists. |
| `UnitTestExercisesCmdlet` | The test uses `Mock` and calls the cmdlet. A test that only inspects parameters with `Get-Command`, or is commented out, does not count. |

### Level 4: Integration Tested

| Check | Rule |
| ----- | ---- |
| `HasIntegrationTest` | The cmdlet is called by at least one `*.Tests.ps1` file in `tests/Integration/`. |

### Level 5: Production Ready

Not computed. A maintainer adds the cmdlet to `ProductionReady` in the
[manifest](#the-manifest) when it is at level 4 and:

- it has no open bug reports,
- its parameters have not changed in a breaking way for the last releases,
- any future breaking change will go through a deprecation (alias or warning) first.

A cmdlet listed as Production Ready that drops below level 4 falls back to its computed level,
and the report flags it.

### Level 0: Experimental

A cmdlet is at level 0 when a maintainer lists it under `Experimental` in the manifest, whatever
it scores, or when it does not even meet level 1.

## The manifest

[`.build/Maturity.psd1`](../.build/Maturity.psd1) holds only the judgement calls that cannot be
computed:

```powershell
@{
    Experimental    = @{
        'Get-FabricSomething' = 'Wraps a preview API'
    }
    ProductionReady = @{
        'Get-FabricWorkspace' = 'Approved by <maintainer>, 2026-12-01'
    }
    Exemptions      = @{
        # Checks that do not apply to a cmdlet; they count as passed.
        'Invoke-FabricRestMethod' = @('UsesFabricRestMethod', 'HandleResponse')
    }
}
```

Use exemptions sparingly, and give the reason in a comment.

## Moving a cmdlet up a level

1. Find the cmdlet in [MATURITY.md](MATURITY.md). The *Missing for next level* column lists the
   checks it fails.
2. Fix them in `src/Public/...` (or add the tests in `tests/`).
3. Regenerate the report and commit it with your change:

   ```powershell
   ./build.ps1 -Tasks generate_maturity_report
   ```

4. To see every check for one cmdlet:

   ```powershell
   . ./.build/helpers/Get-CommandMaturity.ps1
   $params = @{
       PublicPath          = './src/Public'
       UnitTestPath        = './tests/Unit'
       IntegrationTestPath = './tests/Integration'
       ManifestPath        = './.build/Maturity.psd1'
   }
   (Get-CommandMaturity @params | Where-Object Name -eq 'Get-FabricLakehouse').Checks
   ```

New cmdlets should aim for level 3: follow the conventions and add a unit test.

## Limitations

The checks are static and deliberately simple. They show that a convention is followed, not that
the code is correct. For example, `UnitTestExercisesCmdlet` does not measure how many paths the
test covers. Code review remains the judge of quality.
