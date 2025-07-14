---
document type: module
Help Version: 1.0.0.0
HelpInfoUri: https://www.github.com/dataplat/FabricTools
Locale: en-US
Module Guid: f2a0f9e6-fab6-41fc-9e1c-0c94ff38f794
Module Name: FabricTools
ms.date: 07/14/2025
PlatyPS schema version: 2024-05-01
title: FabricTools Module
---

# FabricTools Module

## Description

A module to be able to do more with Microsoft Fabric.
    It lets you pause and resume Fabric capacities.
    Adds functionallity previously only available with the REST API as PowerShell functions.
    There are also functions to make it easier to monitor usage metrics and refreshes.
    It also adds Fabric-friendly aliases for PowerBI functions to make it easier to use the module.

## FabricTools

### [Add-FabricDomainWorkspaceAssignmentByCapacity](Add-FabricDomainWorkspaceAssignmentByCapacity.md)

Assigns workspaces to a Fabric domain based on specified capacities.

### [Add-FabricDomainWorkspaceAssignmentById](Add-FabricDomainWorkspaceAssignmentById.md)

Assigns workspaces to a specified domain in Microsoft Fabric by their IDs.

### [Add-FabricDomainWorkspaceAssignmentByPrincipal](Add-FabricDomainWorkspaceAssignmentByPrincipal.md)

Assigns workspaces to a domain based on principal IDs in Microsoft Fabric.

### [Add-FabricDomainWorkspaceRoleAssignment](Add-FabricDomainWorkspaceRoleAssignment.md)

Bulk assigns roles to principals for workspaces in a Fabric domain.

### [Add-FabricWorkspaceCapacityAssignment](Add-FabricWorkspaceCapacityAssignment.md)

Assigns a Fabric workspace to a specified capacity.

### [Add-FabricWorkspaceIdentity](Add-FabricWorkspaceIdentity.md)

Provisions an identity for a Fabric workspace.

### [Add-FabricWorkspaceRoleAssignment](Add-FabricWorkspaceRoleAssignment.md)

Assigns a role to a principal for a specified Fabric workspace.

### [Add-FabricWorkspaceToStage](Add-FabricWorkspaceToStage.md)

Assigns a workspace to a deployment pipeline stage.

### [Connect-FabricAccount](Connect-FabricAccount.md)

Connects to the Fabric WebAPI.

### [Convert-FromBase64](Convert-FromBase64.md)

Decodes a Base64-encoded string into its original text representation.

### [Convert-ToBase64](Convert-ToBase64.md)

Encodes the content of a file into a Base64-encoded string.

### [Export-FabricItem](Export-FabricItem.md)

Exports items from a Fabric workspace. Either all items in a workspace or a specific item.

### [Get-FabricAPIclusterURI](Get-FabricAPIclusterURI.md)

Retrieves the cluster URI for the tenant.

### [Get-FabricAuthToken](Get-FabricAuthToken.md)

Retrieves the Fabric API authentication token.

### [Get-FabricCapacities](Get-FabricCapacities.md)

This function retrieves all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided.

### [Get-FabricCapacity](Get-FabricCapacity.md)

Retrieves capacity details from a specified Microsoft Fabric workspace.

### [Get-FabricCapacityRefreshables](Get-FabricCapacityRefreshables.md)

Retrieves the top refreshable capacities for the tenant.

### [Get-FabricCapacitySkus](Get-FabricCapacitySkus.md)

Retrieves the fabric capacity information.

### [Get-FabricCapacityState](Get-FabricCapacityState.md)

Retrieves the state of a specific capacity.

### [Get-FabricCapacityTenantOverrides](Get-FabricCapacityTenantOverrides.md)

Retrieves the tenant overrides for all capacities.

### [Get-FabricCapacityTenantSettingOverrides](Get-FabricCapacityTenantSettingOverrides.md)

Retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant.

### [Get-FabricCapacityWorkload](Get-FabricCapacityWorkload.md)

Retrieves the workloads for a specific capacity.

### [Get-FabricConfig](Get-FabricConfig.md)

Gets the configuration for use with all functions in the PSFabricTools module.

### [Get-FabricConnection](Get-FabricConnection.md)

Retrieves Fabric connections.

