function Update-FabricEnvironment
{
<#
.SYNOPSIS
Updates the properties of a Fabric Environment.

.DESCRIPTION
The `Update-FabricEnvironment` function updates the name and/or description of a specified Fabric Environment by making a PATCH request to the API.

.PARAMETER EnvironmentId
The unique identifier of the Environment to be updated.

.PARAMETER EnvironmentName
The new name for the Environment.

.PARAMETER EnvironmentDescription
(Optional) The new description for the Environment.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the Environment resides.

.EXAMPLE
    Updates the name of the Environment with the ID "Environment123" to "NewEnvironmentName".

    ```powershell
    Update-FabricEnvironment -EnvironmentId "Environment123" -EnvironmentName "NewEnvironmentName"
    ```

.EXAMPLE
    Updates both the name and description of the Environment "Environment123".

    ```powershell
    Update-FabricEnvironment -EnvironmentId "Environment123" -EnvironmentName "NewName" -EnvironmentDescription "Updated description"
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
        [guid]$EnvironmentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$EnvironmentName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EnvironmentDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/environments/{1}" -f $WorkspaceId, $EnvironmentId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $EnvironmentName
        }

        if ($EnvironmentDescription)
        {
            $body.description = $EnvironmentDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($EnvironmentId, "Update Environment"))
        {
            # Make the API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                TypeName       = 'Environment'
                ObjectIdOrName = $EnvironmentName
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Environment '$EnvironmentName' updated successfully!" -Level Info
        }
        return $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Environment. Error: $errorDetails" -Level Error
    }
}
