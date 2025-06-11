function Get-FabricMirroredDatabaseTableStatus {
    <#

    .SYNOPSIS
    Retrieves the status of tables in a mirrored database.

    .DESCRIPTION
    Retrieves the status of tables in a mirrored database. The function validates the authentication token, constructs the API endpoint URL, and makes a POST request to retrieve the mirroring status of tables. It handles errors and logs messages at various levels (Debug, Error).

    .PARAMETER WorkspaceId
    The ID of the workspace containing the mirrored database.

    .PARAMETER MirroredDatabaseId
    The ID of the mirrored database whose table status is to be retrieved.

    .EXAMPLE
    Get-FabricMirroredDatabaseTableStatus -WorkspaceId "your-workspace-id" -MirroredDatabaseId "your-mirrored-database-id"
    This example retrieves the status of tables in a mirrored database with the specified ID in the specified workspace.

    .NOTES
    The function retrieves the PowerBI access token and makes a POST request to the PowerBI API to retrieve the status of tables in the specified mirrored database. It then returns the 'value' property of the response, which contains the table statuses.

    Author: Tiago Balabuch

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MirroredDatabaseId
    )

    try {

        # Step 2: Ensure token validity
        Confirm-TokenState

        $continuationToken = $null
        $MirroredDatabaseTableStatus = @()

        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
            Add-Type -AssemblyName System.Web
        }

        # Step 4: Loop to retrieve all capacities with continuation token
        Write-Message -Message "Loop started to get continuation token" -Level Debug
        $baseApiEndpointUrl = "{0}/workspaces/{1}/mirroredDatabases/{2}/getTablesMirroringStatus" -f $FabricConfig.BaseUrl, $WorkspaceId, $MirroredDatabaseId

        # Step 3:  Loop to retrieve data with continuation token

        do {
            # Step 5: Construct the API URL
            $apiEndpointUrl = $baseApiEndpointUrl

            if ($null -ne $continuationToken) {
                # URL-encode the continuation token
                $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)
                $apiEndpointUrl = "{0}?continuationToken={1}" -f $apiEndpointUrl, $encodedToken
            }
            Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

            # Step 6: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Post

            # Step 7: Validate the response code
            if ($statusCode -ne 200) {
                Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
                Write-Message -Message "Error: $($response.message)" -Level Error
                Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
                Write-Message "Error Code: $($response.errorCode)" -Level Error
                return $null
            }

            # Step 8: Add data to the list
            if ($null -ne $response) {
                Write-Message -Message "Adding data to the list" -Level Debug
                $MirroredDatabaseTableStatus += $response.data

                # Update the continuation token if present
                if ($response.PSObject.Properties.Match("continuationToken")) {
                    Write-Message -Message "Updating the continuation token" -Level Debug
                    $continuationToken = $response.continuationToken
                    Write-Message -Message "Continuation token: $continuationToken" -Level Debug
                } else {
                    Write-Message -Message "Updating the continuation token to null" -Level Debug
                    $continuationToken = $null
                }
            } else {
                Write-Message -Message "No data received from the API." -Level Warning
                break
            }
        } while ($null -ne $continuationToken)
        Write-Message -Message "Loop finished and all data added to the list" -Level Debug

        # Step 9: Handle results
        # Return all Mirrored Database Table Status
        Write-Message -Message "No filter provided. Returning all MirroredDatabases." -Level Debug
        $MirroredDatabaseTableStatus
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve MirroredDatabase. Error: $errorDetails" -Level Error
    }

}
