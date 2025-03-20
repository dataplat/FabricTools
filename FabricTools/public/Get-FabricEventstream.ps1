function Get-FabricEventstream {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Eventstreams

.DESCRIPTION
    Retrieves Fabric Eventstreams. Without the EventstreamName or EventstreamID parameter, all Eventstreams are returned.
    If you want to retrieve a specific Eventstream, you can use the EventstreamName or EventstreamID parameter. These
    parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventstreams should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventstreamName
    The name of the Eventstream to retrieve. This parameter cannot be used together with EventstreamID.

.PARAMETER EventstreamId
    The Id of the Eventstream to retrieve. This parameter cannot be used together with EventstreamName. The value for EventstreamId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will give you all Eventstreams in the Workspace.

.EXAMPLE
    Get-FabricEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamName 'MyEventstream'

    This example will give you all Information about the Eventstream with the name 'MyEventstream'.

.EXAMPLE
    Get-FabricEventstream `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventstreamId '12345678-1234-1234-1234-123456789012'

    This example will give you all Information about the Eventstream with the Id '12345678-1234-1234-1234-123456789012'.

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventstream/items/get-eventstream?tabs=HTTP

.NOTES
    TODO: Add functionality to list all Eventhouses. To do so fetch all workspaces and
          then all eventhouses in each workspace.

    Revision History:
        - 2024-11-09 - FGE: Added DisplaName as Alias for EventStreamName
        - 2024-11-27 - FGE: Added Verbose Output
#>

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name", "DisplayName")]
        [string]$EventstreamName,

        [Alias("Id")]
        [string]$EventstreamId
    )

begin {

    Confirm-FabricAuthToken | Out-Null

    Write-Verbose "You can either use Name or WorkspaceID not both. If both are used throw error"
    if ($PSBoundParameters.ContainsKey("EventstreamName") -and $PSBoundParameters.ContainsKey("EventstreamID")) {
        throw "Parameters EventstreamName and EventstreamID cannot be used together"
    }

    # Create Eventhouse API
    $eventstreamApiUrl = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/eventstreams"

    $eventstreamAPIEventstreamIdUrl = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/eventstreams/$EventstreamId"

}

process {

    if ($PSBoundParameters.ContainsKey("EventstreamId")) {
        Write-Verbose "Calling Eventstream API with EventstreamId"
        Write-Verbose "------------------------------------------"
        Write-Verbose "Sending the following values to the Eventstream API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: PATCH"
        Write-Verbose "URI: $eventstreamAPIEventstreamIdUrl"
        Write-Verbose "Body of request: $body"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $eventstreamAPIEventstreamIdUrl `
                    -ContentType "application/json"

        $response
    }
    else {
            Write-Verbose "Calling Eventstream API"
            Write-Verbose "-----------------------"
            Write-Verbose "Sending the following values to the Eventstream API:"
            Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
            Write-Verbose "Method: PATCH"
            Write-Verbose "URI: $eventstreamApiUrl"
            Write-Verbose "Body of request: $body"
            Write-Verbose "ContentType: application/json"
            $response = Invoke-RestMethod `
                        -Headers $FabricSession.headerParams `
                        -Method GET `
                        -Uri $eventstreamApiUrl `
                        -ContentType "application/json"

        if ($PSBoundParameters.ContainsKey("EventstreamName")) {
            Write-Verbose "Filtering Eventstream with name $EventstreamName"
            $response.value | `
                Where-Object { $_.displayName -eq $EventstreamName }
        }
        else {
            Write-Verbose "Returning all Eventstreams"
            $response.value
        }
    }

}

end {}

}