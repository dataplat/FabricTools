function Get-FabricReflex {
<#
.SYNOPSIS
    Retrieves Reflex details from a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function retrieves Reflex details from a specified workspace using either the provided ReflexId or ReflexName.
    It handles token validation, constructs the API URL, makes the API request, and processes the response.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Reflex exists. This parameter is mandatory.

.PARAMETER ReflexId
    The unique identifier of the Reflex to retrieve. This parameter is optional.

.PARAMETER ReflexName
    The name of the Reflex to retrieve. This parameter is optional.

.EXAMPLE
    This example retrieves the Reflex details for the Reflex with ID "Reflex-67890" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReflex -WorkspaceId "workspace-12345" -ReflexId "Reflex-67890"
    ```

.EXAMPLE
    This example retrieves the Reflex details for the Reflex named "My Reflex" in the workspace with ID "workspace-12345".

    ```powershell
    Get-FabricReflex -WorkspaceId "workspace-12345" -ReflexName "My Reflex"
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
        [guid]$ReflexId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$ReflexName
    )
    try {

        # Handle ambiguous input
        if ($ReflexId -and $ReflexName) {
            Write-Message -Message "Both 'ReflexId' and 'ReflexName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Initialize variables
        $continuationToken = $null
        $Reflexes = @()

        if (-not ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GetName().Name -eq "System.Web" })) {
            Add-Type -AssemblyName System.Web
        }

        # Loop to retrieve all capacities with continuation token
        Write-Message -Message "Loop started to get continuation token" -Level Debug
        $baseApiEndpointUrl = "{0}/workspaces/{1}/reflexes" -f $FabricConfig.BaseUrl, $WorkspaceId
        #  Loop to retrieve data with continuation token
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
                $Reflexes += $response.value

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
        $Reflex = if ($ReflexId) {
            $Reflexes | Where-Object { $_.Id -eq $ReflexId }
        } elseif ($ReflexName) {
            $Reflexes | Where-Object { $_.DisplayName -eq $ReflexName }
        } else {
            # Return all Reflexes if no filter is provided
            Write-Message -Message "No filter provided. Returning all Reflexes." -Level Debug
            $Reflexes
        }

        # Handle results
        if ($Reflex) {
            Write-Message -Message "Reflex found in the Workspace '$WorkspaceId'." -Level Debug
            return $Reflex
        } else {
            Write-Message -Message "No Reflex found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Reflex. Error: $errorDetails" -Level Error
    }

}
