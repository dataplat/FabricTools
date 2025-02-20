function Set-FabricKQLDatabase {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric KQLDatabase

.DESCRIPTION
    Updates Properties of an existing Fabric KQLDatabase. The KQLDatabase is updated
    in the specified Workspace. The KQLDatabaseId is used to identify the KQLDatabase
    that should be updated. The KQLDatabaseNewName and KQLDatabaseDescription are the
    properties that can be updated.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLDatabase should be updated. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDatabaseId
    The Id of the KQLDatabase to update. The value for KQLDatabaseId is a GUID.
    An example of a GUID is '12345678-1234-123-1234-123456789012'.

.PARAMETER NewKQLDatabaseName
    The new name of the KQLDatabase.

.PARAMETER KQLDatabaseDescription
    The new description of the KQLDatabase. The description can be up to 256 characters long.

.EXAMPLE
    Set-FabricKQLDatabase `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLDatabaseId '12345678-1234-1234-1234-123456789012' `
        -NewKQLDatabaseNewName 'MyNewKQLDatabase' `
        -KQLDatabaseDescription 'This is my new KQLDatabase'

    This example will update the KQLDatabase with the Id '12345678-1234-1234-1234-123456789012'.
    It will update the name to 'MyNewKQLDatabase' and the description to 'This is my new KQLDatabase'.

.NOTES

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for KQLDatabaseName
    - 2024-12-08 - FGE: Added Verbose Output
                        Renamed Parameter KQLDatabaseName to NewKQLDatabaseNewName

.LINK

#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$KQLDatabaseId,

        [Alias("NewName", "NewDisplayName")]
        [string]$NewKQLDatabaseName,

        [Alias("Description")]
        [ValidateLength(0, 256)]
        [string]$KQLDatabaseDescription

    )

begin {
    Write-Verbose "Check if session is established - if not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-RTISession"
    }

    Write-Verbose "Create body of request"
    $body = @{}

    if ($PSBoundParameters.ContainsKey("NewKQLDatabaseName")) {
        $body["displayName"] = $NewKQLDatabaseName
    }

    if ($PSBoundParameters.ContainsKey("KQLDatabaseDescription")) {
        $body["description"] = $KQLDatabaseDescription
    }

    $body = $body `
                | ConvertTo-Json `
                    -Depth 1

    # Create KQLDatabase API URL
    $KQLDatabaseApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/KQLDatabases/$KQLDatabaseId"
    }

process {

    if($PSCmdlet.ShouldProcess($KQLDatabaseId)) {
        Write-Verbose "Calling KQLDatabase API with KQLDatabaseId $KQLDatabaseId"
        Write-Verbose "------------------------------------------------------------------------------------"
        Write-Verbose "Sending the following values to the KQLDatabase API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: PATCH"
        Write-Verbose "URI: $KQLDatabaseApiUrl"
        Write-Verbose "Body of request: $body"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method PATCH `
                            -Uri $KQLDatabaseApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}