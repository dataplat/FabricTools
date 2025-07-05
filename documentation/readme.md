---
Module Name: FabricTools
Module Guid: f2a0f9e6-fab6-41fc-9e1c-0c94ff38f794
Download Help Link: {{ Update Download Link }}
Help Version: {{ Please enter version of help manually (X.X.X.X) format }}
Locale: en-US
---

# FabricTools Module
## Description
{{ Fill in the Description }}

## FabricTools Cmdlets
### [Add-FabricDomainWorkspaceAssignmentByCapacity](Add-FabricDomainWorkspaceAssignmentByCapacity.md)
The `Add-FabricDomainWorkspaceAssignmentByCapacity` function assigns workspaces to a Fabric domain using a list of capacity IDs by making a POST request to the relevant API endpoint.

### [Add-FabricDomainWorkspaceAssignmentById](Add-FabricDomainWorkspaceAssignmentById.md)
The `Add-FabricDomainWorkspaceAssignmentById` function sends a request to assign multiple workspaces to a specified domain using the provided domain ID and an array of workspace IDs.

### [Add-FabricDomainWorkspaceAssignmentByPrincipal](Add-FabricDomainWorkspaceAssignmentByPrincipal.md)
The `Add-FabricDomainWorkspaceAssignmentByPrincipal` function sends a request to assign workspaces to a specified domain using a JSON object of principal IDs and types.

### [Add-FabricDomainWorkspaceRoleAssignment](Add-FabricDomainWorkspaceRoleAssignment.md)
The `AssignFabricDomainWorkspaceRoleAssignment` function performs bulk role assignments for principals in a specific Fabric domain. It sends a POST request to the relevant API endpoint.

### [Add-FabricWorkspaceCapacityAssignment](Add-FabricWorkspaceCapacityAssignment.md)
The `Add-FabricWorkspaceCapacityAssignment` function sends a POST request to assign a workspace to a specific capacity.

### [Add-FabricWorkspaceIdentity](Add-FabricWorkspaceIdentity.md)
The `Add-FabricWorkspaceIdentity` function provisions an identity for a specified workspace by making an API call.

### [Add-FabricWorkspaceRoleAssignment](Add-FabricWorkspaceRoleAssignment.md)
The `Add-FabricWorkspaceRoleAssignments` function assigns a role (e.g., Admin, Contributor, Member, Viewer) to a principal (e.g., User, Group, ServicePrincipal) in a Fabric workspace by making a POST request to the API.

### [Connect-FabricAccount](Connect-FabricAccount.md)
Connects to the Fabric WebAPI by using the cmdlet Connect-AzAccount. This function retrieves the authentication token for the Fabric API and sets up the headers for API calls.

### [Convert-FromBase64](Convert-FromBase64.md)
The Convert-FromBase64 function takes a Base64-encoded string as input, decodes it into a byte array, and converts it back into a UTF-8 encoded string. It is useful for reversing Base64 encoding applied to text or other data.

### [Convert-ToBase64](Convert-ToBase64.md)
The Convert-ToBase64 function takes a file path as input, reads the file's content as a byte array, and converts it into a Base64-encoded string. This is useful for embedding binary data (e.g., images, documents) in text-based formats such as JSON or XML.

### [Export-FabricItem](Export-FabricItem.md)
The Export-FabricItem function exports items from a Fabric workspace to a specified directory. It can export items of type "Report", "SemanticModel", "SparkJobDefinitionV1" or "Notebook". If a specific item ID is provided, only that item will be exported. Otherwise, all items in the workspace will be exported.

### [Get-FabricAPIClusterURI](Get-FabricAPIClusterURI.md)
The Get-FabricAPIclusterURI function retrieves the cluster URI for the tenant. It supports multiple aliases for flexibility.

### [Get-FabricAuthToken](Get-FabricAuthToken.md)
The Get-FabricAuthToken function retrieves the Fabric API authentication token. If the token is not already set, the function fails.

### [Get-FabricCapacities](Get-FabricCapacities.md)
The Get-AllFabricCapacities function is used to retrieve all resources of type "Microsoft.Fabric/capacities" from all resource groups in a given subscription or all subscriptions if no subscription ID is provided. It uses the Az module to interact with Azure.

### [Get-FabricCapacity](Get-FabricCapacity.md)
This function retrieves capacity details from a specified workspace using either the provided capacityId or capacityName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricCapacityRefreshables](Get-FabricCapacityRefreshables.md)
The Get-FabricCapacityRefreshables function retrieves the top refreshable capacities for the tenant. It supports multiple aliases for flexibility.

### [Get-FabricCapacitySkus](Get-FabricCapacitySkus.md)
This function makes a GET request to the Fabric API to retrieve the tenant settings.

### [Get-FabricCapacityState](Get-FabricCapacityState.md)
The Get-FabricCapacityState function retrieves the state of a specific capacity. It supports multiple aliases for flexibility.

### [Get-FabricCapacityTenantOverrides](Get-FabricCapacityTenantOverrides.md)
The Get-FabricCapacityTenantOverrides function retrieves the tenant overrides for all capacities. It supports multiple aliases for flexibility.

### [Get-FabricCapacityTenantSettingOverrides](Get-FabricCapacityTenantSettingOverrides.md)
The `Get-FabricCapacityTenantSettingOverrides` function retrieves tenant setting overrides for a specific capacity or all capacities in the Fabric tenant by making a GET request to the appropriate API endpoint. If a `capacityId` is provided, the function retrieves overrides for that specific capacity. Otherwise, it retrieves overrides for all capacities.

### [Get-FabricCapacityWorkload](Get-FabricCapacityWorkload.md)
The Get-FabricCapacityWorkload function retrieves the workloads for a specific capacity. It supports multiple aliases for flexibility.

### [Get-FabricConfig](Get-FabricConfig.md)
Gets the configuration for use with all functions in the PSFabricTools module.

