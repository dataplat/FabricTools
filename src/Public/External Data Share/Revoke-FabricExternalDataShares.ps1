function Revoke-FabricExternalDataShares {

    <#
.SYNOPSIS
    Retrieves External Data Shares details from a specified Microsoft Fabric.

.DESCRIPTION
    This function retrieves External Data Shares details.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the External Data Shares resides.

.PARAMETER ItemId
    The unique identifier of the item associated with the External Data Shares.

.PARAMETER ExternalDataShareId
    The unique identifier of the External Data Share to be retrieved.

    .EXAMPLE
    This example retrieves the External Data Shares details

    ```powershell
    Get-FabricExternalDataShares
    ```

.NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ItemId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ExternalDataShareId
    )

    try {

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "admin/workspaces/$WorkspaceId/items/$ItemId/externalDataShares/$ExternalDataShareId/revoke"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess("$ExternalDataShareId", "revoke")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                HandleResponse = $true
            }
            $externalDataShares = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Successfully revoked external data shares." -Level Info
            return $externalDataShares
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve External Data Shares. Error: $errorDetails" -Level Error
    }

}
