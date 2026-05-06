function New-FabricMLModel
{
<#
.SYNOPSIS
    Creates a new ML Model in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a POST request to the Microsoft Fabric API to create a new ML Model
    in the specified workspace. It supports optional parameters for ML Model description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the ML Model will be created. This parameter is mandatory.

.PARAMETER MLModelName
    The name of the ML Model to be created. This parameter is mandatory.

.PARAMETER MLModelDescription
    An optional description for the ML Model.

.EXAMPLE
    This example creates a new ML Model named "New ML Model" in the workspace with ID "workspace-12345" with the provided description.

    ```powershell
    New-FabricMLModel -WorkspaceId "workspace-12345" -MLModelName "New ML Model" -MLModelDescription "Description of the new ML Model"
    ```

.NOTES
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$MLModelName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MLModelDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/mlModels"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $MLModelName
        }

        if ($MLModelDescription)
        {
            $body.description = $MLModelDescription
        }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($MLModelName, "Create ML Model")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "ML Model '$MLModelName' created successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create ML Model. Error: $errorDetails" -Level Error
    }
}
