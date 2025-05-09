<#
.SYNOPSIS
Retrieves the definition of a Copy Job from a specific workspace in Microsoft Fabric.

.DESCRIPTION
This function fetches the Copy Job's content or metadata from a workspace. 
It supports both synchronous and asynchronous operations, with detailed logging and error handling.

.PARAMETER WorkspaceId
(Mandatory) The unique identifier of the workspace from which the Copy Job definition is to be retrieved.

.PARAMETER CopyJobId
(Mandatory) The unique identifier of the Copy Job whose definition needs to be retrieved.

.PARAMETER CopyJobFormat
(Optional) Specifies the format of the Copy Job definition. For example, 'json' or 'xml'.

.EXAMPLE
Get-FabricCopyJobDefinition -WorkspaceId "12345" -CopyJobId "67890"

Retrieves the definition of the Copy Job with ID `67890` from the workspace with ID `12345`.

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Test-TokenExpired` to ensure token validity before making the API request.
- Handles long-running operations asynchronously.
- Logs detailed information for debugging purposes.

#>
function Get-FabricCopyJobDefinition {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CopyJobId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$CopyJobFormat
    )

    try {
        # Step 1: Validate authentication token before proceeding.
        Write-Message -Message "Validating authentication token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Authentication token is valid." -Level Debug

        # Step 2: Construct the API endpoint URL for retrieving the Copy Job definition.
        $apiEndpointUrl = "{0}/workspaces/{1}/copyJobs/{2}/getDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $CopyJobId

        # Step 3: Append the format query parameter if specified by the user.
        if ($CopyJobFormat) {
            $apiEndpointUrl = "{0}?format={1}" -f $apiEndpointUrl, $CopyJobFormat
        }
        Write-Message -Message "Constructed API Endpoint URL: $apiEndpointUrl" -Level Debug

        # Step 4: Execute the API request to retrieve the Copy Job definition.
        $response = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointUrl `
            -Headers $FabricConfig.FabricHeaders `
            -Method Post 

        # Step 5: Return the API response containing the Copy Job definition.
        return $response
    }
    catch {
        # Step 6: Capture and log detailed error information for troubleshooting.
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Copy Job definition. Error: $errorDetails" -Level Error
    } 
}
