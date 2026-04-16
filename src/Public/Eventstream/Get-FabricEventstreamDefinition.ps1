function Get-FabricEventstreamDefinition {
<#
.SYNOPSIS
Retrieves the definition of a Eventstream from a specific workspace in Microsoft Fabric.

.DESCRIPTION
This function fetches the Eventstream's content or metadata from a workspace.
Handles both synchronous and asynchronous operations, with detailed logging and error handling.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace from which the Eventstream definition is to be retrieved.

.PARAMETER EventstreamId
(Optional)The unique identifier of the Eventstream whose definition needs to be retrieved.

.PARAMETER EventstreamFormat
Specifies the format of the Eventstream definition. Currently, only 'ipynb' is supported.
Default: 'ipynb'.

.EXAMPLE
    Retrieves the definition of the Eventstream with ID `67890` from the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricEventstreamDefinition -WorkspaceId "12345" -EventstreamId "67890"
    ```

.EXAMPLE
    Retrieves the definitions of all Eventstreams in the workspace with ID `12345` in the `ipynb` format.

    ```powershell
    Get-FabricEventstreamDefinition -WorkspaceId "12345"
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
        [guid]$EventstreamId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventstreamFormat
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/Eventstreams/$EventstreamId/getDefinition"
        if ($EventstreamFormat) {
            $apiEndpointUrl = "$apiEndpointUrl?format=$EventstreamFormat"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve Eventstream definition
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Return the definition parts
        return $response.definition.parts
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Eventstream. Error: $errorDetails" -Level Error
    }

}
