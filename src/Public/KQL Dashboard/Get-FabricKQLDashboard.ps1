function Get-FabricKQLDashboard {
<#
.SYNOPSIS
Retrieves an KQLDashboard or a list of KQLDashboards from a specified workspace in Microsoft Fabric.

.DESCRIPTION
The `Get-FabricKQLDashboard` function sends a GET request to the Fabric API to retrieve KQLDashboard details for a given workspace. It can filter the results by `KQLDashboardName`.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query KQLDashboards.

.PARAMETER KQLDashboardId
(Optional) The ID of the specific KQLDashboard to retrieve.

.PARAMETER KQLDashboardName
(Optional) The name of the specific KQLDashboard to retrieve.

.EXAMPLE
    Retrieves the "Development" KQLDashboard from workspace "12345". .PARAMETER KQLDashboardID The Id of the KQLDashboard to retrieve. This parameter cannot be used together with KQLDashboardName. The value for KQLDashboardID is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.

    ```powershell
    Get-FabricKQLDashboard -WorkspaceId "12345" -KQLDashboardName "Development"
    ```

.EXAMPLE
    Retrieves all KQLDashboards in workspace "12345".

    ```powershell
    Get-FabricKQLDashboard -WorkspaceId "12345"
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$KQLDashboardId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$KQLDashboardName
    )

    try {
        # Handle ambiguous input
        if ($KQLDashboardId -and $KQLDashboardName) {
            Write-Message -Message "Both 'KQLDashboardId' and 'KQLDashboardName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Initialize variables
        $continuationToken = $null
        $KQLDashboards = @()

        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
            Add-Type -AssemblyName System.Web
        }

        # Loop to retrieve all capacities with continuation token
        Write-Message -Message "Loop started to get continuation token" -Level Debug
        $baseApiEndpointUrl = "{0}/workspaces/{1}/kqlDashboards" -f $FabricConfig.BaseUrl, $WorkspaceId

        do {
            # Construct the API URL
            $apiEndpointUrl = $baseApiEndpointUrl

            if ($null -ne $continuationToken) {
                # URL-encode the continuation token
                $encodedToken = [System.Web.HttpUtility]::UrlEncode($continuationToken)
                $apiEndpointUrl = "{0}?continuationToken={1}" -f $apiEndpointUrl, $encodedToken
            }
            Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

            # Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Get

            # Validate the response code
            if ($statusCode -ne 200) {
                Write-Message -Message "Unexpected response code: $statusCode from the API." -Level Error
                Write-Message -Message "Error: $($response.message)" -Level Error
                Write-Message -Message "Error Details: $($response.moreDetails)" -Level Error
                Write-Message "Error Code: $($response.errorCode)" -Level Error
                return $null
            }

            # Add data to the list
            if ($null -ne $response) {
                Write-Message -Message "Adding data to the list" -Level Debug
                $KQLDashboards += $response.value

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

        # Filter results based on provided parameters
        $KQLDashboard = if ($KQLDashboardId) {
            $KQLDashboards | Where-Object { $_.Id -eq $KQLDashboardId }
        } elseif ($KQLDashboardName) {
            $KQLDashboards | Where-Object { $_.DisplayName -eq $KQLDashboardName }
        } else {
            # Return all KQLDashboards if no filter is provided
            Write-Message -Message "No filter provided. Returning all KQLDashboards." -Level Debug
            $KQLDashboards
        }

        # Handle results
        if ($KQLDashboard) {
            Write-Message -Message "KQLDashboard found matching the specified criteria." -Level Debug
            return $KQLDashboard
        } else {
            Write-Message -Message "No KQLDashboard found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve KQLDashboard. Error: $errorDetails" -Level Error
    }

}
