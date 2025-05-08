function New-FabricKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric KQLDatabase

.DESCRIPTION
    Creates a new Fabric KQLDatabase. The KQLDatabase is created in the specified Workspace and Eventhouse.
    It will be created with the specified name and description.

.PARAMETER  WorkspaceID
    Id of the Fabric Workspace for which the KQLDatabase should be created. The value for WorkspaceID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER  EventhouseID
    Id of the Fabric Eventhouse for which the KQLDatabase should be created. The value for EventhouseID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER  KQLDatabaseName
    The name of the KQLDatabase to create. The name must be unique within the eventhouse and is a
    mandatory parameter.

.PARAMETER  KQLDatabaseDescription
    The description of the KQLDatabase to create.

.EXAMPLE
    New-FabricKQLDatabase `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -EventhouseID '12345678-1234-1234-1234-123456789012' `
        -KQLDatabaseName 'MyKQLDatabase' `
        -KQLDatabaseDescription 'This is my KQLDatabase'

    This example will create a new KQLDatabase with the name 'MyKQLDatabase' and the description 'This is my KQLDatabase'.

.NOTES
    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDatabaseName
    - 2024-12-08 - FGE: Added Verbose Output
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID,

        [Parameter(Mandatory=$true)]
        [string]$EventhouseID,

        [Parameter(Mandatory=$true)]
        [Alias("Name", "DisplayName")]
        [string]$KQLDatabaseName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$KQLDatabaseDescription

    )

begin {
    Confirm-FabricAuthToken | Out-Null

    Write-Verbose "Create body for the request"
    $body = @{
        'displayName' = $KQLDatabaseName
        'description' = $KQLDatabaseDescription
        'creationPayload'= @{
                'databaseType' = "ReadWrite";
                'parentEventhouseItemId' = $EventhouseId}
    } | ConvertTo-Json `
            -Depth 1

    # Create KQLDatabase API URL
    $KQLDatabaseApiUrl = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/KQLDatabases"
    }

process {

    if($PSCmdlet.ShouldProcess($EventhouseName)) {
        Write-Verbose "Calling KQLDatabase API"
        Write-Verbose "-----------------------"
        Write-Verbose "Sending the following values to the Eventstream API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: POST"
        Write-Verbose "URI: $KQLDatabaseApiUrl"
        Write-Verbose "Body of request: $body"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method POST `
                            -Uri $KQLDatabaseApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {

}

}