### [Get-FabricConnection](Get-FabricConnection.md)
The Get-FabricConnection function retrieves Fabric connections. It can retrieve all connections or the specified one only.

### [Get-FabricCopyJob](Get-FabricCopyJob.md)
This function retrieves CopyJob details from a specified workspace using either the provided CopyJobId or CopyJob. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricCopyJobDefinition](Get-FabricCopyJobDefinition.md)
This function fetches the Copy Job's content or metadata from a workspace. It supports both synchronous and asynchronous operations, with detailed logging and error handling.

### [Get-FabricDashboard](Get-FabricDashboard.md)
This function retrieves all dashboards from a specified workspace using the provided WorkspaceId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricDatamart](Get-FabricDatamart.md)
This function retrieves all datamarts from a specified workspace using the provided WorkspaceId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricDataPipeline](Get-FabricDataPipeline.md)
This function retrieves all data pipelines from a specified workspace using either the provided Data PipelineId or Data PipelineName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricDatasetRefreshes](Get-FabricDatasetRefreshes.md)
The Get-FabricDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of a specified dataset in a workspace. It uses the dataset ID and workspace ID to get the dataset and checks if it is refreshable. If it is, the function retrieves the refresh history.

### [Get-FabricDebugInfo](Get-FabricDebugInfo.md)
Shows internal debug information about the current session. It is useful for troubleshooting purposes. It will show you the current session object. This includes the bearer token. This can be useful for connecting to the REST API directly via Postman.

### [Get-FabricDomain](Get-FabricDomain.md)
The `Get-FabricDomain` function allows retrieval of domains in Microsoft Fabric, with optional filtering by domain ID or name. Additionally, it can filter to return only non-empty domains.

### [Get-FabricDomainTenantSettingOverrides](Get-FabricDomainTenantSettingOverrides.md)
The `Get-FabricDomainTenantSettingOverrides` function retrieves tenant setting overrides for all domains in the Fabric tenant by making a GET request to the designated API endpoint. The function ensures token validity before making the request and handles the response appropriately.

### [Get-FabricDomainWorkspace](Get-FabricDomainWorkspace.md)
The `Get-FabricDomainWorkspace` function fetches the workspaces for the given domain ID.

### [Get-FabricEnvironment](Get-FabricEnvironment.md)
The `Get-FabricEnvironment` function sends a GET request to the Fabric API to retrieve environment details for a given workspace. It can filter the results by `EnvironmentName`.

### [Get-FabricEnvironmentLibrary](Get-FabricEnvironmentLibrary.md)
The Get-FabricEnvironmentLibrary function fetches library information for a given workspace and environment using the Microsoft Fabric API. It ensures the authentication token is valid and validates the response to handle errors gracefully.

### [Get-FabricEnvironmentSparkCompute](Get-FabricEnvironmentSparkCompute.md)
The Get-FabricEnvironmentSparkCompute function communicates with the Microsoft Fabric API to fetch information about Spark compute resources associated with a specified environment. It ensures that the API token is valid and gracefully handles errors during the API call.

### [Get-FabricEnvironmentStagingLibrary](Get-FabricEnvironmentStagingLibrary.md)
The Get-FabricEnvironmentStagingLibrary function interacts with the Microsoft Fabric API to fetch information about staging libraries associated with a specified environment. It ensures token validity and handles API errors gracefully.

### [Get-FabricEnvironmentStagingSparkCompute](Get-FabricEnvironmentStagingSparkCompute.md)
The Get-FabricEnvironmentStagingSparkCompute function interacts with the Microsoft Fabric API to fetch information about staging Spark compute configurations for a specified environment. It ensures token validity and handles API errors gracefully.

### [Get-FabricEventhouse](Get-FabricEventhouse.md)
Retrieves Fabric Eventhouses. Without the EventhouseName or EventhouseID parameter, all Eventhouses are returned. If you want to retrieve a specific Eventhouse, you can use the EventhouseName or EventhouseID parameter. These parameters cannot be used together.

### [Get-FabricEventhouseDefinition](Get-FabricEventhouseDefinition.md)
This function retrieves the definition of an Eventhouse from a specified workspace using the provided EventhouseId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricEventstream](Get-FabricEventstream.md)
Retrieves Fabric Eventstreams. Without the EventstreamName or EventstreamID parameter, all Eventstreams are returned. If you want to retrieve a specific Eventstream, you can use the EventstreamName or EventstreamID parameter. These parameters cannot be used together.

### [Get-FabricEventstreamDefinition](Get-FabricEventstreamDefinition.md)
This function fetches the Eventstream's content or metadata from a workspace. Handles both synchronous and asynchronous operations, with detailed logging and error handling.

### [Get-FabricExternalDataShares](Get-FabricExternalDataShares.md)
This function retrieves External Data Shares details. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricItem](Get-FabricItem.md)
The Get-FabricItem function retrieves fabric items from a specified workspace. It can retrieve all items or filter them by item type.

### [Get-FabricKQLDashboard](Get-FabricKQLDashboard.md)
The `Get-FabricKQLDashboard` function sends a GET request to the Fabric API to retrieve KQLDashboard details for a given workspace. It can filter the results by `KQLDashboardName`.

### [Get-FabricKQLDashboardDefinition](Get-FabricKQLDashboardDefinition.md)
This function fetches the KQLDashboard's content or metadata from a workspace. Handles both synchronous and asynchronous operations, with detailed logging and error handling.

### [Get-FabricKQLDatabase](Get-FabricKQLDatabase.md)
The `Get-FabricKQLDatabase` function sends a GET request to the Fabric API to retrieve KQLDatabase details for a given workspace. It can filter the results by `KQLDatabaseName`.

### [Get-FabricKQLDatabaseDefinition](Get-FabricKQLDatabaseDefinition.md)
This function fetches the KQLDatabase's content or metadata from a workspace. It supports retrieving KQLDatabase definitions in the Jupyter KQLDatabase (`ipynb`) format. Handles both synchronous and asynchronous operations, with detailed logging and error handling.

