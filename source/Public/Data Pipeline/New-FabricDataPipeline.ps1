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
     New-FabricDataPipeline -WorkspaceId "workspace-12345" -DataPipelineName "New DataPipeline" 
    This example creates a new DataPipeline named "New DataPipeline" in the workspace with ID "workspace-12345" and uploads the definition file from the specified path.

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Test-TokenExpired` to ensure token validity before making the API request.

    Author: Tiago Balabuch
#>

function New-FabricDataPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^[a-zA-Z0-9_ ]*$')]
        [string]$DataPipelineName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DataPipelineDescription
    )

    try {
        # Step 1: Ensure token validity
        Write-Message -Message "Validating token..." -Level Debug
        Test-TokenExpired
        Write-Message -Message "Token validation completed." -Level Debug

        # Step 2: Construct the API URL
        $apiEndpointURI = "{0}/workspaces/{1}/dataPipelines" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointURI" -Level Debug

        # Step 3: Construct the request body
        $body = @{
            displayName = $DataPipelineName
        }

        if ($DataPipelineDescription) {
            $body.description = $DataPipelineDescription
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Step 4: Make the API request
        $response = Invoke-FabricAPIRequest `
            -BaseURI $apiEndpointURI `
            -Headers $FabricConfig.FabricHeaders `
            -Method Post `
            -Body $bodyJson
    
        Write-Message -Message "Data Pipeline created successfully!" -Level Info        
        return $response
    }
    catch {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create DataPipeline. Error: $errorDetails" -Level Error
    }
}
