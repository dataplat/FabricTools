function Update-FabricKQLQueryset
{
<#
.SYNOPSIS
Updates the properties of a Fabric KQLQueryset.

.DESCRIPTION
The `Update-FabricKQLQueryset` function updates the name and/or description of a specified Fabric KQLQueryset by making a PATCH request to the API.

.PARAMETER KQLQuerysetId
The unique identifier of the KQLQueryset to be updated.

.PARAMETER KQLQuerysetName
The new name for the KQLQueryset.

.PARAMETER KQLQuerysetDescription
(Optional) The new description for the KQLQueryset.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the KQLQueryset exists.

.EXAMPLE
    Updates the name of the KQLQueryset with the ID "KQLQueryset123" to "NewKQLQuerysetName".

    ```powershell
    Update-FabricKQLQueryset -KQLQuerysetId "KQLQueryset123" -KQLQuerysetName "NewKQLQuerysetName"
    ```

.EXAMPLE
    Updates both the name and description of the KQLQueryset "KQLQueryset123".

    ```powershell
    Update-FabricKQLQueryset -KQLQuerysetId "KQLQueryset123" -KQLQuerysetName "NewName" -KQLQuerysetDescription "Updated description"
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$KQLQuerysetId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLQuerysetName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLQuerysetDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/kqlQuerysets/$KQLQuerysetId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $KQLQuerysetName
        }

        if ($KQLQuerysetDescription)
        {
            $body.description = $KQLQuerysetDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($KQLQuerysetId, "Update KQLQueryset")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "KQLQueryset '$KQLQuerysetName' updated successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update KQLQueryset. Error: $errorDetails" -Level Error
    }
}
