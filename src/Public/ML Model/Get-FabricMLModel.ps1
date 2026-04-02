function Get-FabricMLModel {
<#
.SYNOPSIS
    Retrieves ML Model details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves ML Model details from a specified workspace using either the provided MLModelId or MLModelName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the ML Model exists. This parameter is mandatory.

.PARAMETER MLModelId
    The unique identifier of the ML Model to retrieve. This parameter is optional.

.PARAMETER MLModelName
    The name of the ML Model to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the ML Model details for the model with ID "model-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricMLModel -WorkspaceId "workspace-12345" -MLModelId "model-67890"
    ```

.EXAMPLE
    This example retrieves the ML Model details for the model named "My ML Model" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricMLModel -WorkspaceId "workspace-12345" -MLModelName "My ML Model"
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
        [guid]$MLModelId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$MLModelName
    )

    try {
        # Handle ambiguous input
        if ($MLModelId -and $MLModelName) {
            Write-Message -Message "Both 'MLModelId' and 'MLModelName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState
        # Initialize variables
        $continuationToken = $null
        $MLModels = @()

        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
            Add-Type -AssemblyName System.Web
        }

        # Loop to retrieve all capacities with continuation token
        Write-Message -Message "Loop started to get continuation token" -Level Debug
        $baseApiEndpointUrl = "{0}/workspaces/{1}/mlModels" -f $FabricConfig.BaseUrl, $WorkspaceId


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
                $MLModels += $response.value

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
        $MLModel = if ($MLModelId) {
            $MLModels | Where-Object { $_.Id -eq $MLModelId }
        } elseif ($MLModelName) {
            $MLModels | Where-Object { $_.DisplayName -eq $MLModelName }
        } else {
            # Return all MLModels if no filter is provided
            Write-Message -Message "No filter provided. Returning all MLModels." -Level Debug
            $MLModels
        }

        # Handle results
        if ($MLModel) {
            Write-Message -Message "ML Model found matching the specified criteria." -Level Debug
            return $MLModel
        } else {
            Write-Message -Message "No ML Model found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve ML Model. Error: $errorDetails" -Level Error
    }

}
