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
    WorkspaceId = '12345678-1234-1234-1234-123456789012' SQLDatabaseName = 'MySQLDatabase' } Get-FabricSQLDatabase @FabricSQLDatabaseConfig Returns the details of the Fabric SQL Database with the name 'MySQLDatabase' in the workspace that is specified by the WorkspaceId.

    ```powershell
    $FabricSQLDatabaseConfig = @{
    ```

.EXAMPLE
    Returns the details of the Fabric SQL Databases in the workspace that is specified by the WorkspaceId.

    ```powershell
    Get-FabricSQLDatabase -WorkspaceId '12345678-1234-1234-1234-123456789012'
    ```

.EXAMPLE
    WorkspaceId = '12345678-1234-1234-1234-123456789012' } Get-FabricSQLDatabase @FabricSQLDatabaseConfig Returns the details of the Fabric SQL Database with the ID '12345678-1234-1234-1234-123456789012' from the workspace with the ID '12345678-1234-1234-1234-123456789012'.

    ```powershell
    $FabricSQLDatabaseConfig = @{
    -SQLDatabaseId = '12345678-1234-1234-1234-123456789012'
    ```

.EXAMPLE
    Returns the details of the Fabric SQL Databases in the MsLearn-dev workspace.

    ```powershell
    Get-FabricWorkspace -WorkspaceName 'MsLearn-dev' | Get-FabricSQLDatabase
    ```

.NOTES
    Author: Kamil Nowinski

#>

function Get-FabricSQLDatabase
{
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
        $uri = "workspaces/$WorkspaceId/sqlDatabases"
        if ($SQLDatabaseId)
        {
            $uri = "$uri/$SQLDatabaseId"
        }
        $response = Invoke-FabricRestMethod -Uri $uri

        # Step: Validate the response code
        Test-FabricApiResponse -Response $response -ObjectIdOrName $SQLDatabaseId -TypeName "SQL Database"

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
