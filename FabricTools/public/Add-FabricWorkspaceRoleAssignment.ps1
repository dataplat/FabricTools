function Add-FabricWorkspaceRoleAssignment {
#Requires -Version 7.1

<#
.SYNOPSIS
    Adds a role assignment to a user in a workspace.

.DESCRIPTION
    Adds a role assignment to a user in a workspace. The User is identified by the principalId and the role is
    identified by the Role parameter. The Workspace is identified by the WorkspaceId.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the role assignment should be added. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory.

.PARAMETER PrincipalId
    Id of the principal for which the role assignment should be added. The value for PrincipalId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory. At the
    moment only principal type 'User' is supported.

.PARAMETER Role
    The role to assign to the principal. The value for Role is a string. An example of a string is 'Admin'.
    The values that can be used are 'Admin', 'Contributor', 'Member' and 'Viewer'.


.EXAMPLE
    Add-RtiWorkspaceRoleAssignment `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -PrincipalId '12345678-1234-1234-1234-123456789012' `
        -Role 'Admin'

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/core/workspaces/add-workspace-role-assignment?tabs=HTTP


.NOTES
    TODO: Add functionallity to add role assignments to groups.
    TODO: Add functionallity to add a user by SPN.
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Alias("Id")]
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [string]$principalId,

        [ValidateSet("Admin", "Contributor", "Member" , "Viewer")]
        [Parameter(Mandatory=$true)]
        [string]$Role
    )

begin {

    # Check if session is established - if not throw error
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-FabricAccount"
    }

    # Create body of request
    $body = @{
        'principal' =  @{
            'id' = $principalId
            'type' =  "User"
        }
        'role' =  $Role
    } | ConvertTo-Json `
            -Depth 1

    # Create Workspace API URL
    $workspaceApiUrl = "$($FabricSession.BaseFabricUrl)/v1/admin/workspaces/$WorkspaceId/roleassignments"
}

process {

    if($PSCmdlet.ShouldProcess($WorkspaceName)) {
        # Call Workspace API
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method POST `
                            -Uri $WorkspaceApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}