function Get-FabricSparkSettings {
    <#
    .SYNOPSIS
        Retrieves Spark settings from a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function retrieves Spark settings from a specified workspace using the provided WorkspaceId.
        It handles token validation, constructs the API URL, makes the API request, and processes the response.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace from which to retrieve Spark settings. This parameter is mandatory.

    .EXAMPLE
        This example retrieves the Spark settings for the workspace with ID "workspace-12345".

        ```powershell
        Get-FabricSparkSettings -WorkspaceId "workspace-12345"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId
    )

    try {

        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/{0}/spark/settings" -f $WorkspaceId

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            HandleResponse = $true
            TypeName       = 'SparkSettings'
        }
        $SparkSettings = Invoke-FabricRestMethod @apiParams

        # Handle results
        if ($SparkSettings) {
            Write-Message -Message "Returning all Spark Settings." -Level Debug
            return $SparkSettings
        } else {
            Write-Message -Message "No SparkSettings found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve SparkSettings. Error: $errorDetails" -Level Error
    }

}