### [Get-FabricKQLQueryset](Get-FabricKQLQueryset.md)
The `Get-FabricKQLQueryset` function sends a GET request to the Fabric API to retrieve KQLQueryset details for a given workspace. It can filter the results by `KQLQuerysetName`.

### [Get-FabricKQLQuerysetDefinition](Get-FabricKQLQuerysetDefinition.md)
This function fetches the KQLQueryset's content or metadata from a workspace. Handles both synchronous and asynchronous operations, with detailed logging and error handling.

### [Get-FabricLakehouse](Get-FabricLakehouse.md)
The `Get-FabricLakehouse` function sends a GET request to the Fabric API to retrieve Lakehouse details for a given workspace. It can filter the results by `LakehouseName`.

### [Get-FabricLakehouseTable](Get-FabricLakehouseTable.md)
This function retrieves tables from a specified Lakehouse in a Fabric workspace. It handles pagination using a continuation token to ensure all data is retrieved.

### [Get-FabricLongRunningOperation](Get-FabricLongRunningOperation.md)
The Get-FabricLongRunningOperation function queries the Microsoft Fabric API to check the status of a long-running operation. It periodically polls the operation until it reaches a terminal state (Succeeded or Failed).

### [Get-FabricLongRunningOperationResult](Get-FabricLongRunningOperationResult.md)
The Get-FabricLongRunningOperationResult function queries the Microsoft Fabric API to fetch the result of a specific long-running operation. This is typically used after confirming the operation has completed successfully.

### [Get-FabricMirroredDatabase](Get-FabricMirroredDatabase.md)
The `Get-FabricMirroredDatabase` function sends a GET request to the Fabric API to retrieve MirroredDatabase details for a given workspace. It can filter the results by `MirroredDatabaseName`.

### [Get-FabricMirroredDatabaseDefinition](Get-FabricMirroredDatabaseDefinition.md)
This function fetches the MirroredDatabase's content or metadata from a workspace. Handles both synchronous and asynchronous operations, with detailed logging and error handling.

### [Get-FabricMirroredDatabaseStatus](Get-FabricMirroredDatabaseStatus.md)
Retrieves the status of a mirrored database in a specified workspace. The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status. It handles errors and logs messages at various levels (Debug, Error).

### [Get-FabricMirroredDatabaseTableStatus](Get-FabricMirroredDatabaseTableStatus.md)
Retrieves the status of tables in a mirrored database. The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status of tables. It handles errors and logs messages at various levels (Debug, Error).

### [Get-FabricMirroredWarehouse](Get-FabricMirroredWarehouse.md)
The `Get-FabricMirroredWarehouse` function sends a GET request to the Fabric API to retrieve MirroredWarehouse details for a given workspace. It can filter the results by `MirroredWarehouseName`.

### [Get-FabricMLExperiment](Get-FabricMLExperiment.md)
This function retrieves ML Experiment details from a specified workspace using either the provided MLExperimentId or MLExperimentName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricMLModel](Get-FabricMLModel.md)
This function retrieves ML Model details from a specified workspace using either the provided MLModelId or MLModelName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricNotebook](Get-FabricNotebook.md)
The `Get-FabricNotebook` function sends a GET request to the Fabric API to retrieve Notebook details for a given workspace. It can filter the results by `NotebookName`.

### [Get-FabricNotebookDefinition](Get-FabricNotebookDefinition.md)
This function fetches the notebook's content or metadata from a workspace. It supports retrieving notebook definitions in the Jupyter Notebook (`ipynb`) format. Handles both synchronous and asynchronous operations, with detailed logging and error handling.

### [Get-FabricPaginatedReport](Get-FabricPaginatedReport.md)
This function retrieves paginated report details from a specified workspace using either the provided PaginatedReportId or PaginatedReportName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricRecoveryPoint](Get-FabricRecoveryPoint.md)
Get a list of Fabric recovery points. Results can be filter by date or type.

### [Get-FabricReflex](Get-FabricReflex.md)
This function retrieves Reflex details from a specified workspace using either the provided ReflexId or ReflexName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricReflexDefinition](Get-FabricReflexDefinition.md)
This function retrieves the definition of an Reflex from a specified workspace using the provided ReflexId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricReport](Get-FabricReport.md)
This function retrieves Report details from a specified workspace using either the provided ReportId or ReportName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricReportDefinition](Get-FabricReportDefinition.md)
This function retrieves the definition of an Report from a specified workspace using the provided ReportId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricSemanticModel](Get-FabricSemanticModel.md)
This function retrieves SemanticModel details from a specified workspace using either the provided SemanticModelId or SemanticModelName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricSemanticModelDefinition](Get-FabricSemanticModelDefinition.md)
This function retrieves the definition of an SemanticModel from a specified workspace using the provided SemanticModelId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricSparkCustomPool](Get-FabricSparkCustomPool.md)
This function retrieves all Spark custom pools from a specified workspace using the provided WorkspaceId. It handles token validation, constructs the API URL, makes the API request, and processes the response. The function supports filtering by SparkCustomPoolId or SparkCustomPoolName, but not both simultaneously.

### [Get-FabricSparkJobDefinition](Get-FabricSparkJobDefinition.md)
This function retrieves SparkJobDefinition details from a specified workspace using either the provided SparkJobDefinitionId or SparkJobDefinitionName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricSparkJobDefinitionDefinition](Get-FabricSparkJobDefinitionDefinition.md)
This function retrieves the definition of an SparkJobDefinition from a specified workspace using the provided SparkJobDefinitionId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricSparkSettings](Get-FabricSparkSettings.md)
This function retrieves Spark settings from a specified workspace using the provided WorkspaceId. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricSQLDatabase](Get-FabricSQLDatabase.md)
Retrieves Fabric SQL Database details. Without the SQLDatabaseName or SQLDatabaseID parameter, all SQL Databases are returned. If you want to retrieve a specific SQLDatabase, you can use the SQLDatabaseName or SQLDatabaseID parameter. These parameters cannot be used together.

