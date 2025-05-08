function Get-FabricWorkspace2 {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Workspaces

.DESCRIPTION
    Retrieves Fabric Workspaces. Without the WorkspaceName or WorkspaceID parameter,
    all Workspaces are returned. If you want to retrieve a specific Workspace, you can
    use the WorkspaceName, an CapacityID, a WorkspaceType, a WorkspaceState or the WorkspaceID
    parameter. The WorkspaceId parameter has precedence over all other parameters because it
    is most specific.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace to retrieve. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER WorkspaceName
    The name of the Workspace to retrieve. This parameter cannot be used together with WorkspaceID.

.PARAMETER WorkspaceCapacityId
    The Id of the Capacity to retrieve. This parameter cannot be used together with WorkspaceID.
    The value for WorkspaceCapacityId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER WorkspaceType
    The type of the Workspace to retrieve. This parameter cannot be used together with WorkspaceID.
    The value for WorkspaceType is a string. An example of a string is 'Personal'. The values that
    can be used are 'Personal', 'Workspace' and 'Adminworkspace'.

.PARAMETER WorkspaceState
    The state of the Workspace to retrieve. This parameter cannot be used together with WorkspaceID.
    The value for WorkspaceState is a string. An example of a string is 'active'. The values that
    can be used are 'active' and 'deleted'.

.EXAMPLE
    Get-FabricWorkspace

    This example will retrieve all Workspaces.

.EXAMPLE
    Get-FabricWorkspace `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the Workspace with the ID '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricWorkspace `
        -WorkspaceName 'MyWorkspace'

    This example will retrieve the Workspace with the name 'MyWorkspace'.

.EXAMPLE
    Get-FabricWorkspace `
        -WorkspaceCapacityId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the Workspaces with the Capacity ID '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricWorkspace `
        -WorkspaceType 'Personal'

    This example will retrieve the Workspaces with the type 'Personal'.

.EXAMPLE
    Get-FabricWorkspace `
        -WorkspaceState 'active'

    This example will retrieve the Workspaces with the state 'active'.

.NOTES

    Revsion History:

    - 2024-12-22 - FGE: Added Verbose Output

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/get-workspace?tabs=HTTP


.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/admin/workspaces/list-workspaces?tabs=HTTP
#>

[CmdletBinding()]
    param (

        [Alias("Id")]
        [string]$WorkspaceId,

        [Alias("Name")]
        [string]$WorkspaceName,

        [Alias("CapacityId")]
        [string]$WorkspaceCapacityId,

        [ValidateSet("Personal", "Workspace", "Adminworkspace")]
        [Alias("Type")]
        [string]$WorkspaceType,

        [ValidateSet("active", "deleted")]
        [Alias("State")]
        [string]$WorkspaceState
    )

begin {

    Confirm-FabricAuthToken | Out-Null
    
    Write-Verbose "WorkspaceID has to be used alone"
    if ($PSBoundParameters.ContainsKey("WorkspaceName") -and
        ($PSBoundParameters.ContainsKey("WorkspaceID") `
        -or $PSBoundParameters.ContainsKey("WorkspaceCapcityId") `
        -or $PSBoundParameters.ContainsKey("WorkspaceType") `
        -or $PSBoundParameters.ContainsKey("WorkspaceState"))) {
            throw "Parameters WorkspaceName, WorkspaceCapacityId, WorkspaceType or WorkspaceState and WorkspaceID cannot be used together!"
    }

    # Create Workspace API URL
    $workspaceApiUrl = "$($FabricSession.BaseApiUrl)/admin/workspaces"

    # Create URL for WebAPI Call if WorkspaceID is provided
    if ($PSBoundParameters.ContainsKey("WorkspaceID")) {
        $workspaceApiUrlId = $workspaceApiUrl + '/' + $WorkspaceID
    }

    Write-Verbose "If there are any parameters, we need to filter the API call, the URL will be constructed here."
    $workspaceApiFilter = $workspaceApiUrl

    if ($PSBoundParameters.ContainsKey("WorkspaceName")) {
        $workspaceApiFilter = $workspaceApiFilter + "?name=$WorkspaceName"
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceCapacityId")) {
        $workspaceApiFilter = $workspaceApiFilter + "?capacityId=$WorkspaceCapacityId"
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceType")) {
        $workspaceApiFilter = $workspaceApiFilter + "?type=$WorkspaceType"
    }

    if ($PSBoundParameters.ContainsKey("WorkspaceState")) {
        $workspaceApiFilter = $workspaceApiFilter + "?state=$WorkspaceState"
    }
    Write-Verbose "Workspace API URL: $workspaceApiFilter"

}

process {

    Write-Verbose "Providing a WorkspaceID is so specific that this will have precedence over any other parameter"
    if ($PSBoundParameters.ContainsKey("WorkspaceID")) {
        Write-Verbose "Calling Workspace API with WorkspaceId $WorkspaceId"
        Write-Verbose "---------------------------------------------------"
        Write-Verbose "Sending the following values to the Workspace API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $workspaceApiUrlId"
        Write-Verbose "ContentType: application/json"
        # Call Workspace API for WorkspaceID
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $workspaceApiUrlId `
                    -ContentType "application/json"

        $response
    }
    else {
        Write-Verbose "Calling Workspace API with Filter"
        Write-Verbose "---------------------------------"
        Write-Verbose "Sending the following values to the Workspace API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $workspaceApiFilter"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $workspaceApiFilter `
                    -ContentType "application/json"

        $response.Workspaces
    }

}

end {}

}