### [Get-FabricCopyJob](Get-FabricCopyJob.md)

Retrieves CopyJob details from a specified Microsoft Fabric workspace.

### [Get-FabricCopyJobDefinition](Get-FabricCopyJobDefinition.md)

Retrieves the definition of a Copy Job from a specific workspace in Microsoft Fabric.

### [Get-FabricDashboard](Get-FabricDashboard.md)

Retrieves dashboards from a specified workspace.

### [Get-FabricDatamart](Get-FabricDatamart.md)

Retrieves datamarts from a specified workspace.

### [Get-FabricDataPipeline](Get-FabricDataPipeline.md)

Retrieves data pipelines from a specified Microsoft Fabric workspace.

### [Get-FabricDatasetRefreshes](Get-FabricDatasetRefreshes.md)

Retrieves the refresh history of a specified dataset in a PowerBI workspace.

### [Get-FabricDebugInfo](Get-FabricDebugInfo.md)

Shows internal debug information about the current Azure & Fabric sessions & Fabric config.

### [Get-FabricDeploymentPipeline](Get-FabricDeploymentPipeline.md)

Retrieves deployment pipeline(s) from Microsoft Fabric.

### [Get-FabricDeploymentPipelineOperation](Get-FabricDeploymentPipelineOperation.md)

Retrieves details of a specific deployment pipeline operation.

### [Get-FabricDeploymentPipelineRoleAssignments](Get-FabricDeploymentPipelineRoleAssignments.md)

Returns a list of deployment pipeline role assignments.

### [Get-FabricDeploymentPipelineStage](Get-FabricDeploymentPipelineStage.md)

Retrieves details of deployment pipeline stages.

### [Get-FabricDeploymentPipelineStageItem](Get-FabricDeploymentPipelineStageItem.md)

Retrieves the supported items from the workspace assigned to a specific stage of a deployment pipeline.

### [Get-FabricDomain](Get-FabricDomain.md)

Retrieves domain information from Microsoft Fabric, optionally filtering by domain ID, domain name, or only non-empty domains.

### [Get-FabricDomainTenantSettingOverrides](Get-FabricDomainTenantSettingOverrides.md)

Retrieves tenant setting overrides for a specific domain or all capacities in the Fabric tenant.

### [Get-FabricDomainWorkspace](Get-FabricDomainWorkspace.md)

Retrieves the workspaces associated with a specific domain in Microsoft Fabric.

### [Get-FabricEnvironment](Get-FabricEnvironment.md)

Retrieves an environment or a list of environments from a specified workspace in Microsoft Fabric.

### [Get-FabricEnvironmentLibrary](Get-FabricEnvironmentLibrary.md)

Retrieves the list of libraries associated with a specific environment in a Microsoft Fabric workspace.

### [Get-FabricEnvironmentSparkCompute](Get-FabricEnvironmentSparkCompute.md)

Retrieves the Spark compute details for a specific environment in a Microsoft Fabric workspace.

### [Get-FabricEnvironmentStagingLibrary](Get-FabricEnvironmentStagingLibrary.md)

Retrieves the staging library details for a specific environment in a Microsoft Fabric workspace.

### [Get-FabricEnvironmentStagingSparkCompute](Get-FabricEnvironmentStagingSparkCompute.md)

Retrieves staging Spark compute details for a specific environment in a Microsoft Fabric workspace.

### [Get-FabricEventhouse](Get-FabricEventhouse.md)

Retrieves Fabric Eventhouses

### [Get-FabricEventhouseDefinition](Get-FabricEventhouseDefinition.md)

Retrieves the definition of an Eventhouse from a specified Microsoft Fabric workspace.

### [Get-FabricEventstream](Get-FabricEventstream.md)

Retrieves an Eventstream or a list of Eventstreams from a specified workspace in Microsoft Fabric.

### [Get-FabricEventstreamDefinition](Get-FabricEventstreamDefinition.md)

Retrieves the definition of a Eventstream from a specific workspace in Microsoft Fabric.

### [Get-FabricExternalDataShares](Get-FabricExternalDataShares.md)

Retrieves External Data Shares details from a specified Microsoft Fabric.

### [Get-FabricItem](Get-FabricItem.md)

