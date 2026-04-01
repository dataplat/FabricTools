function Update-FabricKQLDashboard
{
    <#
.SYNOPSIS
Updates the properties of a Fabric KQLDashboard.

.DESCRIPTION
The `Update-FabricKQLDashboard` function updates the name and/or description of a specified Fabric KQLDashboard by making a PATCH request to the API.

.PARAMETER KQLDashboardId
The unique identifier of the KQLDashboard to be updated.

.PARAMETER KQLDashboardName
The new name for the KQLDashboard.

.PARAMETER KQLDashboardDescription
(Optional) The new description for the KQLDashboard.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the KQLDashboard exists.

.EXAMPLE
    Updates the name of the KQLDashboard with the ID "KQLDashboard123" to "NewKQLDashboardName".

    ```powershell
    Update-FabricKQLDashboard -KQLDashboardId "KQLDashboard123" -KQLDashboardName "NewKQLDashboardName"
    ```

.EXAMPLE
    Updates both the name and description of the KQLDashboard "KQLDashboard123".

    ```powershell
    Update-FabricKQLDashboard -KQLDashboardId "KQLDashboard123" -KQLDashboardName "NewName" -KQLDashboardDescription "Updated description"
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
        [guid]$KQLDashboardId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDashboardName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDashboardDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/kqlDashboards/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $KQLDashboardId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $KQLDashboardName
        }

        if ($KQLDashboardDescription)
        {
            $body.description = $KQLDashboardDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($KQLDashboardId, "Update KQLDashboard"))
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
        Write-Message -Message "KQLDashboard '$KQLDashboardName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update KQLDashboard. Error: $errorDetails" -Level Error
    }
}
