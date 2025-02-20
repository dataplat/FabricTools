function Get-FabricWorkspaceRoleAssignment {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Workspace Role Assignments

.DESCRIPTION
    Retrieves Fabric Workspace Role Assignments. Without the WorkspaceName or WorkspaceID parameter,

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Role Assignments should be retrieved.
    The value for WorkspaceId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricWorkspaceRoleAssignment `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will retrieve all Role Assignments for the Workspace with the ID '12345678-1234-1234-1234-123456789012'.

.LINK
   https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/get-workspace-role-assignment?tabs=HTTP

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/list-workspace-role-assignments?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Alias("Id")]
        [string]$WorkspaceId
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create Workspace API URL
    $workspaceApiUrl = "$($FabricSession.BaseFabricUrl)/v1/admin/workspaces/$WorkspaceId/roleassignments"

}

process {
    # Call Workspace API for WorkspaceID
    $response = Invoke-RestMethod `
                -Headers $FabricSession.headerParams `
                -Method GET `
                -Uri $workspaceApiUrl `
                -ContentType "application/json"

    $response.Workspaces

}

end {}

}