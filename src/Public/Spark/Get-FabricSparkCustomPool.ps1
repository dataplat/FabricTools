function Get-FabricSparkCustomPool {
    <#
    .SYNOPSIS
        Retrieves Spark custom pools from a specified workspace.

    .DESCRIPTION
        This function retrieves all Spark custom pools from a specified workspace using the provided WorkspaceId.
        It handles token validation, constructs the API URL, makes the API request, and processes the response.
        The function supports filtering by SparkCustomPoolId or SparkCustomPoolName, but not both simultaneously.

    .PARAMETER WorkspaceId
        The ID of the workspace from which to retrieve Spark custom pools. This parameter is mandatory.

    .PARAMETER SparkCustomPoolId
        The ID of the specific Spark custom pool to retrieve. This parameter is optional.

    .PARAMETER SparkCustomPoolName
        The name of the specific Spark custom pool to retrieve. This parameter is optional.

    .EXAMPLE
        This example retrieves all Spark custom pools from the workspace with ID "12345".

        ```powershell
        Get-FabricSparkCustomPool -WorkspaceId "12345"
        ```

    .EXAMPLE
        This example retrieves the Spark custom pool with ID "pool1" from the workspace with ID "12345".

        ```powershell
        Get-FabricSparkCustomPool -WorkspaceId "12345" -SparkCustomPoolId "pool1"
        ```

    .EXAMPLE
        This example retrieves the Spark custom pool with name "MyPool" from the workspace with ID "12345".

        ```powershell
        Get-FabricSparkCustomPool -WorkspaceId "12345" -SparkCustomPoolName "MyPool"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.
        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$SparkCustomPoolId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SparkCustomPoolName
    )

    try {
        # Handle ambiguous input
        if ($SparkCustomPoolId -and $SparkCustomPoolName) {
            Write-Message -Message "Both 'SparkCustomPoolId' and 'SparkCustomPoolName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/spark/pools" -f $WorkspaceId

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            HandleResponse = $true
            ExtractValue   = 'True'
            TypeName       = 'SparkCustomPool'
        }
        $SparkCustomPools = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $SparkCustomPool = if ($SparkCustomPoolId) {
            $SparkCustomPools | Where-Object { $_.id -eq $SparkCustomPoolId }
        } elseif ($SparkCustomPoolName) {
            $SparkCustomPools | Where-Object { $_.name -eq $SparkCustomPoolName }
        } else {
            # Return all SparkCustomPools if no filter is provided
            Write-Message -Message "No filter provided. Returning all SparkCustomPools." -Level Debug
            $SparkCustomPools
        }

        # Handle results
        if ($SparkCustomPool) {
            Write-Message -Message "SparkCustomPool found matching the specified criteria." -Level Debug
            return $SparkCustomPool
        } else {
            Write-Message -Message "No SparkCustomPool found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve SparkCustomPool. Error: $errorDetails" -Level Error
    }

}
