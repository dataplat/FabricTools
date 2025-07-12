<#
.SYNOPSIS
    Updates an existing Reflex in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update an existing Reflex
    in the specified workspace. It supports optional parameters for Reflex description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Reflex exists. This parameter is optional.

.PARAMETER ReflexId
    The unique identifier of the Reflex to be updated. This parameter is mandatory.

.PARAMETER ReflexName
    The new name of the Reflex. This parameter is mandatory.

.PARAMETER ReflexDescription
    An optional new description for the Reflex.

.EXAMPLE
    This example updates the Reflex with ID "Reflex-67890" in the workspace with ID "workspace-12345" with a new name and description.

    ```powershell
    Update-FabricReflex -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890" -ReflexName "Updated Reflex" -ReflexDescription "Updated description"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch

#>
function Update-FabricReflex
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ReflexId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ReflexName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReflexDescription
    )
    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/reflexes/{2}" -f $FabricConfig.BaseUrl, $WorkspaceId, $ReflexId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $ReflexName
        }

        if ($ReflexDescription)
        {
            $body.description = $ReflexDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess("Reflex", "Update"))
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
        Write-Message -Message "Reflex '$ReflexName' updated successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 7: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Reflex. Error: $errorDetails" -Level Error
    }
}
