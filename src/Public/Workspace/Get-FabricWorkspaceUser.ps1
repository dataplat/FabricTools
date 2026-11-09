function Get-FabricWorkspaceUser
{
    <#
.SYNOPSIS
Retrieves the user(s) of a workspace.

.DESCRIPTION
The Get-FabricWorkspaceUser function retrieves the details of the users of a workspace.
Each returned user includes the workspace name and ID for context.

.PARAMETER WorkspaceId
The ID of the workspace. This is a mandatory parameter if Workspace is not provided.

.PARAMETER Workspace
The workspace object. This normally comes from the Get-FabricWorkspace cmdlet. This is a mandatory parameter if WorkspaceId is not provided.

.EXAMPLE
    This example retrieves the users of a workspace of the workspace with the ID '12345678-1234-1234-1234-123456789012'.

    ```powershell
    Get-FabricWorkspaceUser -WorkspaceId '12345678-1234-1234-1234-123456789012
    ```

.EXAMPLE
    This example retrieves the users of the prod-workspace workspace by piping the object.

    ```powershell
    $workspace = Get-FabricWorkspace -WorkspaceName 'prod-workspace'

    $workspace | Get-FabricWorkspaceUser
    ```

.EXAMPLE
    This example retrieves the users of the prod-workspace workspace by piping the object.

    ```powershell
    Get-FabricWorkspaceUser -Workspace (Get-FabricWorkspace -WorkspaceName 'prod-workspace')
    ```

.EXAMPLE
    This example retrieves the users of all of the workspaces, including each user's workspace name and ID.

    ```powershell
    Get-FabricWorkspace| Get-FabricWorkspaceUser
    ```

.NOTES
It supports multiple aliases for backward compatibility.
The function defines parameters for the workspace ID and workspace object. If the parameter set name is 'WorkspaceId', it retrieves the workspace object. It then makes a GET request to the PowerBI API to retrieve the users of the workspace and returns the 'value' property of the response, which contains the users.

Author: Ioana Bouariu

    #>

    # This function retrieves the users of a workspace.
    # Define parameters for the workspace ID and workspace object.
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [Alias("Id")]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true )]
        [object[]]
        $Workspace
    )

    begin
    {
        Confirm-TokenState
        # If the parameter set name is 'WorkspaceId', return the workspace object so that it can be used in the process block.
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceId')
        {
            $Workspace = Get-FabricWorkspace -WorkspaceId $WorkspaceId
        }
    }

    process
    {

        foreach ($space in $Workspace)
        {

            $apiEndpointUrl = "groups/{0}/users" -f $space.id

            # Make a GET request to the PowerBI API to retrieve the users of the workspace.
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Get'
                ApiType        = 'PowerBI'
                TypeName       = 'Workspace User'
                ObjectIdOrName = $space.id
                HandleResponse = $true
                ExtractValue   = 'True'
            }
            $response = @(Invoke-FabricRestMethod @apiParams)
            if ($response)
            {

                foreach ($user in $response)
                {
                    Add-Member -InputObject $user -MemberType NoteProperty -Name WorkspaceName -Value $space.displayName -Force
                    Add-Member -InputObject $user -MemberType NoteProperty -Name WorkspaceId -Value $space.id -Force
                    $user
                }
            }
        }
    }
}