### [Get-FabricSQLEndpoint](Get-FabricSQLEndpoint.md)
The Get-FabricSQLEndpoint function retrieves SQL Endpoints from a specified workspace in Fabric. It supports filtering by SQL Endpoint ID or SQL Endpoint Name. If both filters are provided, an error message is returned. The function handles token validation, API requests with continuation tokens, and processes the response to return the desired SQL Endpoint(s).

### [Get-FabricTenantSetting](Get-FabricTenantSetting.md)
The `Get-FabricTenantSetting` function retrieves tenant settings for a Fabric environment by making a GET request to the appropriate API endpoint. Optionally, it filters the results by the `SettingTitle` parameter.

### [Get-FabricUsageMetricsQuery](Get-FabricUsageMetricsQuery.md)
The Get-FabricUsageMetricsQuery function retrieves usage metrics for a specific dataset. It supports multiple aliases for flexibility.

### [Get-FabricUserListAccessEntities](Get-FabricUserListAccessEntities.md)
This function retrieves a list of access entities associated with a specified user in Microsoft Fabric. It supports filtering by entity type and handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricWarehouse](Get-FabricWarehouse.md)
This function retrieves warehouse details from a specified workspace using either the provided WarehouseId or WarehouseName. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Get-FabricWorkspace](Get-FabricWorkspace.md)
The `Get-FabricWorkspace` function fetches workspace details from the Fabric API. It supports filtering by WorkspaceId or WorkspaceName.

### [Get-FabricWorkspaceDatasetRefreshes](Get-FabricWorkspaceDatasetRefreshes.md)
The Get-FabricWorkspaceDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of all datasets in a specified workspace. It uses the workspace ID to get the workspace and its datasets, and then retrieves the refresh history for each dataset.

### [Get-FabricWorkspaceRoleAssignment](Get-FabricWorkspaceRoleAssignment.md)
The `Get-FabricWorkspaceRoleAssignments` function fetches the role assignments associated with a Fabric workspace by making a GET request to the API. If `WorkspaceRoleAssignmentId` is provided, it retrieves the specific role assignment.

### [Get-FabricWorkspaceTenantSettingOverrides](Get-FabricWorkspaceTenantSettingOverrides.md)
The `Get-FabricWorkspaceTenantSettingOverrides` function retrieves tenant setting overrides for all workspaces in the Fabric tenant by making a GET request to the appropriate API endpoint. The function validates the authentication token before making the request and handles the response accordingly.

### [Get-FabricWorkspaceUsageMetricsData](Get-FabricWorkspaceUsageMetricsData.md)
The Get-FabricWorkspaceUsageMetricsData function retrieves workspace usage metrics. It supports multiple aliases for flexibility.

### [Get-FabricWorkspaceUser](Get-FabricWorkspaceUser.md)
The Get-FabricWorkspaceUser function retrieves the details of the users of a workspace.

### [Get-SHA256](Get-SHA256.md)
The Get-Sha256 function calculates the SHA256 hash of a string.

### [Import-FabricEnvironmentStagingLibrary](Import-FabricEnvironmentStagingLibrary.md)
This function sends a POST request to the Microsoft Fabric API to upload a library to the specified environment staging area for the given workspace.

### [Import-FabricItem](Import-FabricItem.md)
The Import-FabricItem function imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source. It supports multiple aliases for flexibility. The function handles the import of datasets and reports, ensuring that the correct item type is used and that the items are created or updated as necessary.

### [Invoke-FabricAPIRequest_duplicate](Invoke-FabricAPIRequest_duplicate.md)
The Invoke-RestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response. It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

### [Invoke-FabricDatasetRefresh](Invoke-FabricDatasetRefresh.md)
The Invoke-FabricDatasetRefresh function is used to refresh a PowerBI dataset. It first checks if the dataset is refreshable. If it is not, it writes an error. If it is, it invokes a PowerBI REST method to refresh the dataset. The URL for the request is constructed using the provided dataset ID.

### [Invoke-FabricKQLCommand](Invoke-FabricKQLCommand.md)
Executes a KQL command in a Kusto Database. The KQL command is executed in the Kusto Database that is specified by the KQLDatabaseName or KQLDatabaseId parameter. The KQL command is executed in the context of the Fabric Real-Time Intelligence session that is established by the Connect-RTISession cmdlet. The cmdlet distinguishes between management commands and query commands. Management commands are executed in the management API, while query commands are executed in the query API. The distinction is made by checking if the KQL command starts with a dot. If it does, it is a management command else it is a query command. If the KQL command is a management command, it is crucial to have the execute database script <| in the beginning, otherwise the Kusto API will not execute the script. This cmdlet will automatically add the .execute database script <| in the beginning of the KQL command if it is a management command and if it is not already present. If the KQL Command is a query command, the result is returned as an array of PowerShell objects by default. If the parameter -ReturnRawResult is used, the raw result of the KQL query is returned which is a JSON object.

### [Invoke-FabricRestMethod](Invoke-FabricRestMethod.md)
The Invoke-FabricRestMethod function is used to send an HTTP request to a Fabric API endpoint and retrieve the response.

### [Invoke-FabricRestMethodExtended](Invoke-FabricRestMethodExtended.md)
The Invoke-FabricRestMethodExtended function is used to send an HTTP request to a Fabric API endpoint and retrieve the response. It handles various aspects such as authentication, 429 throttling, and Long-Running-Operation (LRO) response.

### [New-FabricCopyJob](New-FabricCopyJob.md)
Sends a POST request to the Microsoft Fabric API to create a new copy job in the specified workspace. Supports optional parameters for description and definition files.

