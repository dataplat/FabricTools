function Remove-FabricKQLDatabase {
<#
.SYNOPSIS
    Removes an existing Fabric Eventhouse

.DESCRIPTION
    Removes an existing Fabric Eventhouse. The Eventhouse is removed from the specified Workspace.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace from which the Eventhouse should be removed. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseId
    The Id of the Eventhouse to remove. The value for EventhouseId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER KQLDatabaseId
    The Id of the Eventhouse to remove. The value for EventhouseId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.
    This parameter is an alias for EventhouseId.

.EXAMPLE
    Remove-FabricEventhouse `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -EventhouseId '12345678-1234-1234-1234-123456789012'

    This example will remove the Eventhouse with the Id '12345678-1234-1234-1234-123456789012'.

.NOTES
    TODO: Add functionality to remove Eventhouse by name.

    Revsion History:

    - 2024-12-08 - FGE: Added Verbose Output

#>


[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$KQLDatabaseId
    )

begin {
    Confirm-FabricAuthToken | Out-Null

    Write-Verbose "Create Eventhouse API URL"
    $eventhouseApiUrl = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/KQLDatabases/$KQLDatabaseId"

}

process {

    if($PSCmdlet.ShouldProcess($KQLDatabaseId)) {
        Write-Verbose "Calling KQLDatabase API"
        Write-Verbose "-----------------------"
        Write-Verbose "Sending the following values to the Eventstream API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: DELETE"
        Write-Verbose "URI: $eventhouseApiUrl"
        Write-Verbose "ContentType: application/json"
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