Retrieves fabric items from a workspace.

### [Get-FabricKQLDashboard](Get-FabricKQLDashboard.md)

Retrieves an KQLDashboard or a list of KQLDashboards from a specified workspace in Microsoft Fabric.

### [Get-FabricKQLDashboardDefinition](Get-FabricKQLDashboardDefinition.md)

Retrieves the definition of a KQLDashboard from a specific workspace in Microsoft Fabric.

### [Get-FabricKQLDatabase](Get-FabricKQLDatabase.md)

Retrieves an KQLDatabase or a list of KQLDatabases from a specified workspace in Microsoft Fabric.

### [Get-FabricKQLDatabaseDefinition](Get-FabricKQLDatabaseDefinition.md)

Retrieves the definition of a KQLDatabase from a specific workspace in Microsoft Fabric.

### [Get-FabricKQLQueryset](Get-FabricKQLQueryset.md)

Retrieves an KQLQueryset or a list of KQLQuerysets from a specified workspace in Microsoft Fabric.

### [Get-FabricKQLQuerysetDefinition](Get-FabricKQLQuerysetDefinition.md)

Retrieves the definition of a KQLQueryset from a specific workspace in Microsoft Fabric.

### [Get-FabricLakehouse](Get-FabricLakehouse.md)

Retrieves an Lakehouse or a list of Lakehouses from a specified workspace in Microsoft Fabric.

### [Get-FabricLakehouseTable](Get-FabricLakehouseTable.md)

Retrieves tables from a specified Lakehouse in a Fabric workspace.

### [Get-FabricLongRunningOperation](Get-FabricLongRunningOperation.md)

Monitors the status of a long-running operation in Microsoft Fabric.

### [Get-FabricLongRunningOperationResult](Get-FabricLongRunningOperationResult.md)

Retrieves the result of a completed long-running operation from the Microsoft Fabric API.

### [Get-FabricMirroredDatabase](Get-FabricMirroredDatabase.md)

Retrieves an MirroredDatabase or a list of MirroredDatabases from a specified workspace in Microsoft Fabric.

### [Get-FabricMirroredDatabaseDefinition](Get-FabricMirroredDatabaseDefinition.md)

Retrieves the definition of a MirroredDatabase from a specific workspace in Microsoft Fabric.

### [Get-FabricMirroredDatabaseStatus](Get-FabricMirroredDatabaseStatus.md)

Retrieves the status of a mirrored database in a specified workspace.

### [Get-FabricMirroredDatabaseTableStatus](Get-FabricMirroredDatabaseTableStatus.md)

Retrieves the status of tables in a mirrored database.

### [Get-FabricMirroredWarehouse](Get-FabricMirroredWarehouse.md)

Retrieves an MirroredWarehouse or a list of MirroredWarehouses from a specified workspace in Microsoft Fabric.

### [Get-FabricMLExperiment](Get-FabricMLExperiment.md)

Retrieves ML Experiment details from a specified Microsoft Fabric workspace.

### [Get-FabricMLModel](Get-FabricMLModel.md)

Retrieves ML Model details from a specified Microsoft Fabric workspace.

### [Get-FabricNotebook](Get-FabricNotebook.md)

Retrieves an Notebook or a list of Notebooks from a specified workspace in Microsoft Fabric.

### [Get-FabricNotebookDefinition](Get-FabricNotebookDefinition.md)

Retrieves the definition of a notebook from a specific workspace in Microsoft Fabric.

### [Get-FabricPaginatedReport](Get-FabricPaginatedReport.md)

Retrieves paginated report details from a specified Microsoft Fabric workspace.

### [Get-FabricRecoveryPoint](Get-FabricRecoveryPoint.md)

Get a list of Fabric recovery points.

### [Get-FabricReflex](Get-FabricReflex.md)

Retrieves Reflex details from a specified Microsoft Fabric workspace.

### [Get-FabricReflexDefinition](Get-FabricReflexDefinition.md)

Retrieves the definition of an Reflex from a specified Microsoft Fabric workspace.

### [Get-FabricReport](Get-FabricReport.md)

Retrieves Report details from a specified Microsoft Fabric workspace.

### [Get-FabricReportDefinition](Get-FabricReportDefinition.md)