### [New-FabricDataPipeline](New-FabricDataPipeline.md)
This function sends a POST request to the Microsoft Fabric API to create a new DataPipeline in the specified workspace. It supports optional parameters for DataPipeline description and path definitions for the DataPipeline content.

### [New-FabricDomain](New-FabricDomain.md)
The `Add-FabricDomain` function creates a new domain in Microsoft Fabric by making a POST request to the relevant API endpoint.

### [New-FabricEnvironment](New-FabricEnvironment.md)
The `Add-FabricEnvironment` function creates a new environment within a given workspace by making a POST request to the Fabric API. The environment can optionally include a description.

### [New-FabricEventhouse](New-FabricEventhouse.md)
This function sends a POST request to the Microsoft Fabric API to create a new Eventhouse in the specified workspace. It supports optional parameters for Eventhouse description and path definitions.

### [New-FabricEventstream](New-FabricEventstream.md)
This function sends a POST request to the Microsoft Fabric API to create a new Eventstream in the specified workspace. It supports optional parameters for Eventstream description and path definitions for the Eventstream content.

### [New-FabricKQLDashboard](New-FabricKQLDashboard.md)
This function sends a POST request to the Microsoft Fabric API to create a new KQLDashboard in the specified workspace. It supports optional parameters for KQLDashboard description and path definitions for the KQLDashboard content.

### [New-FabricKQLDatabase](New-FabricKQLDatabase.md)
This function sends a POST request to the Microsoft Fabric API to create a new KQLDatabase in the specified workspace. It supports optional parameters for KQLDatabase description and path definitions for the KQLDatabase content.

### [New-FabricKQLQueryset](New-FabricKQLQueryset.md)
This function sends a POST request to the Microsoft Fabric API to create a new KQLQueryset in the specified workspace. It supports optional parameters for KQLQueryset description and path definitions for the KQLQueryset content.

### [New-FabricLakehouse](New-FabricLakehouse.md)
This function sends a POST request to the Microsoft Fabric API to create a new Lakehouse in the specified workspace. It supports optional parameters for Lakehouse description and path definitions for the Lakehouse content.

### [New-FabricMirroredDatabase](New-FabricMirroredDatabase.md)
This function sends a POST request to the Microsoft Fabric API to create a new MirroredDatabase in the specified workspace. It supports optional parameters for MirroredDatabase description and path definitions for the MirroredDatabase content.

### [New-FabricMLExperiment](New-FabricMLExperiment.md)
This function sends a POST request to the Microsoft Fabric API to create a new ML Experiment in the specified workspace. It supports optional parameters for ML Experiment description.

### [New-FabricMLModel](New-FabricMLModel.md)
This function sends a POST request to the Microsoft Fabric API to create a new ML Model in the specified workspace. It supports optional parameters for ML Model description.

### [New-FabricNotebook](New-FabricNotebook.md)
This function sends a POST request to the Microsoft Fabric API to create a new notebook in the specified workspace. It supports optional parameters for notebook description and path definitions for the notebook content.

### [New-FabricNotebookNEW](New-FabricNotebookNEW.md)
This function sends a POST request to the Microsoft Fabric API to create a new notebook in the specified workspace. It supports optional parameters for notebook description and path definitions for the notebook content.

### [New-FabricRecoveryPoint](New-FabricRecoveryPoint.md)
Create a recovery point for a Fabric data warehouse

### [New-FabricReflex](New-FabricReflex.md)
This function sends a POST request to the Microsoft Fabric API to create a new Reflex in the specified workspace. It supports optional parameters for Reflex description and path definitions.

### [New-FabricReport](New-FabricReport.md)
This function sends a POST request to the Microsoft Fabric API to create a new Report in the specified workspace. It supports optional parameters for Report description and path definitions.

### [New-FabricSemanticModel](New-FabricSemanticModel.md)
This function sends a POST request to the Microsoft Fabric API to create a new SemanticModel in the specified workspace. It supports optional parameters for SemanticModel description and path definitions.

### [New-FabricSparkCustomPool](New-FabricSparkCustomPool.md)
This function sends a POST request to the Microsoft Fabric API to create a new Spark custom pool in the specified workspace. It supports various parameters for Spark custom pool configuration.

### [New-FabricSparkJobDefinition](New-FabricSparkJobDefinition.md)
This function sends a POST request to the Microsoft Fabric API to create a new SparkJobDefinition in the specified workspace. It supports optional parameters for SparkJobDefinition description and path definitions.

### [New-FabricSQLDatabase](New-FabricSQLDatabase.md)
This function sends a POST request to the Microsoft Fabric API to create a new SQL Database in the specified workspace. It supports optional parameters for SQL Database description and path definitions for the SQL Database content.

### [New-FabricWarehouse](New-FabricWarehouse.md)
This function sends a POST request to the Microsoft Fabric API to create a new warehouse in the specified workspace. It supports optional parameters for warehouse description.

### [New-FabricWorkspace](New-FabricWorkspace.md)
The `Add-FabricWorkspace` function creates a new workspace in the Fabric platform by sending a POST request to the API. It validates the display name and handles both success and error responses.

### [New-FabricWorkspaceUsageMetricsReport](New-FabricWorkspaceUsageMetricsReport.md)
The New-FabricWorkspaceUsageMetricsReport function retrieves the workspace usage metrics dataset ID. It supports multiple aliases for flexibility.

### [Publish-FabricEnvironment](Publish-FabricEnvironment.md)
This function interacts with the Microsoft Fabric API to initiate the publishing process for a staging environment. It validates the authentication token, constructs the API request, and handles both immediate and long-running operations.

### [Register-FabricWorkspaceToCapacity](Register-FabricWorkspaceToCapacity.md)
The Register-FabricWorkspaceToCapacity function Sets a PowerBI workspace to a capacity. It supports multiple aliases for flexibility.

### [Remove-FabricCopyJob](Remove-FabricCopyJob.md)
This function performs a DELETE operation on the Microsoft Fabric API to remove a Copy Job from the specified workspace using the provided WorkspaceId and CopyJobId parameters.

