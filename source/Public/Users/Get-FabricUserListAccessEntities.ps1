<#
.SYNOPSIS
    Retrieves access entities for a specified user in Microsoft Fabric.

.DESCRIPTION
    This function retrieves a list of access entities associated with a specified user in Microsoft Fabric.
    It supports filtering by entity type and handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER UserId
    The unique identifier of the user whose access entities are to be retrieved. This parameter is mandatory.

.PARAMETER Type
    The type of access entity to filter the results by. This parameter is optional and supports predefined values such as 'CopyJob', 'Dashboard', 'DataPipeline', etc.

.EXAMPLE
    Get-FabricUserListAccessEntities -UserId "user-12345"
    This example retrieves all access entities associated with the user having ID "user-12345".

.EXAMPLE
    Get-FabricUserListAccessEntities -UserId "user-12345" -Type "Dashboard"
    This example retrieves only the 'Dashboard' access entities associated with the user having ID "user-12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
function Get-FabricUserListAccessEntities {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$UserId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('CopyJob', ' Dashboard', 'DataPipeline', 'Datamart', 'Environment', 'Eventhouse', 'Eventstream', 'GraphQLApi', 'KQLDashboard', 'KQLDatabase', 'KQLQueryset', 'Lakehouse', 'MLExperiment', 'MLModel', 'MirroredDatabase', 'MountedDataFactory', 'Notebook', 'PaginatedReport', 'Reflex', 'Report', 'SQLDatabase', 'SQLEndpoint', 'SemanticModel', 'SparkJobDefinition', 'VariableLibrary', 'Warehouse')]
        [string]$Type
    )

    try {

        Write-Message -Message "Validating token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Token validation completed." -Level Debug


        # Step 4: Loop to retrieve all capacities with continuation token
        $apiEndpointURI = "{0}admin/users/{1}/access" -f $FabricConfig.BaseUrl, $UserId
        if ($Type) {
            $apiEndpointURI += "?type=$Type"
        }

        $response = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointURI `
            -Headers $FabricConfig.FabricHeaders `
            -Method Get

        return $response
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Warehouse. Error: $errorDetails" -Level Error
    }

}