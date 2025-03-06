function Remove-FabricKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric KQLQueryset.

.DESCRIPTION
    Removes an existing Fabric KQLQueryset. The Eventhouse is identified by the WorkspaceId and KQLQuerysetId.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLQueryset should be removed. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory.

.PARAMETER KQLQuerysetId
    The Id of the KQLQueryset to remove. The value for KQLQuerysetId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.
    This parameter is mandatory.

.EXAMPLE
    Remove-FabricKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetId '12345678-1234-1234-1234-123456789012'

.NOTES
    TODO: Add functionality to remove KQLQueryset by name.

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-12-22 - FGE: Added Verbose Output

#>


[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$KQLQuerysetId

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-FabricAccount"
    }

    # Create KQLQueryset API URL
    $querysetApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLQuerysets/$KQLQuerysetId"
    }

process {

    # Call KQL Queryset API
    if($PSCmdlet.ShouldProcess($KQLQuerysetId)) {
        Write-Verbose "Calling KQLQueryset API"
        Write-Verbose "-----------------------"
        Write-Verbose "Sending the following values to the KQLQueryset API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: DELETE"
        Write-Verbose "URI: $querysetApiUrl"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method DELETE `
                            -Uri $querysetApiUrl `
                            -ContentType "application/json"

        $response
    }
}

end {}

}