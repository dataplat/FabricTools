function Get-FabricSQLDatabase
{

    <#
.SYNOPSIS
    Retrieves Fabric SQL Database details.

.DESCRIPTION
    Retrieves Fabric SQL Database details. Without the SQLDatabaseName or SQLDatabaseID parameter,
    all SQL Databases are returned. If you want to retrieve a specific SQLDatabase, you can
    use the SQLDatabaseName or SQLDatabaseID parameter. These parameters cannot be used together.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the SQL Databases should be retrieved. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER Workspace
    The workspace object. This is a mandatory parameter for the 'WorkspaceObject' parameter set and can be pipelined into the function.
    The object can be easily retrieved by Get-FabricWorkspace function.

.PARAMETER SQLDatabaseName
    The name of the SQLDatabase to retrieve. This parameter cannot be used together with SQLDatabaseID.

.PARAMETER SQLDatabaseID
    The Id of the SQLDatabase to retrieve. This parameter cannot be used together with SQLDatabaseName.
    The value for SQLDatabaseID is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    $FabricSQLDatabaseConfig = @{
        WorkspaceId = '12345678-1234-1234-1234-123456789012'
        SQLDatabaseName = 'MySQLDatabase'
    }
    Get-FabricSQLDatabase @FabricSQLDatabaseConfig

    Returns the details of the Fabric SQL Database with the name 'MySQLDatabase' in the workspace that is specified by the WorkspaceId.

.EXAMPLE
    Get-FabricSQLDatabase -WorkspaceId '12345678-1234-1234-1234-123456789012'

    Returns the details of the Fabric SQL Databases in the workspace that is specified by the WorkspaceId.

.EXAMPLE
    $FabricSQLDatabaseConfig = @{
        WorkspaceId = '12345678-1234-1234-1234-123456789012'
        -SQLDatabaseId = '12345678-1234-1234-1234-123456789012'
    }
    Get-FabricSQLDatabase @FabricSQLDatabaseConfig

    Returns the details of the Fabric SQL Database with the ID '12345678-1234-1234-1234-123456789012' from the workspace with the ID '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Get-FabricWorkspace -WorkspaceName 'MsLearn-dev' | Get-FabricSQLDatabase

    Returns the details of the Fabric SQL Databases in the MsLearn-dev workspace.

.NOTES
    Revision History:
        - 2025-03-06 - KNO: Init version of the function
        - 2025-06-14 - Update the examples to remove backticks

    Author: Kamil Nowinski

    #>


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceId')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'WorkspaceObject', ValueFromPipeline = $true )]
        $Workspace,

        [Alias("Name", "DisplayName")]
        [string]$SQLDatabaseName,

        [Alias("Id")]
        [guid]$SQLDatabaseId
    )

    begin
    {
        $return = @()
        Confirm-TokenState

        if ($PSBoundParameters.ContainsKey("SQLDatabaseName") -and $PSBoundParameters.ContainsKey("SQLDatabaseId"))
        {
            Write-Warning "The parameters SQLDatabaseName and SQLDatabaseId cannot be used together"
            return
        }


    }

    process
    {

        if ($PSCmdlet.ParameterSetName -eq 'WorkspaceObject')
        {
            $WorkspaceId = $Workspace.id
        }

        # Create SQLDatabase API
        $uri = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/sqlDatabases"
        if ($SQLDatabaseId)
        {
            $uri = "$uri/$SQLDatabaseId"
        }
        $response = Invoke-FabricRestMethod -Uri $uri
        ##$databases.Where({$_.displayName -eq $body.displayName}).id

        # Step: Validate the response code
        if ($statusCode -ne 200)
        {
            Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
            Write-Message -Message "Error: $($response.message)" -Level Error
            Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
            Write-Message "Error Code: $($response.errorCode)" -Level Error
            return $null
        }

        $response = $response.value
        if ($SQLDatabaseName)
        {
            # Filter the SQLDatabase by name
            $response = $response | Where-Object { $_.displayName -eq $SQLDatabaseName }
        }
        if ($response)
        {
            $return += $response
        }
    }

    End
    {
        $return
    }
}
