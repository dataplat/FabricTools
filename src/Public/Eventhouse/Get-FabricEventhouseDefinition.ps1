function Get-FabricEventhouseDefinition {
<#
.SYNOPSIS
    Retrieves the definition of an Eventhouse from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves the definition of an Eventhouse from a specified workspace using the provided EventhouseId.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Eventhouse exists. This parameter is mandatory.

.PARAMETER EventhouseId
    The unique identifier of the Eventhouse to retrieve the definition for. This parameter is optional.

.PARAMETER EventhouseFormat
    The format in which to retrieve the Eventhouse definition. This parameter is optional.

.EXAMPLE
    This example retrieves the definition of the Eventhouse with ID "eventhouse-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricEventhouseDefinition -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890"
    ```

.EXAMPLE
    This example retrieves the definition of the Eventhouse with ID "eventhouse-67890" in the workspace with ID "workspace-12345" in JSON format.

    ```powershell
    Get-FabricEventhouseDefinition -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890" -EventhouseFormat "json"
    ```

.NOTES
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
        [guid]$EventhouseId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhouseFormat
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "workspaces/$WorkspaceId/eventhouses/$EventhouseId/getDefinition"
        if ($EventhouseFormat) {
            $uri = "$uri?format=$EventhouseFormat"
        }

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            TypeName       = 'Eventhouse'
            ObjectIdOrName = $EventhouseId
            HandleResponse = $true
        }

        Invoke-FabricRestMethod @apiParams

    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Eventhouse. Error: $errorDetails" -Level Error
    }
}
