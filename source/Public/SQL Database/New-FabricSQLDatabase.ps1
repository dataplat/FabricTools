<#
.SYNOPSIS
    Creates a new SQL Database in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to create a new SQL Database
    in the specified workspace. It supports optional parameters for SQL Database description
    and path definitions for the SQL Database content.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the SQL Database will be created.

.PARAMETER Name
    The name of the SQL Database to be created.

.PARAMETER Description
    An optional description for the SQL Database.

.PARAMETER NoWait
    If specified, the function will not wait for the operation to complete and will return immediately.

.EXAMPLE
    New-FabricSQLDatabase -WorkspaceId "workspace-12345" -Name "NewDatabase"

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Kamil Nowinski

#>

function New-FabricSQLDatabase
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [switch]$NoWait = $false
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/sqldatabases" -f $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $Name
        }

        if ($Description)
        {
            $body.description = $Description
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Step 4: Make the API request
        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Create SQL Database"))
        {
            $response = Invoke-FabricRestMethod -Uri $apiEndpointUrl -Method Post -Body $bodyJson
        }
        # Step 5: Handle and log the response
        Test-FabricApiResponse -response $response -Name $Name -TypeName 'SQL Database' -NoWait:$NoWait
        Write-Message -Message "SQL Database '$Name' created successfully!" -Level Info
    }
    catch
    {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create SQL Database. Error: $errorDetails" -Level Error
    }
}
