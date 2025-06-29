<#
.SYNOPSIS
Updates the properties of a Fabric Lakehouse.

.DESCRIPTION
The `Update-FabricLakehouse` function updates the name and/or description of a specified Fabric Lakehouse by making a PATCH request to the API.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the Lakehouse exists.

.PARAMETER LakehouseId
The unique identifier of the Lakehouse to be updated.

.PARAMETER LakehouseName
The new name for the Lakehouse.

.PARAMETER LakehouseDescription
(Optional) The new description for the Lakehouse.

.EXAMPLE
Update-FabricLakehouse -LakehouseId "Lakehouse123" -LakehouseName "NewLakehouseName"

Updates the name of the Lakehouse with the ID "Lakehouse123" to "NewLakehouseName".

.EXAMPLE
Update-FabricLakehouse -LakehouseId "Lakehouse123" -LakehouseName "NewName" -LakehouseDescription "Updated description"

Updates both the name and description of the Lakehouse "Lakehouse123".

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>

function Update-FabricLakehouse
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$LakehouseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LakehouseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$LakehouseDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/lakehouses/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $LakehouseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $LakehouseName
        }

        if ($LakehouseDescription)
        {
            $body.description = $LakehouseDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($LakehouseId, "Update Lakehouse"))
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
        Write-Message -Message "Lakehouse '$LakehouseName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Lakehouse. Error: $errorDetails" -Level Error
    }
}
