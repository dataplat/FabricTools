function Get-FabricDatamart {
    <#
.SYNOPSIS
    Retrieves datamarts from a specified workspace.

.DESCRIPTION
    This function retrieves all datamarts from a specified workspace using the provided WorkspaceId.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The ID of the workspace from which to retrieve datamarts. This parameter is mandatory.

.PARAMETER datamartId
    The ID of the specific datamart to retrieve. This parameter is optional.

.PARAMETER datamartName
    The name of the specific datamart to retrieve. This parameter is optional.

.EXAMPLE
    Get-FabricDatamart -WorkspaceId "12345"
    This example retrieves all datamarts from the workspace with ID "12345".

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$datamartId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$datamartName
    )

    try {
        # Step 2: Ensure token validity
        Confirm-TokenState
        # Step 3: Initialize variables

        $apiEndpointURI = "workspaces/{0}/Datamarts" -f $WorkspaceId

        $apiParams = @{
            Uri    = $apiEndpointURI
            method = 'Get'
        }
        $Datamarts = Invoke-FabricRestMethod @apiParams

        # Step 9: Filter results based on provided parameters

        $response = if ($datamartId) {
            $Datamarts | Where-Object { $_.Id -eq $datamartId }
        } elseif ($datamartName) {
            $Datamarts | Where-Object { $_.DisplayName -eq $datamartName }
        } else {
            # No filter, return all datamarts
            Write-Message -Message "No filter specified. Returning all datamarts." -Level Debug
            return $Datamarts
        }

        # Step 10: Handle results
        if ($response) {
            Write-Message -Message "Datamart found matching the specified criteria." -Level Debug
            return $response
        } else {
            Write-Message -Message "No Datamart found matching the specified criteria." -Level Warning
            return $null
        }
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Datamart. Error: $errorDetails" -Level Error
    }
}