Retrieves the definition of an Report from a specified Microsoft Fabric workspace.

### [Get-FabricSemanticModel](Get-FabricSemanticModel.md)

Retrieves SemanticModel details from a specified Microsoft Fabric workspace.

### [Get-FabricSemanticModelDefinition](Get-FabricSemanticModelDefinition.md)

Retrieves the definition of an SemanticModel from a specified Microsoft Fabric workspace.

### [Get-FabricSparkCustomPool](Get-FabricSparkCustomPool.md)

Retrieves Spark custom pools from a specified workspace.

### [Get-FabricSparkJobDefinition](Get-FabricSparkJobDefinition.md)

Retrieves Spark Job Definition details from a specified Microsoft Fabric workspace.

### [Get-FabricSparkJobDefinitionDefinition](Get-FabricSparkJobDefinitionDefinition.md)

Retrieves the definition of an SparkJobDefinition from a specified Microsoft Fabric workspace.

### [Get-FabricSparkSettings](Get-FabricSparkSettings.md)

Retrieves Spark settings from a specified Microsoft Fabric workspace.

### [Get-FabricSQLDatabase](Get-FabricSQLDatabase.md)

Retrieves Fabric SQL Database details.

### [Get-FabricSQLEndpoint](Get-FabricSQLEndpoint.md)

Retrieves SQL Endpoints from a specified workspace in Fabric.

### [Get-FabricTenantSetting](Get-FabricTenantSetting.md)

Retrieves tenant settings from the Fabric environment.

### [Get-FabricUsageMetricsQuery](Get-FabricUsageMetricsQuery.md)

Retrieves usage metrics for a specific dataset.

### [Get-FabricUserListAccessEntities](Get-FabricUserListAccessEntities.md)

Retrieves access entities for a specified user in Microsoft Fabric.

### [Get-FabricWarehouse](Get-FabricWarehouse.md)

Retrieves warehouse details from a specified Microsoft Fabric workspace.

### [Get-FabricWorkspace](Get-FabricWorkspace.md)

Retrieves details of a Microsoft Fabric workspace by its ID or name.

### [Get-FabricWorkspaceDatasetRefreshes](Get-FabricWorkspaceDatasetRefreshes.md)

Retrieves the refresh history of all datasets in a specified PowerBI workspace.

### [Get-FabricWorkspaceRoleAssignment](Get-FabricWorkspaceRoleAssignment.md)

Retrieves role assignments for a specified Fabric workspace.

### [Get-FabricWorkspaceTenantSettingOverrides](Get-FabricWorkspaceTenantSettingOverrides.md)

Retrieves tenant setting overrides for all workspaces in the Fabric tenant.

### [Get-FabricWorkspaceUsageMetricsData](Get-FabricWorkspaceUsageMetricsData.md)

Retrieves workspace usage metrics data.

### [Get-FabricWorkspaceUser](Get-FabricWorkspaceUser.md)

Retrieves the user(s) of a workspace.

### [Get-Sha256](Get-Sha256.md)

Calculates the SHA256 hash of a string.

### [Import-FabricEnvironmentStagingLibrary](Import-FabricEnvironmentStagingLibrary.md)

Uploads a library to the staging environment in a Microsoft Fabric workspace.

### [Import-FabricItem](Import-FabricItem.md)

Imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source.

### [Invoke-FabricAPIRequest_duplicate](Invoke-FabricAPIRequest_duplicate.md)

Sends an HTTP request to a Fabric API endpoint and retrieves the response.
Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

### [Invoke-FabricDatasetRefresh](Invoke-FabricDatasetRefresh.md)

This function invokes a refresh of a PowerBI dataset

### [Invoke-FabricKQLCommand](Invoke-FabricKQLCommand.md)

Executes a KQL command in a Kusto Database.

### [Invoke-FabricRestMethod](Invoke-FabricRestMethod.md)

Sends an HTTP request to a Fabric API endpoint and retrieves the response.

### [Invoke-FabricRestMethodExtended](Invoke-FabricRestMethodExtended.md)

Sends an HTTP request to a Fabric API endpoint and retrieves the response.
Takes care of: authentication, 429 throttling, Long-Running-Operation (LRO) response

