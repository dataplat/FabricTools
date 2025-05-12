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


.EXAMPLE
 New-FabricSQLDatabase -WorkspaceId "workspace-12345" -Name "NewDatabase"

 .NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Test-TokenExpired` to ensure token validity before making the API request.

Author: Kamil Nowinski

#>

function New-FabricSQLDatabase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[a-zA-Z0-9_]*$')]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Description
    )

    try {
        # Step 1: Ensure token validity
        Test-TokenExpired

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/sqldatabases" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $Name
        }

        if ($Description) {
            $body.description = $Description
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Step 4: Make the API request
        $response = Invoke-RestMethod `
            -Headers $FabricConfig.FabricHeaders `
            -Uri $apiEndpointUrl `
            -Method Post `
            -Body $bodyJson `
            -ContentType "application/json" `
            -ErrorAction Stop `
            -SkipHttpErrorCheck `
            -ResponseHeadersVariable "responseHeader" `
            -StatusCodeVariable "statusCode"

        # Step 5: Handle and log the response
        Write-Message "RESPONSE: $response" -Level Debug
        Test-FabricApiResponse -response $response -responseHeader $responseHeader -statusCode $statusCode -Name $Name -TypeName 'SQL Database'
    } catch {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create SQL Database. Error: $errorDetails" -Level Error
    }
}