### [Remove-FabricDataPipeline](Remove-FabricDataPipeline.md)
This function sends a DELETE request to the Microsoft Fabric API to remove a DataPipeline from the specified workspace using the provided WorkspaceId and DataPipelineId.

### [Remove-FabricDomain](Remove-FabricDomain.md)
The `Remove-FabricDomain` function removes a specified domain from Microsoft Fabric by making a DELETE request to the relevant API endpoint.

### [Remove-FabricDomainWorkspaceAssignment](Remove-FabricDomainWorkspaceAssignment.md)
The `Unassign -FabricDomainWorkspace` function allows you to Unassign specific workspaces from a given Fabric domain or unassign all workspaces if no workspace IDs are specified. It makes a POST request to the relevant API endpoint for this operation.

### [Remove-FabricDomainWorkspaceRoleAssignment](Remove-FabricDomainWorkspaceRoleAssignment.md)
The `AssignFabricDomainWorkspaceRoleAssignment` function performs bulk role assignments for principals in a specific Fabric domain. It sends a POST request to the relevant API endpoint.

### [Remove-FabricEnvironment](Remove-FabricEnvironment.md)
The `Remove-FabricEnvironment` function sends a DELETE request to the Fabric API to remove a specified environment from a given workspace.

### [Remove-FabricEnvironmentStagingLibrary](Remove-FabricEnvironmentStagingLibrary.md)
This function allows for the deletion of a library from the staging environment, one file at a time. It ensures token validity, constructs the appropriate API request, and handles both success and failure responses.

### [Remove-FabricEventhouse](Remove-FabricEventhouse.md)
This function sends a DELETE request to the Microsoft Fabric API to remove an Eventhouse from the specified workspace using the provided WorkspaceId and EventhouseId.

### [Remove-FabricEventstream](Remove-FabricEventstream.md)
The `Remove-FabricEventstream` function sends a DELETE request to the Fabric API to remove a specified Eventstream from a given workspace.

### [Remove-FabricItem](Remove-FabricItem.md)
The Remove-FabricItems function removes selected items from a specified Fabric workspace. It uses the workspace ID and an optional filter to select the items to remove. If a filter is provided, only items whose DisplayName matches the filter are removed.

### [Remove-FabricKQLDashboard](Remove-FabricKQLDashboard.md)
The `Remove-FabricKQLDashboard` function sends a DELETE request to the Fabric API to remove a specified KQLDashboard from a given workspace.

### [Remove-FabricKQLDatabase](Remove-FabricKQLDatabase.md)
The `Remove-FabricKQLDatabase` function sends a DELETE request to the Fabric API to remove a specified KQLDatabase from a given workspace.

### [Remove-FabricKQLQueryset](Remove-FabricKQLQueryset.md)
The `Remove-FabricKQLQueryset` function sends a DELETE request to the Fabric API to remove a specified KQLQueryset from a given workspace.

### [Remove-FabricLakehouse](Remove-FabricLakehouse.md)
The `Remove-FabricLakehouse` function sends a DELETE request to the Fabric API to remove a specified Lakehouse from a given workspace.

### [Remove-FabricMirroredDatabase](Remove-FabricMirroredDatabase.md)
The `Remove-FabricMirroredDatabase` function sends a DELETE request to the Fabric API to remove a specified MirroredDatabase from a given workspace.

### [Remove-FabricMLExperiment](Remove-FabricMLExperiment.md)
This function sends a DELETE request to the Microsoft Fabric API to remove an ML Experiment from the specified workspace using the provided WorkspaceId and MLExperimentId.

### [Remove-FabricMLModel](Remove-FabricMLModel.md)
This function sends a DELETE request to the Microsoft Fabric API to remove an ML Model from the specified workspace using the provided WorkspaceId and MLModelId.

### [Remove-FabricNotebook](Remove-FabricNotebook.md)
The `Remove-FabricNotebook` function sends a DELETE request to the Fabric API to remove a specified Notebook from a given workspace.

### [Remove-FabricRecoveryPoint](Remove-FabricRecoveryPoint.md)
Remove a selected Fabric Recovery Point.

### [Remove-FabricReflex](Remove-FabricReflex.md)
This function sends a DELETE request to the Microsoft Fabric API to remove an Reflex from the specified workspace using the provided WorkspaceId and ReflexId.

### [Remove-FabricReport](Remove-FabricReport.md)
This function sends a DELETE request to the Microsoft Fabric API to remove an Report from the specified workspace using the provided WorkspaceId and ReportId.

### [Remove-FabricSemanticModel](Remove-FabricSemanticModel.md)
This function sends a DELETE request to the Microsoft Fabric API to remove an SemanticModel from the specified workspace using the provided WorkspaceId and SemanticModelId.

### [Remove-FabricSparkCustomPool](Remove-FabricSparkCustomPool.md)
This function sends a DELETE request to the Microsoft Fabric API to remove a Spark custom pool from the specified workspace using the provided WorkspaceId and SparkCustomPoolId.

### [Remove-FabricSparkJobDefinition](Remove-FabricSparkJobDefinition.md)
This function sends a DELETE request to the Microsoft Fabric API to remove an SparkJobDefinition from the specified workspace using the provided WorkspaceId and SparkJobDefinitionId.

### [Remove-FabricSQLDatabase](Remove-FabricSQLDatabase.md)
The `Remove-FabricSQLDatabase` function sends a DELETE request to the Fabric API to remove a specified SQLDatabase from a given workspace.

### [Remove-FabricWarehouse](Remove-FabricWarehouse.md)
This function sends a DELETE request to the Microsoft Fabric API to remove a warehouse from the specified workspace using the provided WorkspaceId and WarehouseId.

### [Remove-FabricWorkspace](Remove-FabricWorkspace.md)
The `Remove-FabricWorkspace` function deletes a workspace in the Fabric platform by sending a DELETE request to the API. It validates the workspace ID and handles both success and error responses.

