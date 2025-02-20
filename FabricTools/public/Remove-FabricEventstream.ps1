function Remove-FabricEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric Eventstream

.DESCRIPTION
    Removes an existing Fabric Eventstream

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventstream should be deleted. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamId
    The Id of the Eventstream to delete. The value for Eventstream is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Remove-FabricEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamId '12345678-1234-1234-1234-123456789012'

    This example will delete the Eventstream with the Id '12345678-1234-1234-1234-123456789012' from
    the Workspace.

.EXAMPLE
    Remove-FabricEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamName 'MyEventstream'

    This example will delete the Eventstream with the name 'MyEventstream' from the Workspace.

.NOTES

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for EventStreamName
    - 2024-12-08 - FGE: Added Verbose Output
#>



[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Id")]
        [string]$EventstreamId,

        [Alias("Name","DisplayName")]
        [string]$EventstreamName

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "You can either use Name or WorkspaceID not both. If both are used throw error"
    if ($PSBoundParameters.ContainsKey("EventstreamId") -and $PSBoundParameters.ContainsKey("EventstreamName")) {
        throw "Parameters EventstreamId and EventstreamName cannot be used together"
    }

    if ($PSBoundParameters.ContainsKey("EventstreamName")) {
        Write-Verbose "The name $EventstreamName was provided. Fetching EventstreamId."

        $eh = Get-FabricEventstream `
                    -WorkspaceId $WorkspaceId `
                    -EventstreamName $EventstreamName

        $EventstreamId = $eh.id
        Write-Verbose "EventstreamId: $EventstreamId"
    }

    $eventstreamApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventstreams/$EventstreamId"

}

process {

    # Call Eventstream API
    if($PSCmdlet.ShouldProcess($EventstreamName)) {
        Write-Verbose "Calling Eventstream API with EventstreamId"
        Write-Verbose "------------------------------------------"
        Write-Verbose "Sending the following values to the Eventstream API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: DELETE"
        Write-Verbose "URI: $eventstreamApiUrl"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method DELETE `
                            -Uri $eventstreamApiUrl `
                            -ContentType "application/json"

        $response
    }
}

end {}

}