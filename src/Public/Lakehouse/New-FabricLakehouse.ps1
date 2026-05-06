function New-FabricLakehouse
{
<#
.SYNOPSIS
Creates a new Lakehouse in a specified Microsoft Fabric workspace.

.DESCRIPTION
This function sends a POST request to the Microsoft Fabric API to create a new Lakehouse
in the specified workspace. It supports optional parameters for Lakehouse description
and path definitions for the Lakehouse content.

.PARAMETER WorkspaceId
The unique identifier of the workspace where the Lakehouse will be created.

.PARAMETER LakehouseName
The name of the Lakehouse to be created.

.PARAMETER LakehouseDescription
An optional description for the Lakehouse.

.PARAMETER LakehouseEnableSchemas
An optional path to enable schemas in the Lakehouse

.EXAMPLE
    Creates a new Lakehouse in the specified workspace with a given name and enable schemas option.

    ```powershell
    New-FabricLakehouse -WorkspaceId "workspace-12345" -LakehouseName "New Lakehouse" -LakehouseEnableSchemas $true
    ```

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
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
        [string]$LakehouseName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$LakehouseDescription,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [bool]$LakehouseEnableSchemas = $false
    )

    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/lakehouses" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $LakehouseName
        }

        if ($LakehouseDescription)
        {
            $body.description = $LakehouseDescription
        }

        if ($true -eq $LakehouseEnableSchemas)
        {
            $body.creationPayload = @{
                enableSchemas = $LakehouseEnableSchemas
            }
        }
        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug
        if ($PSCmdlet.ShouldProcess($LakehouseName, "Create Lakehouse"))
        {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                TypeName       = 'Lakehouse'
                ObjectIdOrName = $LakehouseName
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create Lakehouse. Error: $errorDetails" -Level Error
    }
}
