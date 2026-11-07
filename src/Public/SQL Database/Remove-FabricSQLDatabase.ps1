function Remove-FabricSQLDatabase
{
    <#
    .SYNOPSIS
        Deletes a SQL Database from a specified workspace in Microsoft Fabric by ID or exact name.

    .DESCRIPTION
        When a name is provided, exactly one SQL Database in the workspace must match. If no database or multiple databases match, no deletion is performed.

    .PARAMETER WorkspaceId
        (Mandatory) The ID of the workspace containing the SQLDatabase to delete.

    .PARAMETER SQLDatabaseId
        The ID of the SQL Database to be deleted.

    .PARAMETER SQLDatabaseName
        The exact name of the SQL Database to be deleted. Supports the alias Name. Use SQLDatabaseId if the name is ambiguous.

    .EXAMPLE
        Deletes the SQL Database with ID "67890" from workspace "12345".

        ```powershell
        Remove-FabricSQLDatabas -WorkspaceId "12345" -SQLDatabaseId "67890"
        ```

    .EXAMPLE
        Deletes the SQL Database with the exact name "MyDatabase" from workspace "12345".

        ```powershell
        Remove-FabricSQLDatabase -WorkspaceId "12345" -SQLDatabaseName "MyDatabase"
        ```

    .NOTES
        - Validates token expiration before making the API request.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [guid]$SQLDatabaseId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name')]
        [string]$SQLDatabaseName
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        if ($PSCmdlet.ParameterSetName -eq 'ByName')
        {
            $databases = @(Get-FabricSQLDatabase -WorkspaceId $WorkspaceId -SQLDatabaseName $SQLDatabaseName | Where-Object { $null -ne $_ })
            if ($databases.Count -eq 0)
            {
                Write-Message -Message "No SQL Database found with the name '$SQLDatabaseName' in workspace '$WorkspaceId'. No database was deleted." -Level Error
                return $null
            }
            if ($databases.Count -gt 1)
            {
                Write-Message -Message "Multiple SQL Databases found with the name '$SQLDatabaseName' in workspace '$WorkspaceId'. Specify SQLDatabaseId instead. No database was deleted." -Level Error
                return $null
            }
            $SQLDatabaseId = [guid]$databases[0].id
            if ($SQLDatabaseId -eq [guid]::Empty)
            {
                throw "The SQL Database '$SQLDatabaseName' has no valid database ID."
            }
        }

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/sqldatabases/{1}" -f $WorkspaceId, $SQLDatabaseId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Delete SQL Database"))
        {
            # Make the API request
            $apiParams = @{
                Uri = $apiEndpointUrl
                Method = 'DELETE'
                TypeName = 'SQL Database'
                ObjectIdOrName = if ($SQLDatabaseName) { $SQLDatabaseName } else { $SQLDatabaseId }
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            $response
        }

    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete SQL Database '$SQLDatabaseId' from workspace '$WorkspaceId'. Error: $errorDetails" -Level Error
    }
}
