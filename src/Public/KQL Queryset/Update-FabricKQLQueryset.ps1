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
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

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

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlQuerysets/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLQuerysetId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

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
        if ($PSCmdlet.ShouldProcess($KQLQuerysetId, "Update KQLQueryset"))
        {
            # Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Patch `
                -Body $bodyJson
        }

        # Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Handle results
        Write-Message -Message "KQLQueryset '$KQLQuerysetName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update KQLQueryset. Error: $errorDetails" -Level Error
    }
}
