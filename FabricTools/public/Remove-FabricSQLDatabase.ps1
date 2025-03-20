function Remove-FabricSQLDatabase {

<#
.SYNOPSIS
    Removes an existing Fabric SQL Database

.DESCRIPTION
    Removes an existing Fabric SQL Database. The SQL Database is removed from the specified Workspace.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace from which the SQL Database should be removed. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER SQLDatabaseId
    The Id of the SQL Database to remove. The value for EventhouseId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Remove-FabricSQLDatabase `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -SQLDatabaseId '12345678-1234-1234-1234-123456789012'

    This example will remove the SQL Database with the Id '12345678-1234-1234-1234-123456789012'.

.NOTES
    TODO: Add functionality to remove SQLDatabase by name.

    Revsion History:
    - 2025-03-06 - KNO: Init version

#>


##[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$SQLDatabaseId
    )

    Confirm-FabricAuthToken | Out-Null

    Write-Verbose "Create API URL"
    $ApiUrl = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/SQLDatabases/$SQLDatabaseId"

    Write-Verbose "Calling SQLDatabase API"
    Write-Verbose "-----------------------"
    Write-Verbose "Sending the following values to the REST API:"
    Write-Verbose "Headers: $($FabricSession.HeaderParams | Format-List | Out-String)"
    Write-Verbose "Method: DELETE"
    Write-Verbose "URI: $ApiUrl"
    Write-Verbose "ContentType: application/json"
    $response = Invoke-RestMethod `
                        -Headers $FabricSession.HeaderParams `
                        -Method DELETE `
                        -Uri $ApiUrl `
                        -ContentType "application/json"

    $response


}