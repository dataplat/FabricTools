
function Get-FabricCapacity {
<#
.SYNOPSIS
    Retrieves capacity details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves capacity details from a specified workspace using either the provided capacityId or capacityName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER capacityId
    The unique identifier of the capacity to retrieve. This parameter is optional.

.PARAMETER capacityName
    The name of the capacity to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the capacity details for the capacity with ID "capacity-12345".

    ```powershell
    Get-FabricCapacity -capacityId "capacity-12345"
    ```

.EXAMPLE
    This example retrieves the capacity details for the capacity named "MyCapacity".

    ```powershell
    Get-FabricCapacity -capacityName "MyCapacity"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$capacityId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$capacityName
    )
    try {
        # Handle ambiguous input
        if ($capacityId -and $capacityName) {
            Write-Message -Message "Both 'capacityId' and 'capacityName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointURI = "capacities"

        # Invoke the Fabric API to retrieve capacity details
        $apiParams = @{
            Uri    = $apiEndpointURI
            Method = 'Get'
        }
        $capacities = (Invoke-FabricRestMethod @apiParams).Value

        # Filter results based on provided parameters
        $response = if ($capacityId) {
            $capacities | Where-Object { $_.Id -eq $capacityId }
        } elseif ($capacityName) {
            $capacities | Where-Object { $_.DisplayName -eq $capacityName }
        } else {
            # No filter, return all capacities
            Write-Message -Message "No filter specified. Returning all capacities." -Level Debug
            return $capacities
        }

        # Handle results
        if ($response) {
            Write-Message -Message "Capacity found matching the specified criteria." -Level Debug
            return $response
        } else {
            Write-Message -Message "No capacity found matching the specified criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve capacity. Error: $errorDetails" -Level Error
        return $null
    }
}
