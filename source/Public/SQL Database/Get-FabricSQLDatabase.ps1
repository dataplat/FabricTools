function Get-FabricSQLDatabase {

    <#
.SYNOPSIS
    Retrieves Fabric SQLDatabases

.DESCRIPTION
    Retrieves Fabric SQLDatabases. Without the SQLDatabaseName or SQLDatabaseID parameter,
    all SQLDatabases are returned. If you want to retrieve a specific SQLDatabase, you can
    use the SQLDatabaseName or SQLDatabaseID parameter. These parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the SQLDatabases should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER SQLDatabaseName
    The name of the KQLDatabase to retrieve. This parameter cannot be used together with SQLDatabaseID.

.PARAMETER SQLDatabaseID
    The Id of the SQLDatabase to retrieve. This parameter cannot be used together with SQLDatabaseName.
    The value for SQLDatabaseID is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricSQLDatabase `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -SQLDatabaseName 'MySQLDatabase'

    This example will retrieve the SQLDatabase with the name 'MySQLDatabase'.

.EXAMPLE
    Get-FabricSQLDatabase

    This example will retrieve all SQLDatabases in the workspace that is specified
    by the WorkspaceId.

.EXAMPLE
    Get-FabricSQLDatabase `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -SQLDatabaseId '12345678-1234-1234-1234-123456789012'

    This example will retrieve the SQLDatabase with the ID '12345678-1234-1234-1234-123456789012'.

.NOTES
    Revision History:
        - 2025-03-06 - KNO: Init version of the function

    Author: Kamil Nowinski

    #>


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true )]
        $Workspace,

        [Alias("Name", "DisplayName")]
        [string]$SQLDatabaseName,

        [Alias("Id")]
        [string]$SQLDatabaseId
    )

    begin {
        Confirm-TokenState

        if ($PSBoundParameters.ContainsKey("SQLDatabaseName") -and $PSBoundParameters.ContainsKey("SQLDatabaseId")) {
            throw "Parameters SQLDatabaseName and SQLDatabaseId cannot be used together"
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject') {
            $WorkspaceId = $Workspace.id
        }

        # Create SQLDatabase API
        $uri = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/SqlDatabases"
        if ($SQLDatabaseId) {
            $uri = "$uri/$SQLDatabaseId"
        }
        $response = Invoke-FabricRestMethod -Uri $uri
        ##$databases.Where({$_.displayName -eq $body.displayName}).id

        # Step: Validate the response code
        if ($statusCode -ne 200) {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        $response = $response.value
        if ($SQLDatabaseName) {
            # Filter the SQLDatabase by name
            $response = $response | Where-Object { $_.displayName -eq $SQLDatabaseName }
        }
        return $response
    }
}
