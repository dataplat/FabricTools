function Get-FabricKQLDashboardDefinition {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLDashboard Definitions for a given KQLDashboard.

.DESCRIPTION
    Retrieves the Definition of the Fabric KQLDashboard that is specified by the KQLDashboardName or KQLDashboardID.
    The KQLDashboard Definition contains the parts of the KQLDashboard, which are the visualizations and their configuration.
    This is provided as a JSON object.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace in which the KQLDashboard exists. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDashboardName
    The name of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardID.

.PARAMETER KQLDashboardID
    The Id of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardName. The value for KQLDashboardID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricKQLDashboardDefinition `
        -WorkspaceId "12345678-1234-1234-1234-123456789012" `
        -KQLDashboardName "MyKQLDashboard"

    This example retrieves the KQLDashboard Definition for the KQLDashboard named "MyKQLDashboard" in the
    Workspace with the ID "12345678-1234-1234-1234-123456789012".

.EXAMPLE
    $db = Get-FabricKQLDashboardDefinition `
            -WorkspaceId "12345678-1234-1234-1234-123456789012" `
            -KQLDashboardName "MyKQLDashboard"

     $db[0].payload | `
        Set-Content `
            -Path "C:\temp\mydashboard.json"

    This example retrieves the KQLDashboard Definition for the KQLDashboard named "MyKQLDashboard" in the
    Workspace with the ID "12345678-1234-1234-1234-123456789012".
    The definition is saved to a file named "mydashboard.json".


.NOTES

    Revision History:
        - 2024-11-16 - FGE: First version
        - 2024-12-08 - FGE: Added Verbose Output
#>


[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name","DisplayName")]
        [string]$KQLDashboardName,

        [Alias("Id")]
        [string]$KQLDashboardId,

        [string]$Format
    )

begin {

    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "You can either use Name or WorkspaceID"
    if ($PSBoundParameters.ContainsKey("KQLDashboardName") -and $PSBoundParameters.ContainsKey("KQLDashboardId")) {
        throw "Parameters KQLDashboardName and KQLDashboardId cannot be used together"
    }

    # Create KQLDashboard API

    $KQLDashboardAPIKQLDashboardId = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDashboards/$KQLDashboardId/getDefinition"

}

process {

    if ($PSBoundParameters.ContainsKey("KQLDashboardId")) {
        Write-Verbose "Get KQLDashboardDefinition with ID $KQLDashboardId"
        Write-Verbose "Calling KQLDashboard API with KQLDashboardId"
        Write-Verbose "--------------------------------------------"
        Write-Verbose "Sending the following values to the KQLDashboard API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: POST"
        Write-Verbose "URI: $KQLDashboardAPIKQLDashboardId"
        Write-Verbose "Body of request: $$null"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method POST `
                    -Uri $KQLDashboardAPIKQLDashboardId `
                    -Body $null `
                    -ContentType "application/json"

        $parts = $response.definition.parts
        Write-Verbose "Decoding the payload of the parts: $parts"

        foreach ($part in $parts) {
            $bytes = [System.Convert]::FromBase64String($part.payload)
            Write-Verbose "Returned bytes for part $part.name: $bytes"
            $decodedText = [System.Text.Encoding]::UTF8.GetString($bytes)
            Write-Verbose "decodedText for part $part.name: $decodedText"
            $part.payload = $decodedText
        }

        $parts
    }
}

end {}

}