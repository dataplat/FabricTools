function Get-FabricUserListAccessEntities {
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
        This example retrieves all access entities associated with the user having ID "user-12345".

        ```powershell
        Get-FabricUserListAccessEntities -UserId "user-12345"
        ```

    .EXAMPLE
        This example retrieves only the 'Dashboard' access entities associated with the user having ID "user-12345".

        ```powershell
        Get-FabricUserListAccessEntities -UserId "user-12345" -Type "Dashboard"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$UserId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('CopyJob', ' Dashboard', 'DataPipeline', 'Datamart', 'Environment', 'Eventhouse', 'Eventstream', 'GraphQLApi', 'KQLDashboard', 'KQLDatabase', 'KQLQueryset', 'Lakehouse', 'MLExperiment', 'MLModel', 'MirroredDatabase', 'MountedDataFactory', 'Notebook', 'PaginatedReport', 'Reflex', 'Report', 'SQLDatabase', 'SQLEndpoint', 'SemanticModel', 'SparkJobDefinition', 'VariableLibrary', 'Warehouse')]
        [string]$Type
    )

    try {

        Confirm-TokenState

        $apiEndpointUrl = "admin/users/{0}/access" -f $UserId
        if ($Type) {
            $apiEndpointUrl += "?type=$Type"
        }

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            HandleResponse = $true
            ExtractValue   = 'True'
            TypeName       = 'UserAccessEntity'
        }
        $response = Invoke-FabricRestMethod @apiParams

        return $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve user access entities. Error: $errorDetails" -Level Error
    }

}
