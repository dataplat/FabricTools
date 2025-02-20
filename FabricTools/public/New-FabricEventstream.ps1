function New-FabricEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Eventstream

.DESCRIPTION
    Creates a new Fabric Eventstream

.PARAMETER WorkspaceID
    Id of the Fabric Workspace for which the Eventstream should be created. The value for WorkspaceID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamName
    The name of the Eventstream to create.

.PARAMETER EventstreamDescription
    The description of the Eventstream to create.

.EXAMPLE
    New-FabricEventstream
        -WorkspaceID '12345678-1234-1234-1234-123456789012'
        -EventstreamName 'MyEventstream'
        -EventstreamDescription 'This is my Eventstream'

    This example will create a new Eventstream with the name 'MyEventstream' and the description 'This is my Eventstream'.

.NOTES
    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for EventStreamName
    - 2024-11-30 - FGE: Added Verbose Output

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/create-eventstream?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID,

        [Parameter(Mandatory=$true)]
        [Alias("Name","DisplayName")]
        [string]$EventstreamName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$EventstreamDescription

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "Create body of request"
    $body = @{
    'displayName' = $EventstreamName
    'description' = $EventstreamDescription
    } | ConvertTo-Json `
            -Depth 1

    # Create Eventhouse API URL
    $eventstreamApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventstreams"
    }

process {

    # Call Eventstream API
    if($PSCmdlet.ShouldProcess($EventstreamName)) {
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method POST `
                            -Uri $eventstreamApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}