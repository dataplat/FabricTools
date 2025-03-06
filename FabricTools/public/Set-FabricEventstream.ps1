function Set-FabricEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric Eventstream

.DESCRIPTION
    Updates Properties of an existing Fabric Eventstream

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventstream should be updated. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamId
    The Id of the Eventstream to update. The value for EventstreamId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamNewName
    The new name of the Eventstream.

.PARAMETER EventstreamDescription
    The new description of the Eventstream.

.EXAMPLE
    Set-FabricEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamId '12345678-1234-1234-1234-123456789012' `
        -EventstreamNewName 'MyNewEventstream' `
        -EventstreamDescription 'This is my new Eventstream'

    This example will update the Eventstream with the Id '12345678-1234-1234-1234-123456789012'.

.NOTES
    TODO: Add functionality to update Eventstream properties using EventstreamName instead of EventstreamId

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for EventStreamNewName
    - 2024-12-08 - FGE: Added Verbose Output
                        Added Aliases for EventstreamNewName and EventstreamDescription
                        Corrected typo in EventstreamNewName Variable
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$EventstreamId,

        [Alias("NewName","NewDisplayName")]
        [string]$EventstreamNewName,

        [ValidateLength(0, 256)]
        [Alias("Description","NewDescription", "EventstreamNewDescription")]
        [string]$EventstreamDescription

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-FabricAccount"
    }

    Write-Verbose "Create body of request"
    $body = @{}

    if ($PSBoundParameters.ContainsKey("EventstreamNewName")) {
        Write-Verbose "Setting EventstreamNewName: $EventstreamNewName"
        $body["displayName"] = $EventstreamNewName
    }

    if ($PSBoundParameters.ContainsKey("EventstreamDescription")) {
        Write-Verbose "Setting EventstreamDescription: $EventstreamDescription"
        $body["description"] = $EventstreamDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create Eventstream API URL
    $EventstreamApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/Eventstreams/$EventstreamId"
    }

process {

    if($PSCmdlet.ShouldProcess($EventhouseName)) {
        Write-Verbose "Calling Eventstream API with EventstreamId"
        Write-Verbose "------------------------------------------"
        Write-Verbose "Sending the following values to the Eventstream API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: PATCH"
        Write-Verbose "URI: $EventstreamApiUrl"
        Write-Verbose "Body of request: $body"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method PATCH `
                            -Uri $EventstreamApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}