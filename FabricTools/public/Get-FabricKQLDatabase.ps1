function Get-FabricKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Retrieves Fabric KQLDatabases

.DESCRIPTION
    Retrieves Fabric KQLDatabases. Without the KQLDatabaseName or KQLDatabaseID parameter,
    all KQLDatabases are returned. If you want to retrieve a specific KQLDatabase, you can
    use the KQLDatabaseName or KQLDatabaseID parameter. These parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLDatabases should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDatabaseName
    The name of the KQLDatabase to retrieve. This parameter cannot be used together with KQLDatabaseID.

.PARAMETER KQLDatabaseID
    The Id of the KQLDatabase to retrieve. This parameter cannot be used together with KQLDatabaseName.
    The value for KQLDatabaseID is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricKQLDatabase `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLDatabaseName 'MyKQLDatabase'

    This example will retrieve the KQLDatabase with the name 'MyKQLDatabase'.

.EXAMPLE
    Get-FabricKQLDatabase

    This example will retrieve all KQLDatabases in the workspace that is specified
    by the WorkspaceId.

.EXAMPLE
    Get-FabricKQLDatabase `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLDatabaseId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the KQLDatabase with the ID '12345678-1234-1234-1234-123456789012'.

.NOTES
    TODO: Add functionality to list all KQLDatabases. To do so fetch all workspaces and
          then all KQLDatabases in each workspace.

    Revision History:
        - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDatabaseName
        - 2024-12-08 - FGE: Added Verbose Output

#>


[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Alias("Name","DisplayName")]
        [string]$KQLDatabaseName,

        [Alias("Id")]
        [string]$KQLDatabaseId
    )

begin {

    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "You can either use KQLDatabaseName or KQLDatabaseID not both. If both are used throw error"
    if ($PSBoundParameters.ContainsKey("KQLDatabaseName") -and $PSBoundParameters.ContainsKey("KQLDatabaseId")) {
        throw "Parameters KQLDatabaseName and KQLDatabaseId cannot be used together"
    }

    # Create KQLDatabase API
    $KQLDatabaseAPI = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/kqldatabases"

    $KQLDatabaseAPIKQLDatabaseId = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/kqldatabases/$KQLDatabaseId"

}

process {

    if ($PSBoundParameters.ContainsKey("KQLDatabaseId")) {
        Write-Verbose "Calling KQLDatabase API with KQLDatabaseId : $KQLDatabaseId"
        Write-Verbose "-------------------------------------------------------------------------"
        Write-Verbose "Sending the following values to the KQLDatabase API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $KQLDatabaseAPIKQLDatabaseId"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $KQLDatabaseAPIKQLDatabaseId `
                    -ContentType "application/json"

        Write-Verbose "Adding Members to the Output object for convenience"
        Write-Verbose "Adding Member parentEventhouseItemId with value $($response.properties.parentEventhouseItemId)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'parentEventhouseItemId' `
            -Value $response.properties.parentEventhouseItemId `
            -InputObject $response `
            -Force

        Write-Verbose "Adding Member queryServiceUri with value $($response.properties.queryServiceUri)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'queryServiceUri' `
            -Value $response.properties.queryServiceUri `
            -InputObject $response `
            -Force

        Write-Verbose "Adding Member ingestionServiceUri with value $($response.properties.ingestionServiceUri)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'ingestionServiceUri' `
            -Value $response.properties.ingestionServiceUri `
            -InputObject $response `
            -Force

        Write-Verbose "Adding Member databaseType with value $($response.properties.databaseType)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'databaseType' `
            -Value $response.properties.databaseType `
            -InputObject $response `
            -Force

        Write-Verbose "Adding Member oneLakeStandardStoragePeriod with value $($response.properties.oneLakeStandardStoragePeriod)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'oneLakeStandardStoragePeriod' `
            -Value $response.properties.oneLakeStandardStoragePeriod `
            -InputObject $response `
            -Force

        Write-Verbose "Adding Member oneLakeCachingPeriod with value $($response.properties.oneLakeCachingPeriod)"
        Add-Member `
            -MemberType NoteProperty `
            -Name 'oneLakeCachingPeriod' `
            -Value $response.properties.oneLakeCachingPeriod `
            -InputObject $response `
            -Force

        $response
    }
    else {
        Write-Verbose "Calling KQLDatabase API"
        Write-Verbose "-----------------------"
        Write-Verbose "Sending the following values to the KQLDatabase API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: GET"
        Write-Verbose "URI: $KQLDatabaseAPI"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                    -Headers $FabricSession.headerParams `
                    -Method GET `
                    -Uri $KQLDatabaseAPI `
                    -ContentType "application/json"

        Write-Verbose "Adding Members to the Output object for convenience"
        foreach ($kqlDatabase in $response.value) {
            Write-Verbose "Adding Member parentEventhouseItemId with value $($response.properties.parentEventhouseItemId)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'parentEventhouseItemId' `
                -Value $response.properties.parentEventhouseItemId `
                -InputObject $response `
                -Force

            Write-Verbose "Adding Member queryServiceUri with value $($kqlDatabase.properties.queryServiceUri)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'queryServiceUri' `
                -Value $kqlDatabase.properties.queryServiceUri `
                -InputObject $kqlDatabase `
                -Force

            Write-Verbose "Adding Member ingestionServiceUri with value $($kqlDatabase.properties.ingestionServiceUri)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'ingestionServiceUri' `
                -Value $kqlDatabase.properties.ingestionServiceUri `
                -InputObject $kqlDatabase `
                -Force
            Write-Verbose "Adding Member databaseType with value $($kqlDatabase.properties.databaseType)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'databaseType' `
                -Value $kqlDatabase.properties.databaseType `
                -InputObject $kqlDatabase `
                -Force

            Write-Verbose "Adding Member oneLakeStandardStoragePeriod with value $($kqlDatabase.properties.oneLakeStandardStoragePeriod)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'oneLakeStandardStoragePeriod' `
                -Value $kqlDatabase.properties.oneLakeStandardStoragePeriod `
                -InputObject $kqlDatabase `
                -Force

            Write-Verbose "Adding Member oneLakeCachingPeriod with value $($kqlDatabase.properties.oneLakeCachingPeriod)"
            Add-Member `
                -MemberType NoteProperty `
                -Name 'oneLakeCachingPeriod' `
                -Value $kqlDatabase.properties.oneLakeCachingPeriod `
                -InputObject $kqlDatabase `
                -Force
        }

        if ($PSBoundParameters.ContainsKey("KQLDatabaseName")) {
            Write-Verbose "Filtering KQLDatabases by name. Name: $KQLDatabaseName"
            $response.value | `
                Where-Object { $_.displayName -eq $KQLDatabaseName }
        }
        else {
            Write-Verbose "Returning all KQLDatabases"
            $response.value
        }
    }
}

end {}

}