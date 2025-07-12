<#
.SYNOPSIS
    Creates a new DataPipeline in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to create a new DataPipeline
    in the specified workspace. It supports optional parameters for DataPipeline description
    and path definitions for the DataPipeline content.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the DataPipeline will be created.

.PARAMETER DataPipelineName
    The name of the DataPipeline to be created.

.PARAMETER DataPipelineDescription
    An optional description for the DataPipeline.

.EXAMPLE
    This example creates a new DataPipeline named "New DataPipeline" in the workspace with ID "workspace-12345" and uploads the definition file from the specified path.

    ```powershell
    New-FabricDataPipeline -WorkspaceId "workspace-12345" -DataPipelineName "New DataPipeline"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>

function New-FabricDataPipeline
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineDescription
    )

    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointURI = ("workspaces/{0}/dataPipelines" -f $WorkspaceId)
        Write-Message -Message "API Endpoint: $apiEndpointURI" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $DataPipelineName
        }

        if ($DataPipelineDescription)
        {
            $body.description = $DataPipelineDescription
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10

        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointURI, "Create DataPipeline"))
        {
            # Step 4: Make the API request
            $apiParams = @{
                Uri    = $apiEndpointURI
                method = 'Post'
                body   = $bodyJson
            }
            $response = Invoke-FabricRestMethod @apiParams
        }
        Write-Message -Message "Data Pipeline created successfully!" -Level Info
        return $response
    }
    catch
    {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create DataPipeline. Error: $errorDetails" -Level Error
    }
}
