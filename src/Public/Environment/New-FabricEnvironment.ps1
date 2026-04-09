function New-FabricEnvironment
{
<#
.SYNOPSIS
Creates a new environment in a specified workspace.

.DESCRIPTION
The `Add-FabricEnvironment` function creates a new environment within a given workspace by making a POST request to the Fabric API. The environment can optionally include a description.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace where the environment will be created.

.PARAMETER EnvironmentName
(Mandatory) The name of the environment to be created. Only alphanumeric characters, spaces, and underscores are allowed.

.PARAMETER EnvironmentDescription
(Optional) A description of the environment.

.EXAMPLE
    Creates an environment named "DevEnv" in workspace "12345" with the specified description.

    ```powershell
    Add-FabricEnvironment -WorkspaceId "12345" -EnvironmentName "DevEnv" -EnvironmentDescription "Development Environment"
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

    $bodyJson = $body | ConvertTo-Json -Depth 2
    Write-Message -Message "Request Body: $bodyJson" -Level Debug

    if ($PSCmdlet.ShouldProcess($EnvironmentName, "Create Environment"))
    {
        $apiParams = @{
            Uri            = "workspaces/$WorkspaceId/environments"
            Method         = 'Post'
            Body           = $bodyJson
            TypeName       = 'Environment'
            ObjectIdOrName = $EnvironmentName
            HandleResponse = $true
        }

        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Environment '$EnvironmentName' created successfully!" -Level Info
        $response
    }
}
