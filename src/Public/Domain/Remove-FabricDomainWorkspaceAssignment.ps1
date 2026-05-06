function Remove-FabricDomainWorkspaceAssignment
{
<#
.SYNOPSIS
Unassign workspaces from a specified Fabric domain.

.DESCRIPTION
The `Unassign -FabricDomainWorkspace` function allows you to Unassign  specific workspaces from a given Fabric domain or unassign all workspaces if no workspace IDs are specified.
It makes a POST request to the relevant API endpoint for this operation.

.PARAMETER DomainId
The unique identifier of the Fabric domain.

.PARAMETER WorkspaceIds
(Optional) An array of workspace IDs to unassign. If not provided, all workspaces will be unassigned.

.EXAMPLE
    Unassigns all workspaces from the domain with ID "12345".

    ```powershell
    Remove-FabricDomainWorkspaceAssignment -DomainId "12345"
    ```

.EXAMPLE
    Unassigns the specified workspaces from the domain with ID "12345".

    ```powershell
    Remove-FabricDomainWorkspaceAssignment -DomainId "12345" -WorkspaceIds @("workspace1", "workspace2")
    ```

.NOTES
- Calls `Confirm-TokenState` to ensure token validity before making the API request.


Author: Tiago Balabuch, Kamil Nowinski

#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [Alias("Unassign-FabricDomainWorkspace")]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DomainId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid[]]$WorkspaceIds
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Determine the API endpoint URL based on the presence of WorkspaceIds
        $endpointSuffix = if ($WorkspaceIds)
        {
            "unassignWorkspaces"
        }
        else
        {
            "unassignAllWorkspaces"
        }

        $apiEndpointUrl = "admin/domains/{0}/{1}" -f $DomainId, $endpointSuffix
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body (if needed)
        $bodyJson = if ($WorkspaceIds)
        {
            $body = @{ workspacesIds = $WorkspaceIds }
            $body | ConvertTo-Json -Depth 2
        }
        else
        {
            $null
        }

        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($DomainId, "Unassign Workspaces"))
        {
            # Make the API request to unassign specific workspaces
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Domain'
                ObjectIdOrName = $DomainId
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
        }

        Write-Message -Message "Successfully unassigned workspaces to the domain with ID '$DomainId'." -Level Info
    }
    catch
    {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to unassign workspaces to the domain with ID '$DomainId'. Error: $errorDetails" -Level Error
    }
}