### [Remove-FabricWorkspaceCapacityAssignment](Remove-FabricWorkspaceCapacityAssignment.md)
The `Remove-FabricWorkspaceCapacityAssignment` function sends a POST request to unassign a workspace from its assigned capacity.

### [Remove-FabricWorkspaceIdentity](Remove-FabricWorkspaceIdentity.md)
The `Remove-FabricWorkspaceCapacity` function deprovisions the Managed Identity from the given workspace by calling the appropriate API endpoint.

### [Remove-FabricWorkspaceRoleAssignment](Remove-FabricWorkspaceRoleAssignment.md)
The `Remove-FabricWorkspaceRoleAssignment` function deletes a specific role assignment from a Fabric workspace by making a DELETE request to the API.

### [Restore-FabricRecoveryPoint](Restore-FabricRecoveryPoint.md)
Restore a Fabric data warehouse to a specified restore pont.

### [Resume-FabricCapacity](Resume-FabricCapacity.md)
The Resume-FabricCapacity function resumes a capacity. It supports multiple aliases for flexibility.

### [Revoke-FabricCapacityTenantSettingOverrides](Revoke-FabricCapacityTenantSettingOverrides.md)
The `Revoke-FabricCapacityTenantSettingOverrides` function deletes a specific tenant setting override for a given capacity in the Fabric tenant by making a DELETE request to the appropriate API endpoint.

### [Revoke-FabricExternalDataShares](Revoke-FabricExternalDataShares.md)
This function retrieves External Data Shares details. It handles token validation, constructs the API URL, makes the API request, and processes the response.

### [Set-FabricConfig](Set-FabricConfig.md)
Register the configuration for use with all functions in the PSFabricTools module.

### [Start-FabricLakehouseTableMaintenance](Start-FabricLakehouseTableMaintenance.md)
This function sends a POST request to the Fabric API to start a table maintenance job for a specified Lakehouse. It allows for optional parameters such as schema name, table name, and Z-ordering columns. The function also handles asynchronous operations and can wait for completion if specified.

### [Start-FabricMirroredDatabaseMirroring](Start-FabricMirroredDatabaseMirroring.md)
This function sends a POST request to the Microsoft Fabric API to start the mirroring of a specified mirrored database. It requires the workspace ID and the mirrored database ID as parameters.

### [Start-FabricSparkJobDefinitionOnDemand](Start-FabricSparkJobDefinitionOnDemand.md)
This function initiates a Spark Job Definition on demand within a specified workspace. It constructs the appropriate API endpoint URL and makes a POST request to start the job. The function can optionally wait for the job to complete based on the 'waitForCompletion' parameter.

### [Stop-FabricEnvironmentPublish](Stop-FabricEnvironmentPublish.md)
This function sends a cancel publish request to the Microsoft Fabric API for a given environment. It ensures that the token is valid before making the request and handles both successful and error responses.

### [Stop-FabricMirroredDatabaseMirroring](Stop-FabricMirroredDatabaseMirroring.md)
This function sends a POST request to the Microsoft Fabric API to stop the mirroring of a specified mirrored database. It requires the workspace ID and the mirrored database ID as parameters.

### [Suspend-FabricCapacity](Suspend-FabricCapacity.md)
The Suspend-FabricCapacity function suspends a capacity. It supports multiple aliases for flexibility.

### [Unregister-FabricWorkspaceToCapacity](Unregister-FabricWorkspaceToCapacity.md)
The Unregister-FabricWorkspaceToCapacity function unregisters a workspace from a capacity in PowerBI. It can be used to remove a workspace from a capacity, allowing it to be assigned to a different capacity or remain unassigned.

### [Update-FabricCapacityTenantSettingOverrides](Update-FabricCapacityTenantSettingOverrides.md)
The `Update-FabricCapacityTenantSettingOverrides` function updates tenant setting overrides in a Fabric environment by making a POST request to the appropriate API endpoint. It allows specifying settings such as enabling tenant settings, delegating to a workspace, and including or excluding security groups.

### [Update-FabricCopyJob](Update-FabricCopyJob.md)
Sends a PATCH request to the Microsoft Fabric API to update an existing Copy Job in the specified workspace. Allows updating the Copy Job's name and optionally its description.

### [Update-FabricCopyJobDefinition](Update-FabricCopyJobDefinition.md)
This function updates the content or metadata of a Copy Job within a Microsoft Fabric workspace. The Copy Job content and platform-specific definitions can be provided as file paths, which will be encoded as Base64 and sent in the request.

### [Update-FabricDataPipeline](Update-FabricDataPipeline.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing DataPipeline in the specified workspace. It supports optional parameters for DataPipeline description.

### [Update-FabricDomain](Update-FabricDomain.md)
The `Update-FabricDomain` function modifies a specified domain in Microsoft Fabric using the provided parameters.

### [Update-FabricEnvironment](Update-FabricEnvironment.md)
The `Update-FabricEnvironment` function updates the name and/or description of a specified Fabric Environment by making a PATCH request to the API.

### [Update-FabricEnvironmentStagingSparkCompute](Update-FabricEnvironmentStagingSparkCompute.md)
This function sends a PATCH request to the Microsoft Fabric API to update the Spark compute settings for a specified environment, including instance pool, driver and executor configurations, and dynamic allocation settings.

### [Update-FabricEventhouse](Update-FabricEventhouse.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing Eventhouse in the specified workspace. It supports optional parameters for Eventhouse description.

### [Update-FabricEventhouseDefinition](Update-FabricEventhouseDefinition.md)
This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing Eventhouse in the specified workspace. It supports optional parameters for Eventhouse definition and platform-specific definition.

### [Update-FabricEventstream](Update-FabricEventstream.md)
The `Update-FabricEventstream` function updates the name and/or description of a specified Fabric Eventstream by making a PATCH request to the API.

