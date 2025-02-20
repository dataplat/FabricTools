function Set-FabricEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric Eventhouse

.DESCRIPTION
    Updates Properties of an existing Fabric Eventhouse

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventhouse should be updated. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseId
    The Id of the Eventhouse to update. The value for EventhouseId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseNewName
    The new name of the Eventhouse.

.PARAMETER EventhouseDescription
    The new description of the Eventhouse.

.EXAMPLE
    Set-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012' `
        -EventhouseNewName 'MyNewEventhouse' `
        -EventhouseDescription 'This is my new Eventhouse'

    This example will update the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'
    in the Workspace with the Id '12345678-1234-1234-1234-123456789012' to
    have the name 'MyNewEventhouse' and the description
    'This is my new Eventhouse'.

.EXAMPLE
    Set-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012' `
        -EventhouseNewName 'MyNewEventhouse' `
        -EventhouseDescription 'This is my new Eventhouse' `
        -Verbose

    This example will update the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'
    in the Workspace with the Id '12345678-1234-1234-1234-123456789012' to
    have the name 'MyNewEventhouse' and the description 'This is my new Eventhouse'.
    It will also give you verbose output which is useful for debugging.

.NOTES
    TODO: Add functionality to update Eventhouse properties using EventhouseName instead of EventhouseId

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added NewDisplaName as Alias for EventhouseName
    - 2024-11-27 - FGE: Added Verbose Output

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$EventhouseId,

        [Alias("NewName", "NewDisplayName")]
        [string]$EventhouseNewName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$EventhouseDescription

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    # Create body of request
    $body = @{}

    if ($PSBoundParameters.ContainsKey("EventhouseNewName")) {
        Write-Verbose "New name found for Eventhouse. New name is: $EventhouseNewName"
        $body["displayName"] = $EventhouseNewName
    }

    if ($PSBoundParameters.ContainsKey("EventhouseDescription")) {
        Write-Verbose "Description found for Eventhouse. Description is: $EventhouseDescription"
        $body["description"] = $EventhouseDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses/$EventhouseId"
    }

process {

    Write-Verbose "Calling Eventhouse API with EventhouseId"
    Write-Verbose "----------------------------------------"
    Write-Verbose "Sending the following values to the Eventhouse API:"
    Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
    Write-Verbose "Method: PATCH"
    Write-Verbose "URI: $eventhouseApiUrl"
    Write-Verbose "Body of request: $body"
    Write-Verbose "ContentType: application/json"
    if($PSCmdlet.ShouldProcess($EventhouseId)) {
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method PATCH `
                            -Uri $eventhouseApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}