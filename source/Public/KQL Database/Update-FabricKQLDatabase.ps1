<#
.SYNOPSIS
Updates the properties of a Fabric KQLDatabase.

.DESCRIPTION
The `Update-FabricKQLDatabase` function updates the name and/or description of a specified Fabric KQLDatabase by making a PATCH request to the API.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the KQLDatabase resides.

.PARAMETER KQLDatabaseId
The unique identifier of the KQLDatabase to be updated.

.PARAMETER KQLDatabaseName
The new name for the KQLDatabase.

.PARAMETER KQLDatabaseDescription
(Optional) The new description for the KQLDatabase.

.EXAMPLE
Update-FabricKQLDatabase -KQLDatabaseId "KQLDatabase123" -KQLDatabaseName "NewKQLDatabaseName"

Updates the name of the KQLDatabase with the ID "KQLDatabase123" to "NewKQLDatabaseName".

.EXAMPLE
Update-FabricKQLDatabase -KQLDatabaseId "KQLDatabase123" -KQLDatabaseName "NewName" -KQLDatabaseDescription "Updated description"

Updates both the name and description of the KQLDatabase "KQLDatabase123".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>

function Update-FabricKQLDatabase
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$KQLDatabaseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabaseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDatabaseDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDatabases/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $KQLDatabaseName
        }

        if ($KQLDatabaseDescription)
        {
            $body.description = $KQLDatabaseDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($KQLDatabaseId, "Update KQLDatabase"))
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
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        # Step 6: Handle results
        Write-Message -Message "KQLDatabase '$KQLDatabaseName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update KQLDatabase. Error: $errorDetails" -Level Error
    }
}
