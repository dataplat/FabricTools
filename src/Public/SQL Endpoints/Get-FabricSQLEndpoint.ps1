function Get-FabricSQLEndpoint {
    <#
    .SYNOPSIS
        Retrieves SQL Endpoints from a specified workspace in Fabric.

    .DESCRIPTION
        The `Get-FabricSQLEndpoint` function retrieves SQL Endpoints from a specified workspace in Fabric.
        It supports filtering by SQL Endpoint ID or SQL Endpoint Name. If both filters are provided,
        an error message is returned. The function handles token validation, API requests with continuation
        tokens, and processes the response to return the desired SQL Endpoint(s).

    .PARAMETER WorkspaceId
        The ID of the workspace from which to retrieve SQL Endpoints. This parameter is mandatory.

    .PARAMETER SQLEndpointId
        The ID of the SQL Endpoint to retrieve. This parameter is optional but cannot be used together with SQLEndpointName.

    .PARAMETER SQLEndpointName
        The name of the SQL Endpoint to retrieve. This parameter is optional but cannot be used together with SQLEndpointId.

    .EXAMPLE
        ```powershell
        Get-FabricSQLEndpoint -WorkspaceId "workspace123" -SQLEndpointId "endpoint456"
        ```

    .EXAMPLE
        ```powershell
        Get-FabricSQLEndpoint -WorkspaceId "workspace123" -SQLEndpointName "MySQLEndpoint"
        ```

    .NOTES
        Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$SQLEndpointId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SQLEndpointName
    )

    try {
        # Handle ambiguous input
        if ($SQLEndpointId -and $SQLEndpointName) {
            Write-Message -Message "Both 'SQLEndpointId' and 'SQLEndpointName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/SQLEndpoints"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve SQL Endpoints
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $SQLEndpoints = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $SQLEndpoint = if ($SQLEndpointId) {
            $SQLEndpoints | Where-Object { $_.Id -eq $SQLEndpointId }
        } elseif ($SQLEndpointName) {
            $SQLEndpoints | Where-Object { $_.DisplayName -eq $SQLEndpointName }
        } else {
            # Return all SQLEndpoints if no filter is provided
            Write-Message -Message "No filter provided. Returning all SQL Endpoints." -Level Debug
            $SQLEndpoints
        }

        # Handle results
        if ($SQLEndpoint) {
            Write-Message -Message "SQL Endpoint found matching the specified criteria." -Level Debug
            return $SQLEndpoint
        } else {
            Write-Message -Message "No SQL Endpoint found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Paginated Report. Error: $errorDetails" -Level Error
    }
}
