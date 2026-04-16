function Get-FabricEventstream {


    <#
.SYNOPSIS
Retrieves an Eventstream or a list of Eventstreams from a specified workspace in Microsoft Fabric.

.DESCRIPTION
    Retrieves Fabric Eventstreams. Without the EventstreamName or EventstreamID parameter, all Eventstreams are returned.
    If you want to retrieve a specific Eventstream, you can use the EventstreamName or EventstreamID parameter. These
    parameters cannot be used together.

.PARAMETER WorkspaceId
(Mandatory) The ID of the workspace to query Eventstreams.

.PARAMETER EventstreamName
(Optional) The name of the specific Eventstream to retrieve.

.PARAMETER EventstreamId
    The Id of the Eventstream to retrieve. This parameter cannot be used together with EventstreamName. The value for EventstreamId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.EXAMPLE
    Retrieves the "Development" Eventstream from workspace "12345".

    ```powershell
    Get-FabricEventstream -WorkspaceId "12345" -EventstreamName "Development"
    ```

.EXAMPLE
    Retrieves all Eventstreams in workspace "12345".

    ```powershell
    Get-FabricEventstream -WorkspaceId "12345"
    ```

.NOTES
Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$EventstreamId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventstreamName
    )

    try {
        # Handle ambiguous input
        if ($EventstreamId -and $EventstreamName) {
            Write-Message -Message "Both 'EventstreamId' and 'EventstreamName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/eventstreams"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve Eventstreams
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $eventstreams = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $eventstream = if ($EventstreamId) {
            $eventstreams | Where-Object { $_.Id -eq $EventstreamId }
        } elseif ($EventstreamName) {
            $eventstreams | Where-Object { $_.DisplayName -eq $EventstreamName }
        } else {
            # Return all eventstreams if no filter is provided
            Write-Message -Message "No filter provided. Returning all Eventstreams." -Level Debug
            $eventstreams
        }

        # Handle results
        if ($eventstream) {
            Write-Message -Message "Eventstream found matching the specified criteria." -Level Debug
            return $eventstream
        } else {
            Write-Message -Message "No Eventstream found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Eventstream. Error: $errorDetails" -Level Error
    }

}
