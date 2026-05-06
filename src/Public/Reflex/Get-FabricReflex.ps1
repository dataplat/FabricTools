function Get-FabricReflex {
<#
.SYNOPSIS
    Retrieves Reflex details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves Reflex details from a specified workspace using either the provided ReflexId or ReflexName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Reflex exists. This parameter is mandatory.

.PARAMETER ReflexId
    The unique identifier of the Reflex to retrieve. This parameter is optional.

.PARAMETER ReflexName
    The name of the Reflex to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the Reflex details for the Reflex with ID "Reflex-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReflex -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890"
    ```

.EXAMPLE
    This example retrieves the Reflex details for the Reflex named "My Reflex" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReflex -WorkspaceId "workspace-12345" -ReflexName "My Reflex"
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
        [string]$ReflexName
    )
    try {
        # Handle ambiguous input
        if ($ReflexId -and $ReflexName) {
            Write-Message -Message "Both 'ReflexId' and 'ReflexName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        $apiEndpointUrl = "{0}/workspaces/{1}/reflexes" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            TypeName       = 'Reflex'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $Reflexes = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $Reflex = if ($ReflexId) {
            $Reflexes | Where-Object { $_.Id -eq $ReflexId }
        } elseif ($ReflexName) {
            $Reflexes | Where-Object { $_.DisplayName -eq $ReflexName }
        } else {
            Write-Message -Message "No filter provided. Returning all Reflexes." -Level Debug
            $Reflexes
        }

        # Handle results
        if ($Reflex) {
            Write-Message -Message "Reflex found in the Workspace '$WorkspaceId'." -Level Debug
            return $Reflex
        } else {
            Write-Message -Message "No Reflex found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Reflex. Error: $errorDetails" -Level Error
    }

}
