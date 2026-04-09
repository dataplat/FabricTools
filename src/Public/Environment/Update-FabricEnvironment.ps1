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

    # Ensure token validity
    Confirm-TokenState

    $body = @{
        displayName = $EnvironmentName
    }

    if ($EnvironmentDescription)
    {
        $body.description = $EnvironmentDescription
    }

    $bodyJson = $body | ConvertTo-Json
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($EnvironmentId, "Update Environment"))
    {
        $apiParams = @{
            Uri            = "workspaces/$WorkspaceId/environments/$EnvironmentId"
            Method         = 'Patch'
            Body           = $bodyJson
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentName
            HandleResponse = $true
        }

        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Environment '$EnvironmentName' updated successfully!" -Level Info
        $response
    }
}
