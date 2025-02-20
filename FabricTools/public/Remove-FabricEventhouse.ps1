function Remove-FabricEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Removes an existing Fabric Eventhouse

.DESCRIPTION
    Removes an existing Fabric Eventhouse

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventhouse should be deleted. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseId
    The Id of the Eventhouse to delete. The value for EventhouseId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. EventhouseId and EventhouseName cannot be used together.

.PARAMETER EventhouseName
    The name of the Eventhouse to delete. EventhouseId and EventhouseName cannot be used together.

.EXAMPLE
    Remove-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012'

    This example will delete the Eventhouse with the Id '12345678-1234-1234-1234-123456789012' from
    the Workspace with the Id '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Remove-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseName 'MyEventhouse'

    This example will delete the Eventhouse with the name 'MyEventhouse' from the Workspace with the
    Id '12345678-1234-1234-1234-123456789012'.
.NOTES
    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for EventhouseName
    - 2024-11-27 - FGE: Added Verbose Output

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/delete-eventhouse?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Id")]
        [string]$EventhouseId,

        [Alias("Name", "DisplayName")]
        [string]$EventhouseName

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "Check if EventhouseName and EventhouseID are used together. This is not allowed"
    if ($PSBoundParameters.ContainsKey("EventhouseName") -and $PSBoundParameters.ContainsKey("EventhouseID")) {
        throw "Parameters EventhouseName and EventhouseID cannot be used together"
    }

    if ($PSBoundParameters.ContainsKey("EventhouseName")) {
        Write-Verbose "Eventhouse Name $EventhouseName is used. Get Eventhouse ID from Eventhouse Name"
        $eh = Get-FabricEventhouse `
                    -WorkspaceId $WorkspaceId `
                    -EventhouseName $EventhouseName

        $EventhouseId = $eh.id
        Write-Verbose "Eventhouse ID is $EventhouseId"
    }

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses/$EventhouseId"
}

process {

    Write-Verbose "Calling Eventhouse API with EventhouseId"
    Write-Verbose "----------------------------------------"
    Write-Verbose "Sending the following values to the Eventhouse API:"
    Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
    Write-Verbose "Method: DELETE"
    Write-Verbose "URI: $eventhouseApiUrl"
    Write-Verbose "ContentType: application/json"
    if($PSCmdlet.ShouldProcess($EventhouseName)) {
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method DELETE `
                            -Uri $eventhouseApiUrl `
                            -ContentType "application/json"

        $response
    }
}

end {}

}