### [New-FabricCopyJob](New-FabricCopyJob.md)

Creates a new copy job in a specified Microsoft Fabric workspace.

### [New-FabricDataPipeline](New-FabricDataPipeline.md)

Creates a new DataPipeline in a specified Microsoft Fabric workspace.

### [New-FabricDeploymentPipeline](New-FabricDeploymentPipeline.md)

Creates a new deployment pipeline.

### [New-FabricDomain](New-FabricDomain.md)

Creates a new Fabric domain.

### [New-FabricEnvironment](New-FabricEnvironment.md)

Creates a new environment in a specified workspace.

### [New-FabricEventhouse](New-FabricEventhouse.md)

Creates a new Eventhouse in a specified Microsoft Fabric workspace.

### [New-FabricEventstream](New-FabricEventstream.md)

{{ Fill in the Synopsis }}

### [New-FabricKQLDashboard](New-FabricKQLDashboard.md)

Creates a new KQLDashboard in a specified Microsoft Fabric workspace.

### [New-FabricKQLDatabase](New-FabricKQLDatabase.md)

Creates a new KQLDatabase in a specified Microsoft Fabric workspace.

### [New-FabricKQLQueryset](New-FabricKQLQueryset.md)

Creates a new KQLQueryset in a specified Microsoft Fabric workspace.

### [New-FabricLakehouse](New-FabricLakehouse.md)

Creates a new Lakehouse in a specified Microsoft Fabric workspace.

### [New-FabricMirroredDatabase](New-FabricMirroredDatabase.md)

Creates a new MirroredDatabase in a specified Microsoft Fabric workspace.

### [New-FabricMLExperiment](New-FabricMLExperiment.md)

Creates a new ML Experiment in a specified Microsoft Fabric workspace.

### [New-FabricMLModel](New-FabricMLModel.md)

Creates a new ML Model in a specified Microsoft Fabric workspace.

### [New-FabricNotebook](New-FabricNotebook.md)

Creates a new notebook in a specified Microsoft Fabric workspace.

### [New-FabricNotebookNEW](New-FabricNotebookNEW.md)

Creates a new notebook in a specified Microsoft Fabric workspace.

### [New-FabricRecoveryPoint](New-FabricRecoveryPoint.md)

Create a recovery point for a Fabric data warehouse

### [New-FabricReflex](New-FabricReflex.md)

Creates a new Reflex in a specified Microsoft Fabric workspace.

### [New-FabricReport](New-FabricReport.md)

Creates a new Report in a specified Microsoft Fabric workspace.

### [New-FabricSemanticModel](New-FabricSemanticModel.md)

Creates a new SemanticModel in a specified Microsoft Fabric workspace.

### [New-FabricSparkCustomPool](New-FabricSparkCustomPool.md)

Creates a new Spark custom pool in a specified Microsoft Fabric workspace.

### [New-FabricSparkJobDefinition](New-FabricSparkJobDefinition.md)

Creates a new SparkJobDefinition in a specified Microsoft Fabric workspace.

### [New-FabricSQLDatabase](New-FabricSQLDatabase.md)

Creates a new SQL Database in a specified Microsoft Fabric workspace.

### [New-FabricWarehouse](New-FabricWarehouse.md)

Creates a new warehouse in a specified Microsoft Fabric workspace.

### [New-FabricWorkspace](New-FabricWorkspace.md)

Creates a new Fabric workspace with the specified display name.

### [New-FabricWorkspaceUsageMetricsReport](New-FabricWorkspaceUsageMetricsReport.md)

Retrieves the workspace usage metrics dataset ID.

### [Publish-FabricEnvironment](Publish-FabricEnvironment.md)

Publishes a staging environment in a specified Microsoft Fabric workspace.

### [Register-FabricWorkspaceToCapacity](Register-FabricWorkspaceToCapacity.md)

Sets a PowerBI workspace to a capacity.

### [Remove-FabricCopyJob](Remove-FabricCopyJob.md)

Deletes a Copy Job from a specified Microsoft Fabric workspace.

### [Remove-FabricDataPipeline](Remove-FabricDataPipeline.md)

Removes a DataPipeline from a specified Microsoft Fabric workspace.

### [Remove-FabricDeploymentPipeline](Remove-FabricDeploymentPipeline.md)

