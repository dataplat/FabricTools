function Get-FabricReflexDefinition {
<#
.SYNOPSIS
    Retrieves the definition of an Reflex from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves the definition of an Reflex from a specified workspace using the provided ReflexId.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Reflex exists. This parameter is mandatory.

.PARAMETER ReflexId
    The unique identifier of the Reflex to retrieve the definition for. This parameter is optional.

.PARAMETER ReflexFormat
    The format in which to retrieve the Reflex definition. This parameter is optional.

.EXAMPLE
    This example retrieves the definition of the Reflex with ID "Reflex-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReflexDefinition -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890"
    ```

.EXAMPLE
    This example retrieves the definition of the Reflex with ID "Reflex-67890" in the workspace with ID "workspace-12345" in JSON format.

    ```powershell
    Get-FabricReflexDefinition -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890" -ReflexFormat "json"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$ReflexId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReflexFormat
    )
    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/reflexes/{2}/getDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $ReflexId

        if ($ReflexFormat) {
            $apiEndpointUrl = "{0}?format={1}" -f $apiEndpointUrl, $ReflexFormat
        }
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'Reflex Definition'
            ObjectIdOrName = $ReflexId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Reflex. Error: $errorDetails" -Level Error
    }

}
