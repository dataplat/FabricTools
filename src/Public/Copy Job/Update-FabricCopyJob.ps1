function Update-FabricCopyJob
{
<#
.SYNOPSIS
    Updates an existing Copy Job in a specified Microsoft Fabric workspace.

.DESCRIPTION
    Sends a PATCH request to the Microsoft Fabric API to update an existing Copy Job
    in the specified workspace. Allows updating the Copy Job's name and optionally its description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace containing the Copy Job. This parameter is mandatory.

.PARAMETER CopyJobId
    The unique identifier of the Copy Job to be updated. This parameter is mandatory.

.PARAMETER CopyJobName
    The new name for the Copy Job. This parameter is mandatory.

.PARAMETER CopyJobDescription
    An optional new description for the Copy Job.

.EXAMPLE
    Updates the Copy Job with ID "copyjob-67890" in the workspace "workspace-12345" with a new name and description.

    ```powershell
    Update-FabricCopyJob -WorkspaceId "workspace-12345" -CopyJobId "copyjob-67890" -CopyJobName "Updated Copy Job" -CopyJobDescription "Updated description"
    ```

.NOTES
    - Ensures token validity by calling `Confirm-TokenState` before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$CopyJobId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CopyJobName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$CopyJobDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URI
        $apiEndpointUrl = "workspaces/{0}/copyJobs/{1}" -f $WorkspaceId, $CopyJobId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $CopyJobName
        }

        if ($CopyJobDescription)
        {
            $body.description = $CopyJobDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($CopyJobName, "Update Copy Job"))
        {
            $apiParams = @{
                Uri            = "workspaces/$WorkspaceId/copyJobs/$CopyJobId"
                Method         = 'Patch'
                Body           = $bodyJson
                TypeName       = 'CopyJob'
                ObjectIdOrName = $CopyJobName
                HandleResponse = $true
            }

            $response = Invoke-FabricRestMethod @apiParams
        }

        Write-Message -Message "Copy Job '$CopyJobName' updated successfully!" -Level Info
        $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Copy Job. Error: $errorDetails" -Level Error
    }
}
