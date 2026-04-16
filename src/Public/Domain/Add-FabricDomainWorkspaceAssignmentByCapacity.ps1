function Add-FabricDomainWorkspaceAssignmentByCapacity {
<#
.SYNOPSIS
Assigns workspaces to a Fabric domain based on specified capacities.

.DESCRIPTION
The `Add-FabricDomainWorkspaceAssignmentByCapacity` function assigns workspaces to a Fabric domain using a list of capacity IDs by making a POST request to the relevant API endpoint.

.PARAMETER DomainId
The unique identifier of the Fabric domain to which the workspaces will be assigned.

.PARAMETER CapacitiesIds
An array of capacity IDs used to assign workspaces to the domain.

.EXAMPLE
    Assigns workspaces to the domain with ID "12345" based on the specified capacities.

    ```powershell
    Add-FabricDomainWorkspaceAssignmentByCapacity -DomainId "12345" -CapacitiesIds @("capacity1", "capacity2")
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding()]
    [Alias("Assign-FabricDomainWorkspaceByCapacity")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid[]]$CapacitiesIds
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "admin/domains/{0}/assignWorkspacesByCapacities" -f $DomainId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            capacitiesIds = $CapacitiesIds
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json -Depth 2
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        # Make the API request
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            Body           = $bodyJson
            TypeName       = 'Domain'
            ObjectIdOrName = $DomainId
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Assigning domain workspaces by capacity completed successfully!" -Level Info
        return $response
    } catch {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Error occurred while assigning workspaces by capacity for domain '$DomainId'. Details: $errorDetails" -Level Error
    }
}
