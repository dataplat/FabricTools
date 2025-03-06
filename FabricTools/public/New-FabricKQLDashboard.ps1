function New-FabricKQLDashboard {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric KQLDashboard

.DESCRIPTION
    Creates a new Fabric KQLDashboard

.PARAMETER WorkspaceID
    Id of the Fabric Workspace for which the KQLDashboard should be created. The value for WorkspaceID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDashboardName
    The name of the KQLDashboard to create.

.PARAMETER KQLDashboardDescription
    The description of the KQLDashboard to create.

.EXAMPLE
    New-FabricDashboard `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -KQLDashboardName 'MyKQLDashboard' `
        -KQLDashboardDescription 'This is my KQLDashboard'

    This example will create a new KQLDashboard with the name 'MyKQLDashboard' and the description 'This is my KQLDashboard'.

.NOTES

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDashboardName
    - 2024-12-08 - FGE: Added Verbose Output
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID,

        [Parameter(Mandatory=$true)]
        [Alias("Name", "DisplayName")]
        [string]$KQLDashboardName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$KQLDashboardDescription

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-FabricAccount"
    }

    Write-Verbose "Create body of request"
    $body = @{
        'displayName' = $KQLDashboardName
        'description' = $KQLDashboardDescription
    } | ConvertTo-Json `
            -Depth 1

    # Create KQLDashboard API URL
    $KQLDashboardApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards"
    }

process {

    if($PSCmdlet.ShouldProcess($KQLDashboardName)) {
        Write-Verbose "Calling KQLDashboard API"
        Write-Verbose "------------------------"
        Write-Verbose "Sending the following values to the KQLDashboard API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: POST"
        Write-Verbose "URI: $KQLDashboardApiUrl"
        Write-Verbose "Body of request: $body"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method POST `
                            -Uri $KQLDashboardApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}