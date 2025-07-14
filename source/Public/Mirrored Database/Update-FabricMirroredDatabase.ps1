
function Update-FabricMirroredDatabase
{
<#
.SYNOPSIS
Updates the properties of a Fabric MirroredDatabase.

.DESCRIPTION
The `Update-FabricMirroredDatabase` function updates the name and/or description of a specified Fabric MirroredDatabase by making a PATCH request to the API.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace where the MirroredDatabase resides.

.PARAMETER MirroredDatabaseId
The unique identifier of the MirroredDatabase to be updated.

.PARAMETER MirroredDatabaseName
The new name for the MirroredDatabase.

.PARAMETER MirroredDatabaseDescription
(Optional) The new description for the MirroredDatabase.

.EXAMPLE
    Updates the name of the MirroredDatabase with the ID "MirroredDatabase123" to "NewMirroredDatabaseName".

    ```powershell
    Update-FabricMirroredDatabase -MirroredDatabaseId "MirroredDatabase123" -MirroredDatabaseName "NewMirroredDatabaseName"
    ```

.EXAMPLE
    Updates both the name and description of the MirroredDatabase "MirroredDatabase123".

    ```powershell
    Update-FabricMirroredDatabase -MirroredDatabaseId "MirroredDatabase123" -MirroredDatabaseName "NewName" -MirroredDatabaseDescription "Updated description"
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
        [guid]$MirroredDatabaseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabaseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabaseDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $MirroredDatabaseName
        }

        if ($MirroredDatabaseDescription)
        {
            $body.description = $MirroredDatabaseDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($MirroredDatabaseId, "Update MirroredDatabase"))
        {
            # Step 4: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Patch `
                -Body $bodyJson
        }

        # Step 5: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 6: Handle results
        Write-Message -Message "MirroredDatabase '$MirroredDatabaseName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update MirroredDatabase. Error: $errorDetails" -Level Error
    }
}
