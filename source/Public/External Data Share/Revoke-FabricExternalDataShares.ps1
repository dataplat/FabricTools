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
     Get-FabricExternalDataShares
    This example retrieves the External Data Shares details

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ItemId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ExternalDataShareId
    )

    try {

        # Step 2: Ensure token validity
        Write-Message -Message "Validating token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Token validation completed." -Level Debug

        # Step 4: Loop to retrieve all capacities with continuation token
        Write-Message -Message "Constructing API endpoint URI..." -Level Debug
        $apiEndpointURI = "{0}/admin/workspaces/{1}/items/{2}/externalDataShares/{3}/revoke" -f $FabricConfig.BaseUrl, $WorkspaceId, $ItemId, $ExternalDataShareId

        $externalDataShares = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointURI `
            -Headers $FabricConfig.FabricHeaders `
            -Method Post

        # Step 4: Return retrieved data
        Write-Message -Message "Successfully revoked external data shares." -Level Info
        return $externalDataShares
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve External Data Shares. Error: $errorDetails" -Level Error
    }

}