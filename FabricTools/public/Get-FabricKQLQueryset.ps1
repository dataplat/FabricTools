function Get-FabricKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLQuerysets

.DESCRIPTION
    Retrieves Fabric KQLQuerysets. Without the KQLQuerysetName or KQLQuerysetId parameter,
    all KQLQuerysets are returned in the given Workspace. If you want to retrieve a specific
    KQLQueryset, you can use the KQLQuerysetName or KQLQuerysetId parameter. These parameters
    cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLQuerysets should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory.

.PARAMETER KQLQuerysetName
    The name of the KQLQueryset to retrieve. This parameter cannot be used together with KQLQuerysetId.

.PARAMETER KQLQuerysetId
    The Id of the KQLQueryset to retrieve. This parameter cannot be used together with KQLQuerysetName.
    The value for KQLQuerysetId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetName 'MyKQLQueryset'

    This example will retrieve the KQLQueryset with the name 'MyKQLQueryset'.

.EXAMPLE
    Get-FabricKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will retrieve all KQLQuerysets in the workspace that is specified
    by the WorkspaceId.

.EXAMPLE
    Get-FabricKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the KQLQueryset with the ID '12345678-1234-1234-1234-123456789012'.

.NOTES
    TODO: Add functionality to list all KQLQuerysets. To do so fetch all workspaces and
        then all KQLQuerysets in each workspace.

    Revision History:
        - 2024-11-09 - FGE: Added DisplaName as Alias for KQLQuerysetName
        - 2024-12-22 - FGE: Added Verbose Output
#>


[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name","DisplayName")]
        [string]$KQLQuerysetName,

        [Alias("Id")]
        [string]$KQLQuerysetId
    )

begin {

    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "You can either use Name or WorkspaceID"
    if ($PSBoundParameters.ContainsKey("KQLQuerysetName") -and $PSBoundParameters.ContainsKey("KQLQuerysetId")) {
        throw "Parameters KQLQuerysetName and KQLQuerysetId cannot be used together"
    }

    # Create KQLQueryset API
    $KQLQuerysetAPI = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets"

    $KQLQuerysetAPIKQLQuerysetId = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets/$KQLQuerysetId"

}

process {

    if ($PSBoundParameters.ContainsKey("KQLQuerysetId")) {
        Write-Verbose "Calling KQLQueryset API with KQLQuerysetId $KQLQuerysetId"
        Write-Verbose "------------------------------------------------------------------------------------"
        Write-Verbose "Sending the following values to the KQLQueryset API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $KQLQuerysetAPIKQLQuerysetId"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $KQLQuerysetAPIKQLQuerysetId `
                    -ContentType "application/json"

        $response
    }
    else {
        Write-Verbose "Calling KQLQueryset API"
        Write-Verbose "------------------------------------------------------------------------------------"
        Write-Verbose "Sending the following values to the KQLQueryset API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $KQLQuerysetAPI"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $KQLQuerysetAPI `
                    -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("KQLQuerysetName")) {
            Write-Verbose "Filtering KQLQuerysets by name. Name: $KQLQuerysetName"
            $response.value | `
                Where-Object { $_.displayName -eq $KQLQuerysetName }
        }
        else {
            Write-Verbose "Returning all KQLQuerysets"
            $response.value
        }
    }
}

end {}

}