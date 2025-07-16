# Changelog for FabricTools

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added unit tests for `Get-FabricWorkspaceUser` function to ensure it works correctly with multiple workspaces both in the pipeline and passed to a parameter.
- Added unit tests for Aliases for `Get-FabricWorkspaceUser` function to ensure backward compatibility.
- Added credits for authors to all functions and Unit tests to verify the existence of such tags (#89)
- Added `NoWait` switch parameter to `New-FabricSQLDatabase` (#123)
- Added functions related to Deployment Pipelines (#121):  
  - `Add-FabricWorkspaceToStage`,  
  - `Get-FabricDeploymentPipeline`,  
  - `Get-FabricDeploymentPipelineOperation`,  
  - `Get-FabricDeploymentPipelineRoleAssignments`,  
  - `Get-FabricDeploymentPipelineStage`,  
  - `Get-FabricDeploymentPipelineStageItem`,  
  - `New-FabricDeploymentPipeline`,  
  - `Remove-FabricDeploymentPipeline`,  
  - `Remove-FabricWorkspaceFromStage`,  
  - `Start-FabricDeploymentPipelineStage`
- Added private function `Get-FabricContinuationToken` to facilitate pagination
- `Invoke-FabricRestMethod` handles throttling (error 429) by pausing and repeating the request (#88)

### Changed

- `Write-Message` uses `Write-Warning` & `Write-Error` accordingly rather than `Write-Host` with colour (#136)
- Updated `Get-FabricWorkspaceUser` to support pipeline input for `WorkspaceId` and `WorkspaceName` parameters.
- Renamed `Get-FabricWorkspaceUsers` to match the singular form
- `Get-FabricSqlDatabase` accepts Workspace as a pipeline, handles errors correctly and can filter by name (#117).
- Applied splatting for several parameters in `Invoke-FabricRestMethod` and output results in debug mode
- `Remove-FabricSQLDatabase` uses unified function to handle API results
- Internal function `Invoke-FabricRestMethod`: (#143)
  - handles API response, no need to use `Test-FabricApiResponse` from parent public function 
  - handles pagination automatically (when `-HandleResponse` is provided)
- All Deployment Pipeline functions raise an error when an exception is caught. Used splatting for params.
- Refactored SQL Database functions to use enhanced capability in `Invoke-FabricRestMethod`. Used splatting for params.
- `Write-Message` uses PSFramework function for logging, which logs function name (#84)

Updated the `WorkspaceId`, `CapacitiesIds`,`CapacityId`,`CopyJobId`,`datamartId`,`DataPipelineId`,`DataWarehouseGUID`,`DomainId`,`EnvironmentId`,`EventhouseId`,`EventstreamId`,`ExternalDataShareId`,`ItemId`,`KQLDashboardId`,`KQLDatabaseId`,`KQLQuerysetId`,`LakehouseId`,`MirroredDatabaseId`,`MirroredWarehouseId`,`MLExperimentId`,`MLModelId`,`NotebookId`,`operationId`,`PaginatedReportId`,`ParentDomainId`,`parentEventhouseId`,`PrincipalId`,`ReflexId`,`ReportId`,`SemanticModelId`,`SparkCustomPoolId`,`SparkJobDefinitionId`,`SQLDatabaseId`,`SQLEndpointId`,`subscriptionID`,`UserId`,`WarehouseId`,`WorkspaceGUID`,`WorkspaceId`,`WorkspaceIds`,and `WorkspaceRoleAssignmentId` parameters to the datatype GUID [#125](https://github.com/dataplat/FabricTools/issues/125)

### Fixed

- Enhanced logic in unified function `Test-FabricApiResponse` to handle API results and moved it to private functions
- Fixed bug in `Get-FabricLongRunningOperation` - Uri was incorectly created (#131)
- Fixed bug in `Get-FabricLongRunningOperationResult` - uses correct statusCode (#131)
- Fixed `Start-FabricDeploymentPipelineStage` that supports `-NoWait` correctly

### Deprecated

### Removed

- Removed Revision History from `Get-FabricSQLDatabase`, `Get-FabricSQLDatabase`

### Security

## 0.22.0 - 20250609

### Added

- Introduced new PowerShell functions for managing Fabric workspaces, recovery points, configurations, tenant settings, and workspace identities.
- Added unit tests for key functions, including `Get-FabricAPIclusterURI` and `Get-FabricCapacityTenantOverrides`.
- Added standard tests for each function and enhanced Help tests to filter by exported commands.
- Added OutputType attributes to several functions for improved type safety.
- Added support for WhatIf and Confirm parameters to update and revoke functions.
- Added Contributor Covenant Code of Conduct and enhanced contributing guidelines.
- Added commit message guidelines for contributors using GitHub Copilot.

### Changed

- Refactored `Get-FabricAPIClusterURI` to use `Invoke-FabricRestApi` for improved consistency.
- Updated validation pattern for `WorkspaceName` to allow additional special characters, then removed the pattern for greater flexibility.
- Improved documentation for many functions, especially around parameters like `WorkspaceId`.
- Refactored multiple functions for clarity, consistency, and maintainability.
- Enhanced error handling and confirmation prompts (ShouldProcess) for potentially destructive actions.
- Updated module manifest and build/test workflows for better automation and deployment.
- Improved code formatting using the dbatools formatter.

### Fixed

- Fixed issues with `New-FabricDataPipeline` and its call to `Invoke-FabricAPIRequest`.
- Fixed capital letter handling in test automation.
- Fixed ResourceUrl for token retrieval in `Connect-FabricAccount`.
- Fixed bugs in `New-FabricEventhouse` and improved ShouldProcess logic.
- Fixed parameter naming and example formatting in several functions.
- Fixed issue with call to `Invoke-FabricAPIRequest` from `Remove-FabricWarehouse`.

### Deprecated

- None.

### Removed

- Removed unnecessary or duplicate functions (e.g., `Get-AllFabricDatasetRefreshes`, `Get-AllFabricCapacities`).
- Removed obsolete scripts and commented-out configuration paths.
- Removed `Invoke-FabricAPIRequest` and replaced it by `Invoke-FabricRestMethodExtended`
- Removed `Confirm-FabricAuthToken` 
- Renamed `Test-TokenExpired` to `Confirm-TokenState` and extended it using `EnableTokenRefresh` Feature Flag
- Removed `Set-FabricApiHeaders` and merged the entire logic to `Connect-FabricAccount`

### Security

- None.

---

**Contributors:**  
Rob Sewell, Jess Pomfret, Ioana Bouariu, Frank Geisler, Kamil Nowinski, and others.

**Note:**  
For a full list of changes and details, please see the commit history.

### Added

### Security

- In case of vulnerabilities.
