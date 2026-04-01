# FabricTools — High-level Specification

## Purpose

FabricTools is a PowerShell module that provides administrative and automation cmdlets for Microsoft Fabric and Power BI. It enables management of workspaces, capacities, datasets, tokens, refreshes, and related tenant settings, and offers Fabric-friendly aliases for legacy Power BI cmdlets.

## Key metadata

- Module manifest: [src/FabricTools.psd1](src/FabricTools.psd1)
  - `ModuleVersion`: 0.31.0
  - `RootModule`: FabricTools.psm1 (generated at build time)
  - `PowerShellVersion` minimum: 5.1
  - `RequiredModules`: `Az.Accounts`, `MicrosoftPowerBIMgmt.Profile`, `Az.Resources` (minimum versions specified in the manifest)
- Repository README: [README.md](README.md)

## Source layout

- Core module sources: [source](src)
  - Public cmdlet implementations: `src/Public/**`
  - Private/internal helpers: `src/Private/**`
  - Manifest and build-time entrypoints: `src/FabricTools.psd1`, `src/FabricTools.psm1`
- Documentation: [docs/en-US](docs/en-US) — one markdown file per cmdlet/area (approx. 214 files)
- Tests: [tests](tests) — Pester unit tests (approx. 216 test files, many correlating to cmdlets)
- Helpers and CI: `helper/build-and-test.ps1`, `build.ps1`, `azure-pipelines.yml`

## Cmdlet surface (high level)

- The repository contains a large surface area of functions (hundreds) implementing Fabric and Power BI operations. The documentation folder (`docs/en-US`) contains individual help pages for most public commands.
- The manifest intentionally leaves `FunctionsToExport` empty because the concrete export list is generated during the build process and packaged into `output/module`.

## Build & test workflow (summary)

- Dependency resolution and preparatory steps are driven by `build.ps1` and the helper `helper/build-and-test.ps1` script.
- Typical sequence performed by the helper script:
  1. Resolve/install prerequisite modules.
  2. Run build task to generate `FabricTools.psm1` and place the module into `output/module/<version>/`.
  3. Import the generated module and run static analysis (`Invoke-ScriptAnalyzer`).
  4. Run unit tests with Pester (`Invoke-Pester .\tests\ -PassThru`).

## Explanation for the active selection

`./build.ps1 -ResolveDependency -Tasks noop`

This command runs the repository's `build.ps1` script from the repository root while instructing it to resolve any declared module dependencies but to skip the actual build steps. The `-ResolveDependency` flag tells the build script to fetch or install prerequisite modules (for example those listed under `RequiredModules` in the manifest). The `-Tasks noop` argument selects a no-operation task plan; combined, these flags make the script prepare the environment (dependencies, tools) without compiling, packaging, or running tests. This is useful in CI or developer setups when you want to ensure dependencies are available before other steps, or to validate dependency resolution in isolation.

## Quality & tooling

- Static analysis: `PSScriptAnalyzer` is used in the helper script.
- Unit testing: `Pester` tests in the `tests` folder.
- CI: `azure-pipelines.yml` present for automated builds.

## Recommendations / Next steps

- To generate the module and list exported commands locally:

```powershell
# prepare deps only
./build.ps1 -ResolveDependency -Tasks noop
# build module
./build.ps1 -Tasks build
# import the generated module (adjust version path)
Import-Module .\output\module\FabricTools\0.31.0\FabricTools.psd1
# list exported commands
Get-Command -Module FabricTools
```

- Consider adding a lightweight `SPECIFICATION.md` (this file) to the repo root (already created) and, if desired, a script to output the list of exported commands post-build for automated documentation.

---

Generated on 2026-01-11.
