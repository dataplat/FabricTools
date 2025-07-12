<#
.SYNOPSIS
Updates the properties of a Fabric Eventstream.

.DESCRIPTION
The `Update-FabricEventstream` function updates the name and/or description of a specified Fabric Eventstream by making a PATCH request to the API.

.PARAMETER EventstreamId
The unique identifier of the Eventstream to be updated.

.PARAMETER EventstreamName
The new name for the Eventstream.

.PARAMETER EventstreamDescription
(Optional) The new description for the Eventstream.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the Eventstream resides.

.EXAMPLE
    Updates the name of the Eventstream with the ID "Eventstream123" to "NewEventstreamName".

    ```powershell
    Update-FabricEventstream -EventstreamId "Eventstream123" -EventstreamName "NewEventstreamName"
    ```

.EXAMPLE
    Updates both the name and description of the Eventstream "Eventstream123".

    ```powershell
    Update-FabricEventstream -EventstreamId "Eventstream123" -EventstreamName "NewName" -EventstreamDescription "Updated description"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>

function Update-FabricEventstream
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventstreamId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$EventstreamName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventstreamDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/eventstreams/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $EventstreamId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $EventstreamName
        }

        if ($EventstreamDescription)
        {
            $body.description = $EventstreamDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($EventstreamId, "Update Eventstream"))
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
        Write-Message -Message "Eventstream '$EventstreamName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Eventstream. Error: $errorDetails" -Level Error
    }
}