Deletes a specified deployment pipeline.

### [Remove-FabricDomain](Remove-FabricDomain.md)

Deletes a Fabric domain by its ID.

### [Remove-FabricDomainWorkspaceAssignment](Remove-FabricDomainWorkspaceAssignment.md)

Unassign workspaces from a specified Fabric domain.

### [Remove-FabricDomainWorkspaceRoleAssignment](Remove-FabricDomainWorkspaceRoleAssignment.md)

Bulk unUnassign roles to principals for workspaces in a Fabric domain.

### [Remove-FabricEnvironment](Remove-FabricEnvironment.md)

Deletes an environment from a specified workspace in Microsoft Fabric.

### [Remove-FabricEnvironmentStagingLibrary](Remove-FabricEnvironmentStagingLibrary.md)

Deletes a specified library from the staging environment in a Microsoft Fabric workspace.

### [Remove-FabricEventhouse](Remove-FabricEventhouse.md)

Removes an Eventhouse from a specified Microsoft Fabric workspace.

### [Remove-FabricEventstream](Remove-FabricEventstream.md)

Deletes an Eventstream from a specified workspace in Microsoft Fabric.

### [Remove-FabricItem](Remove-FabricItem.md)

Removes selected items from a Fabric workspace.

### [Remove-FabricKQLDashboard](Remove-FabricKQLDashboard.md)

Deletes an KQLDashboard from a specified workspace in Microsoft Fabric.

### [Remove-FabricKQLDatabase](Remove-FabricKQLDatabase.md)

Deletes an KQLDatabase from a specified workspace in Microsoft Fabric.

### [Remove-FabricKQLQueryset](Remove-FabricKQLQueryset.md)

Deletes an KQLQueryset from a specified workspace in Microsoft Fabric.

### [Remove-FabricLakehouse](Remove-FabricLakehouse.md)

Deletes an Lakehouse from a specified workspace in Microsoft Fabric.

### [Remove-FabricMirroredDatabase](Remove-FabricMirroredDatabase.md)

Deletes an MirroredDatabase from a specified workspace in Microsoft Fabric.

### [Remove-FabricMLExperiment](Remove-FabricMLExperiment.md)

Removes an ML Experiment from a specified Microsoft Fabric workspace.

### [Remove-FabricMLModel](Remove-FabricMLModel.md)

Removes an ML Model from a specified Microsoft Fabric workspace.

### [Remove-FabricNotebook](Remove-FabricNotebook.md)

Deletes an Notebook from a specified workspace in Microsoft Fabric.

### [Remove-FabricRecoveryPoint](Remove-FabricRecoveryPoint.md)

Remove a selected Fabric Recovery Point.

### [Remove-FabricReflex](Remove-FabricReflex.md)

Removes an Reflex from a specified Microsoft Fabric workspace.

### [Remove-FabricReport](Remove-FabricReport.md)

Removes an Report from a specified Microsoft Fabric workspace.

### [Remove-FabricSemanticModel](Remove-FabricSemanticModel.md)

Removes an SemanticModel from a specified Microsoft Fabric workspace.

### [Remove-FabricSparkCustomPool](Remove-FabricSparkCustomPool.md)

Removes a Spark custom pool from a specified Microsoft Fabric workspace.

### [Remove-FabricSparkJobDefinition](Remove-FabricSparkJobDefinition.md)

Removes an SparkJobDefinition from a specified Microsoft Fabric workspace.

### [Remove-FabricSQLDatabase](Remove-FabricSQLDatabase.md)

Deletes a SQL Database from a specified workspace in Microsoft Fabric.

### [Remove-FabricWarehouse](Remove-FabricWarehouse.md)

Removes a warehouse from a specified Microsoft Fabric workspace.

### [Remove-FabricWorkspace](Remove-FabricWorkspace.md)

Deletes an existing Fabric workspace by its workspace ID.

### [Remove-FabricWorkspaceCapacityAssignment](Remove-FabricWorkspaceCapacityAssignment.md)

Unassigns a Fabric workspace from its capacity.

### [Remove-FabricWorkspaceFromStage](Remove-FabricWorkspaceFromStage.md)

Removes a workspace from a deployment pipeline stage.