### [Update-FabricEventstreamDefinition](Update-FabricEventstreamDefinition.md)
This function allows updating the content or metadata of a Eventstream in a Microsoft Fabric workspace. The Eventstream content can be provided as file paths, and metadata updates can optionally be enabled.

### [Update-FabricKQLDashboard](Update-FabricKQLDashboard.md)
The `Update-FabricKQLDashboard` function updates the name and/or description of a specified Fabric KQLDashboard by making a PATCH request to the API.

### [Update-FabricKQLDashboardDefinition](Update-FabricKQLDashboardDefinition.md)
This function allows updating the content or metadata of a KQLDashboard in a Microsoft Fabric workspace. The KQLDashboard content can be provided as file paths, and metadata updates can optionally be enabled.

### [Update-FabricKQLDatabase](Update-FabricKQLDatabase.md)
The `Update-FabricKQLDatabase` function updates the name and/or description of a specified Fabric KQLDatabase by making a PATCH request to the API.

### [Update-FabricKQLDatabaseDefinition](Update-FabricKQLDatabaseDefinition.md)
This function allows updating the content or metadata of a KQLDatabase in a Microsoft Fabric workspace. The KQLDatabase content can be provided as file paths, and metadata updates can optionally be enabled.

### [Update-FabricKQLQueryset](Update-FabricKQLQueryset.md)
The `Update-FabricKQLQueryset` function updates the name and/or description of a specified Fabric KQLQueryset by making a PATCH request to the API.

### [Update-FabricKQLQuerysetDefinition](Update-FabricKQLQuerysetDefinition.md)
This function allows updating the content or metadata of a KQLQueryset in a Microsoft Fabric workspace. The KQLQueryset content can be provided as file paths, and metadata updates can optionally be enabled.

### [Update-FabricLakehouse](Update-FabricLakehouse.md)
The `Update-FabricLakehouse` function updates the name and/or description of a specified Fabric Lakehouse by making a PATCH request to the API.

### [Update-FabricMirroredDatabase](Update-FabricMirroredDatabase.md)
The `Update-FabricMirroredDatabase` function updates the name and/or description of a specified Fabric MirroredDatabase by making a PATCH request to the API.

### [Update-FabricMirroredDatabaseDefinition](Update-FabricMirroredDatabaseDefinition.md)
This function allows updating the content or metadata of a MirroredDatabase in a Microsoft Fabric workspace. The MirroredDatabase content can be provided as file paths, and metadata updates can optionally be enabled.

### [Update-FabricMLExperiment](Update-FabricMLExperiment.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing ML Experiment in the specified workspace. It supports optional parameters for ML Experiment description.

### [Update-FabricMLModel](Update-FabricMLModel.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing ML Model in the specified workspace. It supports optional parameters for ML Model description.

### [Update-FabricNotebook](Update-FabricNotebook.md)
The `Update-FabricNotebook` function updates the name and/or description of a specified Fabric Notebook by making a PATCH request to the API.

### [Update-FabricNotebookDefinition](Update-FabricNotebookDefinition.md)
This function allows updating the content or metadata of a notebook in a Microsoft Fabric workspace. The notebook content can be provided as file paths, and metadata updates can optionally be enabled.

### [Update-FabricPaginatedReport](Update-FabricPaginatedReport.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing paginated report in the specified workspace. It supports optional parameters for paginated report description.

### [Update-FabricReflex](Update-FabricReflex.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing Reflex in the specified workspace. It supports optional parameters for Reflex description.

### [Update-FabricReflexDefinition](Update-FabricReflexDefinition.md)
This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing Reflex in the specified workspace. It supports optional parameters for Reflex definition and platform-specific definition.

### [Update-FabricReport](Update-FabricReport.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing Report in the specified workspace. It supports optional parameters for Report description.

### [Update-FabricReportDefinition](Update-FabricReportDefinition.md)
This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing Report in the specified workspace. It supports optional parameters for Report definition and platform-specific definition.

### [Update-FabricSemanticModel](Update-FabricSemanticModel.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing SemanticModel in the specified workspace. It supports optional parameters for SemanticModel description.

### [Update-FabricSemanticModelDefinition](Update-FabricSemanticModelDefinition.md)
This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing SemanticModel in the specified workspace. It supports optional parameters for SemanticModel definition and platform-specific definition.

### [Update-FabricSparkCustomPool](Update-FabricSparkCustomPool.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing Spark custom pool in the specified workspace. It supports various parameters for Spark custom pool configuration.

### [Update-FabricSparkJobDefinition](Update-FabricSparkJobDefinition.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing SparkJobDefinition in the specified workspace. It supports optional parameters for SparkJobDefinition description.

### [Update-FabricSparkJobDefinitionDefinition](Update-FabricSparkJobDefinitionDefinition.md)
This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing SparkJobDefinition in the specified workspace. It supports optional parameters for SparkJobDefinition definition and platform-specific definition.

### [Update-FabricSparkSettings](Update-FabricSparkSettings.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing Spark custom pool in the specified workspace. It supports various parameters for Spark custom pool configuration.

### [Update-FabricWarehouse](Update-FabricWarehouse.md)
This function sends a PATCH request to the Microsoft Fabric API to update an existing warehouse in the specified workspace. It supports optional parameters for warehouse description.

### [Update-FabricWorkspace](Update-FabricWorkspace.md)
The `Update-FabricWorkspace` function updates the name and/or description of a specified Fabric workspace by making a PATCH request to the API.

### [Update-FabricWorkspaceRoleAssignment](Update-FabricWorkspaceRoleAssignment.md)
The `Update-FabricWorkspaceRoleAssignment` function updates the role assigned to a principal in a workspace by making a PATCH request to the API.

### [Write-FabricLakehouseTableData](Write-FabricLakehouseTableData.md)
Loads data into a specified table in a Lakehouse within a Fabric workspace. The function supports loading data from files or folders, with options for file format and CSV settings.

