function Get-FabricLakehouseTable {
    <#
.SYNOPSIS
Retrieves tables from a specified Lakehouse in a Fabric workspace.

.DESCRIPTION
This function retrieves tables from a specified Lakehouse in a Fabric workspace. It handles pagination using a continuation token to ensure all data is retrieved.
.PARAMETER WorkspaceId
The ID of the workspace containing the Lakehouse.
.PARAMETER LakehouseId
The ID of the Lakehouse from which to retrieve tables.
.EXAMPLE
Get-FabricLakehouseTable -WorkspaceId "your-workspace-id" -LakehouseId "your-lakehouse-id"
This example retrieves all tables from the specified Lakehouse in the specified workspace.

    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$LakehouseId
    )

    try {
        # Step 1: Ensure token validity
        Test-TokenExpired



        # Step 2: Initialize variables
        $continuationToken = $null
        $tables = @()
        $maxResults = 100

        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
            Add-Type -AssemblyName System.Web
        }

        $baseApiEndpointUrl = "{0}/workspaces/{1}/lakehouses/{2}/tables?maxResults={3}" -f $FabricConfig.BaseUrl, $WorkspaceId, $LakehouseId, $maxResults

        # Step 3:  Loop to retrieve data with continuation token
        Write-Message -Message "Loop started to get continuation token" -Level Debug
        do {
            # Step 4: Construct the API URL
            $apiEndpointUrl = $baseApiEndpointUrl

            if ($null -ne $continuationToken) {
                # URL-encode the continuation token
                $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)
                $apiEndpointUrl = "{0}&continuationToken={1}" -f $apiEndpointUrl, $encodedToken
            }
            Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

            # Step 5: Make the API request
            $response = Invoke-RestMethod `
                -Headers $FabricConfig.FabricHeaders `
                -Uri $apiEndpointUrl `
                -Method Get `
                -ErrorAction Stop `
                -SkipHttpErrorCheck `
                -StatusCodeVariable "statusCode"

            Write-Message -Message "API response code: $statusCode" -Level Debug
            # Step 6: Validate the response code
            if ($statusCode -ne 200) {
                Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
                Write-Message -Message "Error: $($response.message)" -Level Error
                Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
                Write-Message "Error Code: $($response.errorCode)" -Level Error
                return $null
            }

            # Step 7: Add data to the list
            if ($null -ne $response) {
                Write-Message -Message "Adding data to the list" -Level Debug
                $tables += $response.data

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
        if ($tables) {
            Write-Message -Message "Tables found in the Lakehouse '$LakehouseId'." -Level Debug
            return $tables
        } else {
            Write-Message -Message "No tables found matching in the Lakehouse '$LakehouseId'." -Level Warning
            return $null
        }
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Lakehouse. Error: $errorDetails" -Level Error
    }

}
