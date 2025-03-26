function Get-FabricEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric Eventhouses

.DESCRIPTION
    Retrieves Fabric Eventhouses. Without the EventhouseName or EventhouseID parameter, all Eventhouses are returned.
    If you want to retrieve a specific Eventhouse, you can use the EventhouseName or EventhouseID parameter. These
    parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the Eventhouses should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseName
    The name of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseID.

.PARAMETER EventhouseId
    The Id of the Eventhouse to retrieve. This parameter cannot be used together with EventhouseName. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012'

    This example will give you all Eventhouses in the Workspace.

.EXAMPLE
    Get-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseName 'MyEventhouse'

    This example will give you all Information about the Eventhouse with the name 'MyEventhouse'.

.EXAMPLE
    Get-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012'

    This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

    .EXAMPLE
    Get-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012' `
        -Verbose

    This example will give you all Information about the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.
    It will also give you verbose output which is useful for debugging.

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/list-eventhouses?tabs=HTTP

.NOTES
    TODO: Add functionality to list all Eventhouses in the subscription. To do so fetch all workspaces
    and then all eventhouses in each workspace.

    Revsion History:

    - 2024-11-09 - FGE: Added DisplaName as Alias for EventhouseName
    - 2024-11-16 - FGE: Added Verbose Output
    - 2024-11-27 - FGE: Added more Verbose Output
#>

#

[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name","DisplayName")]
        [string]$EventhouseName,

        [Alias("Id")]
        [string]$EventhouseId
    )

begin {

    Confirm-FabricAuthToken | Out-Null

    # You can either use Name or WorkspaceID
    Write-Verbose "Checking if EventhouseName and EventhouseID are used together. This is not allowed"
    if ($PSBoundParameters.ContainsKey("EventhouseName") -and $PSBoundParameters.ContainsKey("EventhouseID")) {
        throw "Parameters EventhouseName and EventhouseID cannot be used together"
    }

    # Create Eventhouse API
    $eventhouseAPI = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/eventhouses"
    Write-Verbose "Creating the URL for the Eventhouse API: $eventhouseAPI"

    $eventhouseAPIEventhouseId = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/eventhouses/$EventhouseId"
    Write-Verbose "Creating the URL for the Eventhouse API when the Id is used: $eventhouseAPIEventhouseId"

}

process {

    if ($PSBoundParameters.ContainsKey("EventhouseId")) {
        Write-Verbose "Calling Eventhouse API with EventhouseId"
        Write-Verbose "----------------------------------------"
        Write-Verbose "Sending the following values to the Eventhouse API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $eventhouseAPIEventhouseId"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                        -Headers $FabricSession.headerParams `
                        -Method GET `
                        -Uri $eventhouseAPIEventhouseId `
                        -ContentType "application/json"

        Write-Verbose "Adding the member queryServiceUri: $($response.properties.queryServiceUri)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'queryServiceUri' `
            -Value $response.properties.queryServiceUri `
            -InputObject $response `
            -Force

        Write-Verbose "Adding the member ingestionServiceUri: $($response.properties.ingestionServiceUri)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'ingestionServiceUri' `
            -Value $response.properties.ingestionServiceUri `
            -InputObject $response `
            -Force

        Write-Verbose "Adding the member databasesItemIds: $($response.properties.databasesItemIds)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'databasesItemIds' `
            -Value $response.properties.databasesItemIds `
            -InputObject $response `
            -Force

        Write-Verbose "Adding the member minimumConsumptionUnits: $($response.properties.minimumConsumptionUnits)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'minimumConsumptionUnits' `
            -Value $response.properties.minimumConsumptionUnits `
            -InputObject $response `
            -Force

        $response
    }
    else {
        Write-Verbose "Calling Eventhouse API without EventhouseId"
        Write-Verbose "-------------------------------------------"
        Write-Verbose "Sending the following values to the Eventhouse API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $eventhouseAPI"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $eventhouseAPI `
                    -ContentType "application/json"

        foreach ($eventhouse in $response.value) {
            Write-Verbose "Adding the member queryServiceUri: $($eventhouse.properties.queryServiceUri)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'queryServiceUri' `
                -Value $eventhouse.properties.queryServiceUri `
                -InputObject $eventhouse `
                -Force

            Write-Verbose "Adding the member ingestionServiceUri: $($eventhouse.properties.ingestionServiceUri)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'ingestionServiceUri' `
                -Value $eventhouse.properties.ingestionServiceUri `
                -InputObject $eventhouse `
                -Force

            Write-Verbose "Adding the member databasesItemIds: $($eventhouse.properties.databasesItemIds)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'databasesItemIds' `
                -Value $eventhouse.properties.databasesItemIds `
                -InputObject $eventhouse `
                -Force

            Write-Verbose "Adding the member minimumConsumptionUnits: $($eventhouse.properties.minimumConsumptionUnits)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'minimumConsumptionUnits' `
                -Value $eventhouse.properties.minimumConsumptionUnits `
                -InputObject $eventhouse `
                -Force
        }

        if ($PSBoundParameters.ContainsKey("EventhouseName")) {
            Write-Verbose "Filtering the Eventhouse by EventhouseName: $EventhouseName"
            $response.value | `
                Where-Object { $_.displayName -eq $EventhouseName }
        }
        else {
            Write-Verbose "Returning all Eventhouses"
            $response.value
        }
    }

}

end {}

}