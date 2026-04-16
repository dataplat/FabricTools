function Update-FabricEventhouse
{
<#
.SYNOPSIS
    Updates an existing Eventhouse in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update an existing Eventhouse
    in the specified workspace. It supports optional parameters for Eventhouse description.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Eventhouse exists. This parameter is optional.

.PARAMETER EventhouseId
    The unique identifier of the Eventhouse to be updated. This parameter is mandatory.

.PARAMETER EventhouseName
    The new name of the Eventhouse. This parameter is mandatory.

.PARAMETER EventhouseDescription
    An optional new description for the Eventhouse.

.EXAMPLE
    This example updates the Eventhouse with ID "eventhouse-67890" in the workspace with ID "workspace-12345" with a new name and description.

    ```powershell
    Update-FabricEventhouse -WorkspaceId "workspace-12345" -EventhouseId "eventhouse-67890" -EventhouseName "Updated Eventhouse" -EventhouseDescription "Updated description"
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
        [guid]$EventhouseId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhouseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$EventhouseDescription
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/eventhouses/$EventhouseId"
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $EventhouseName
        }

        if ($EventhouseDescription)
        {
            $body.description = $EventhouseDescription
        }

        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($EventhouseName, "Update Eventhouse"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                TypeName       = 'Eventhouse'
                ObjectIdOrName = $EventhouseName
                HandleResponse = $true
            }

            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Eventhouse '$EventhouseName' updated successfully!" -Level Info
        }
        return $response
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update Eventhouse. Error: $errorDetails" -Level Error
    }
}