### [Remove-FabricWorkspaceIdentity](Remove-FabricWorkspaceIdentity.md)

Deprovisions the Managed Identity for a specified Fabric workspace.

### [Remove-FabricWorkspaceRoleAssignment](Remove-FabricWorkspaceRoleAssignment.md)

Removes a role assignment from a Fabric workspace.

### [Restore-FabricRecoveryPoint](Restore-FabricRecoveryPoint.md)

Restore a Fabric data warehouse to a specified restore pont.

### [Resume-FabricCapacity](Resume-FabricCapacity.md)

{{ Fill in the Synopsis }}

### [Revoke-FabricCapacityTenantSettingOverrides](Revoke-FabricCapacityTenantSettingOverrides.md)

Removes a tenant setting override from a specific capacity in the Fabric tenant.

### [Revoke-FabricExternalDataShares](Revoke-FabricExternalDataShares.md)

Retrieves External Data Shares details from a specified Microsoft Fabric.

### [Set-FabricConfig](Set-FabricConfig.md)

Register the configuration for use with all functions in the PSFabricTools module.

### [Start-FabricDeploymentPipelineStage](Start-FabricDeploymentPipelineStage.md)

Deploys items from one stage to another in a deployment pipeline.

### [Start-FabricLakehouseTableMaintenance](Start-FabricLakehouseTableMaintenance.md)

Initiates a table maintenance job for a specified Lakehouse in a Fabric workspace.

### [Start-FabricMirroredDatabaseMirroring](Start-FabricMirroredDatabaseMirroring.md)

Starts the mirroring of a specified mirrored database in a given workspace.

### [Start-FabricSparkJobDefinitionOnDemand](Start-FabricSparkJobDefinitionOnDemand.md)

Starts a Fabric Spark Job Definition on demand.

### [Stop-FabricEnvironmentPublish](Stop-FabricEnvironmentPublish.md)

Cancels the publish operation for a specified environment in Microsoft Fabric.

### [Stop-FabricMirroredDatabaseMirroring](Stop-FabricMirroredDatabaseMirroring.md)

Stops the mirroring of a specified mirrored database in a given workspace.

### [Suspend-FabricCapacity](Suspend-FabricCapacity.md)

{{ Fill in the Synopsis }}

### [Unregister-FabricWorkspaceToCapacity](Unregister-FabricWorkspaceToCapacity.md)

Unregisters a workspace from a capacity.

### [Update-FabricCapacityTenantSettingOverrides](Update-FabricCapacityTenantSettingOverrides.md)

Updates tenant setting overrides for a specified capacity ID.

### [Update-FabricCopyJob](Update-FabricCopyJob.md)

Updates an existing Copy Job in a specified Microsoft Fabric workspace.

### [Update-FabricCopyJobDefinition](Update-FabricCopyJobDefinition.md)

Updates the definition of a Copy Job in a Microsoft Fabric workspace.

### [Update-FabricDataPipeline](Update-FabricDataPipeline.md)

Updates an existing DataPipeline in a specified Microsoft Fabric workspace.

### [Update-FabricDomain](Update-FabricDomain.md)

Updates a Fabric domain by its ID.

### [Update-FabricEnvironment](Update-FabricEnvironment.md)

Updates the properties of a Fabric Environment.

### [Update-FabricEnvironmentStagingSparkCompute](Update-FabricEnvironmentStagingSparkCompute.md)

Updates the Spark compute configuration in the staging environment for a given workspace.

### [Update-FabricEventhouse](Update-FabricEventhouse.md)

Updates an existing Eventhouse in a specified Microsoft Fabric workspace.

### [Update-FabricEventhouseDefinition](Update-FabricEventhouseDefinition.md)

Updates the definition of an existing Eventhouse in a specified Microsoft Fabric workspace.

### [Update-FabricEventstream](Update-FabricEventstream.md)

Updates the properties of a Fabric Eventstream.

### [Update-FabricEventstreamDefinition](Update-FabricEventstreamDefinition.md)

Updates the definition of a Eventstream in a Microsoft Fabric workspace.

### [Update-FabricKQLDashboard](Update-FabricKQLDashboard.md)

Updates the properties of a Fabric KQLDashboard.

