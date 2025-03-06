function Get-FabricKQLDashboard {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLDashboards

.DESCRIPTION
    Retrieves Fabric KQLDashboards. Without the KQLDashboardName or KQLDashboardID parameter, all KQLDashboards are returned.
    If you want to retrieve a specific KQLDashboard, you can use the KQLDashboardName or KQLDashboardID parameter. These
    parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLDashboards should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDashboardName
    The name of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardID.

.PARAMETER KQLDashboardID
    The Id of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardName. The value for KQLDashboardID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricKQLDashboard

.NOTES
    TODO: Add functionality to list all KQLDashboards. To do so fetch all workspaces and
          then all KQLDashboards in each workspace.

    Revision History:
        - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDashboardName
        - 2024-12-08 - FGE: Added Verbose Output
#>


[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name","DisplayName")]
        [string]$KQLDashboardName,

        [Alias("Id")]
        [string]$KQLDashboardId
    )

begin {

    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-FabricAccount"
    }

    Write-Verbode "You can either use Name or WorkspaceID"
    if ($PSBoundParameters.ContainsKey("KQLDashboardName") -and $PSBoundParameters.ContainsKey("KQLDashboardId")) {
        throw "Parameters KQLDashboardName and KQLDashboardId cannot be used together"
    }

    # Create KQLDashboard API
    $KQLDashboardAPI = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards"

    $KQLDashboardAPIKQLDashboardId = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards/$KQLDashboardId"

}

process {

    if ($PSBoundParameters.ContainsKey("KQLDashboardId")) {
        Write-Verbose "Get KQLDashboard with ID $KQLDashboardId"
        Write-Verbose "Calling KQLDashboard API with KQLDashboardId"
        Write-Verbose "--------------------------------------------"
        Write-Verbose "Sending the following values to the Eventstream API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $KQLDashboardAPIKQLDashboardId"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $KQLDashboardAPIKQLDashboardId `
                    -ContentType "application/json"

        $response
    }
    else {
        Write-Verbose "Calling KQLDashboard API"
        Write-Verbose "------------------------"
        Write-Verbose "Sending the following values to the Eventstream API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $KQLDashboardAPI"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $KQLDashboardAPI `
                    -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("KQLDashboardName")) {
            Write-Verbose "Filtering KQLDashboards by name. Name: $KQLDashboardName"
            $response.value | `
                Where-Object { $_.displayName -eq $KQLDashboardName }
        }
        else {
            Write-Verbose "Returning all KQLDashboards"
            $response.value
        }
    }
}

end {}

}