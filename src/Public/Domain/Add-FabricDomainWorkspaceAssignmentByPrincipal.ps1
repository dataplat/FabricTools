function Add-FabricDomainWorkspaceAssignmentByPrincipal {
<#
.SYNOPSIS
Assigns workspaces to a domain based on principal IDs in Microsoft Fabric.

.DESCRIPTION
The `Add-FabricDomainWorkspaceAssignmentByPrincipal` function sends a request to assign workspaces to a specified domain using a JSON object of principal IDs and types.

.PARAMETER DomainId
The ID of the domain to which workspaces will be assigned. This parameter is mandatory.

.PARAMETER PrincipalIds
An array representing the principals with their `id` and `type` properties. Must contain a `principals` key with an array of objects.

.EXAMPLE
    This example assigns workspaces to a domain using a list of principal IDs and types.

    ```powershell
    $PrincipalIds = @(
        @{id = "813abb4a-414c-4ac0-9c2c-bd17036fd58c";  type = "User"},
        @{id = "b5b9495c-685a-447a-b4d3-2d8e963e6288"; type = "User"}
    )

    Add-FabricDomainWorkspaceAssignmentByPrincipal -DomainId "12345" -PrincipalIds $PrincipalIds
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch, Kamil Nowinski
#>
    [CmdletBinding()]
    [Alias("Assign-FabricDomainWorkspaceByPrincipal")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        #[hashtable]$PrincipalIds # Must contain a JSON array of principals with 'id' and 'type' properties
        [System.Object]$PrincipalIds
    )

    try {
        # Ensure each principal contains 'id' and 'type'
        foreach ($principal in $PrincipalIds) {
            if (-not ($principal.ContainsKey('id') -and $principal.ContainsKey('type'))) {
                throw "Each principal object must contain 'id' and 'type' properties."
            }
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "admin/domains/{0}/assignWorkspacesByPrincipals" -f $DomainId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Message

        # Construct the request body
        $body = @{
            principals = $PrincipalIds
        }

        # Convert the PrincipalIds to JSON
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
        Write-Message -Message "Assigning domain workspaces by principal completed successfully!" -Level Info
        return $response
    } catch {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to assign domain workspaces by principals. Error: $errorDetails" -Level Error
    }
}