### [Update-FabricKQLDashboardDefinition](Update-FabricKQLDashboardDefinition.md)

Updates the definition of a KQLDashboard in a Microsoft Fabric workspace.

### [Update-FabricKQLDatabase](Update-FabricKQLDatabase.md)

Updates the properties of a Fabric KQLDatabase.

### [Update-FabricKQLDatabaseDefinition](Update-FabricKQLDatabaseDefinition.md)

Updates the definition of a KQLDatabase in a Microsoft Fabric workspace.

### [Update-FabricKQLQueryset](Update-FabricKQLQueryset.md)

Updates the properties of a Fabric KQLQueryset.

### [Update-FabricKQLQuerysetDefinition](Update-FabricKQLQuerysetDefinition.md)

Updates the definition of a KQLQueryset in a Microsoft Fabric workspace.

### [Update-FabricLakehouse](Update-FabricLakehouse.md)

Updates the properties of a Fabric Lakehouse.

### [Update-FabricMirroredDatabase](Update-FabricMirroredDatabase.md)

Updates the properties of a Fabric MirroredDatabase.

### [Update-FabricMirroredDatabaseDefinition](Update-FabricMirroredDatabaseDefinition.md)

Updates the definition of a MirroredDatabase in a Microsoft Fabric workspace.

### [Update-FabricMLExperiment](Update-FabricMLExperiment.md)

Updates an existing ML Experiment in a specified Microsoft Fabric workspace.

### [Update-FabricMLModel](Update-FabricMLModel.md)

Updates an existing ML Model in a specified Microsoft Fabric workspace.

### [Update-FabricNotebook](Update-FabricNotebook.md)

Updates the properties of a Fabric Notebook.

### [Update-FabricNotebookDefinition](Update-FabricNotebookDefinition.md)

Updates the definition of a notebook in a Microsoft Fabric workspace.

### [Update-FabricPaginatedReport](Update-FabricPaginatedReport.md)

Updates an existing paginated report in a specified Microsoft Fabric workspace.

### [Update-FabricReflex](Update-FabricReflex.md)

Updates an existing Reflex in a specified Microsoft Fabric workspace.

### [Update-FabricReflexDefinition](Update-FabricReflexDefinition.md)

Updates the definition of an existing Reflex in a specified Microsoft Fabric workspace.

### [Update-FabricReport](Update-FabricReport.md)

Updates an existing Report in a specified Microsoft Fabric workspace.

### [Update-FabricReportDefinition](Update-FabricReportDefinition.md)

Updates the definition of an existing Report in a specified Microsoft Fabric workspace.

### [Update-FabricSemanticModel](Update-FabricSemanticModel.md)

Updates an existing SemanticModel in a specified Microsoft Fabric workspace.

### [Update-FabricSemanticModelDefinition](Update-FabricSemanticModelDefinition.md)

Updates the definition of an existing SemanticModel in a specified Microsoft Fabric workspace.

### [Update-FabricSparkCustomPool](Update-FabricSparkCustomPool.md)

Updates an existing Spark custom pool in a specified Microsoft Fabric workspace.

### [Update-FabricSparkJobDefinition](Update-FabricSparkJobDefinition.md)

Updates an existing SparkJobDefinition in a specified Microsoft Fabric workspace.

### [Update-FabricSparkJobDefinitionDefinition](Update-FabricSparkJobDefinitionDefinition.md)

Updates the definition of an existing SparkJobDefinition in a specified Microsoft Fabric workspace.

### [Update-FabricSparkSettings](Update-FabricSparkSettings.md)

Updates an existing Spark custom pool in a specified Microsoft Fabric workspace.

### [Update-FabricWarehouse](Update-FabricWarehouse.md)

Updates an existing warehouse in a specified Microsoft Fabric workspace.

### [Update-FabricWorkspace](Update-FabricWorkspace.md)

Updates the properties of a Fabric workspace.

### [Update-FabricWorkspaceRoleAssignment](Update-FabricWorkspaceRoleAssignment.md)

Updates the role assignment for a specific principal in a Fabric workspace.

### [Write-FabricLakehouseTableData](Write-FabricLakehouseTableData.md)

Loads data into a specified table in a Lakehouse within a Fabric workspace.

