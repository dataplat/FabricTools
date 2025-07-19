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
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
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

        # Step 2: Ensure token validity
        Confirm-TokenState

        # Step 4: Loop to retrieve all capacities with continuation token
        Write-Message -Message "Constructing API endpoint URI..." -Level Debug
        $apiEndpointURI = "admin/workspaces/{0}/items/{1}/externalDataShares/{2}/revoke" -f $WorkspaceId, $ItemId, $ExternalDataShareId

        if ($PSCmdlet.ShouldProcess("$ExternalDataShareId", "revoke")) {

        $externalDataShares = Invoke-FabricRestMethod `
            -Uri $apiEndpointURI `
            -Method Post
        }

        # Step 4: Return retrieved data
        Write-Message -Message "Successfully revoked external data shares." -Level Info
        return $externalDataShares
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve External Data Shares. Error: $errorDetails" -Level Error
    }

}
