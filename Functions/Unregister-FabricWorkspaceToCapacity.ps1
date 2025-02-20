<#
.SYNOPSIS
Unregisters a workspace from a capacity.

.DESCRIPTION
The Unregister-FabricWorkspaceToCapacity function unregisters a workspace from a capacity in PowerBI. It can be used to remove a workspace from a capacity, allowing it to be assigned to a different capacity or remain unassigned.

.PARAMETER WorkspaceId
Specifies the ID of the workspace to be unregistered from the capacity. This parameter is mandatory when using the 'WorkspaceId' parameter set.

.PARAMETER Workspace
Specifies the workspace object to be unregistered from the capacity. This parameter is mandatory when using the 'WorkspaceObject' parameter set. The workspace object can be piped into the function.

.EXAMPLE
Unregister-FabricWorkspaceToCapacity -WorkspaceId "12345678"
Unregisters the workspace with ID "12345678" from the capacity.

.EXAMPLE
Get-FabricWorkspace | Unregister-FabricWorkspaceToCapacity
Unregisters the workspace objects piped from Get-FabricWorkspace from the capacity.

.INPUTS
System.Management.Automation.PSCustomObject

.OUTPUTS
System.Object

.NOTES
Author: Your Name
Date: Today's Date
#>

function Unregister-FabricWorkspaceToCapacity {
    [Alias("Unregister-FabWorkspaceToCapacity")]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true)]
        $Workspace
    )
    Process {
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject') {
            $workspaceid = $workspace.id
        }
        if ([string]::IsNullOrEmpty($authToken)) {
            $authToken = Get-FabricAuthToken
        }
    
        $fabricHeaders = @{
            'Authorization' = "Bearer {0}" -f $authToken
        }
        if ($PSCmdlet.ShouldProcess("Unassigns workspace $workspaceid from a capacity")) {
            return Invoke-WebRequest -Headers $fabricHeaders -Method POST -Uri "https://api.fabric.microsoft.com/v1/workspaces/$($workspaceID)/unassignFromCapacity"
            #return (Invoke-FabricAPIRequest -Uri "workspaces/$workspaceid/unassignFromCapacity" -Method POST).value
        }
   }
}