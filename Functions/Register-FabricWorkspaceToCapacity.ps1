<#
.SYNOPSIS
Sets a PowerBI workspace to a capacity.

.DESCRIPTION
The Register-FabricWorkspaceToCapacity function Sets a PowerBI workspace to a capacity. It supports multiple aliases for flexibility.

.PARAMETER WorkspaceId
The ID of the workspace to be Seted. This is a mandatory parameter.

.PARAMETER Workspace
The workspace object to be Seted. This is a mandatory parameter and can be piped into the function.

.PARAMETER CapacityId
The ID of the capacity to which the workspace will be Seted. This is a mandatory parameter.

.EXAMPLE
Register-FabricWorkspaceToCapacity -WorkspaceId "Workspace-GUID" -CapacityId "Capacity-GUID"

This example Sets the workspace with ID "Workspace-GUID" to the capacity with ID "Capacity-GUID".

.EXAMPLE
$workspace | Register-FabricWorkspaceToCapacity -CapacityId "Capacity-GUID"

This example Sets the workspace object stored in the $workspace variable to the capacity with ID "Capacity-GUID". The workspace object is piped into the function.

.NOTES
The function makes a POST request to the PowerBI API to Set the workspace to the capacity. The PowerBI access token is retrieved using the Get-PowerBIAccessToken function.
#>


# This function Sets a PowerBI workspace to a capacity.
# It supports multiple aliases for flexibility.
function Register-FabricWorkspaceToCapacity {
    [Alias("Register-FabWorkspaceToCapacity")]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # WorkspaceId is a mandatory parameter. It represents the ID of the workspace to be Seted.
        [Parameter(ParameterSetName = 'WorkspaceId')]
        [string]$WorkspaceId,

        # Workspace is a mandatory parameter. It represents the workspace object to be Seted.
        # This parameter can be piped into the function.
        [Parameter(ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true)]
        $Workspace,

        # CapacityId is a mandatory parameter. It represents the ID of the capacity to which the workspace will be Seted.
        [Parameter(Mandatory = $true)]
        [string]$CapacityId
    )
    Process {
        # If the parameter set name is 'WorkspaceObject', the workspace ID is extracted from the workspace object.
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject') {
            $workspaceid = $workspace.id
        }

        # The body of the request is created. It contains the capacity ID.
       $body = @{
            capacityId = $CapacityId
        } 
 
        if ([string]::IsNullOrEmpty($authToken)) {
            $authToken = Get-FabricAuthToken
        }
    
        $fabricHeaders = @{
            'Authorization' = "Bearer {0}" -f $authToken
        }
        # The workspace is Seted to the capacity by making a POST request to the PowerBI API.
        # The function returns the value property of the response.
        if ($PSCmdlet.ShouldProcess("Set workspace $workspaceid to capacity $CapacityId")) {
            #return (Invoke-FabricAPIRequest -Uri "workspaces/$($workspaceID)/assignToCapacity" -Method POST -Body $body).value
            return Invoke-WebRequest -Headers $fabricHeaders -Method POST -Uri "https://api.fabric.microsoft.com/v1/workspaces/$($workspaceID)/assignToCapacity" -Body $body
        }
   }
}