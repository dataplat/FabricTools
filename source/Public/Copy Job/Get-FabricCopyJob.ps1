function Get-FabricCopyJob {
    <#
.SYNOPSIS
    Retrieves CopyJob details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves CopyJob details from a specified workspace using either the provided CopyJobId or CopyJob.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the CopyJob exists. This parameter is mandatory.

.PARAMETER CopyJobId
    The unique identifier of the CopyJob to retrieve. This parameter is optional.

.PARAMETER CopyJob
    The name of the CopyJob to retrieve. This parameter is optional.

.EXAMPLE
    FabricCopyJob -WorkspaceId "workspace-12345" -CopyJobId "CopyJob-67890"
    This example retrieves the CopyJob details for the CopyJob with ID "CopyJob-67890" in the workspace with ID "workspace-12345".

.EXAMPLE
    FabricCopyJob -WorkspaceId "workspace-12345" -CopyJob "My CopyJob"
    This example retrieves the CopyJob details for the CopyJob named "My CopyJob" in the workspace with ID "workspace-12345".

.NOTES
    Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$CopyJobId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$CopyJob
    )

    try {
        # Handle ambiguous input
        if ($CopyJobId -and $CopyJob) {
            Write-Message -Message "Both 'CopyJobId' and 'CopyJob' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Test-TokenExpired


        # Construct the API endpoint URL
        $apiEndpointURI = "workspaces/{0}/copyJobs" -f $WorkspaceId

        # Invoke the Fabric API to retrieve capacity details
        $apiParams = @{
            Uri    = $apiEndpointURI
            Method = 'Get'
        }
        $copyJobs = Invoke-FabricRestMethod @apiParams

        #  Filter results based on provided parameters
        $response = if ($CopyJobId) {
            $copyJobs | Where-Object { $_.Id -eq $CopyJobId }
        } elseif ($CopyJob) {
            $copyJobs | Where-Object { $_.DisplayName -eq $CopyJob }
        } else {
            # Return all CopyJobs if no filter is provided
            Write-Message -Message "No filter provided. Returning all CopyJobs." -Level Debug
            $copyJobs
        }

        # Step 9: Handle results
        if ($response) {
            Write-Message -Message "CopyJob found matching the specified criteria." -Level Debug
            return $response
        } else {
            Write-Message -Message "No CopyJob found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Step 10: Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve CopyJob. Error: $errorDetails" -Level Error
    }

}
