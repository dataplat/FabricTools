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
Add-FabricLakehouse -WorkspaceId "workspace-12345" -LakehouseName "New Lakehouse" -LakehouseEnableSchemas $true

.NOTES
- Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
- Calls `Confirm-TokenState` to ensure token validity before making the API request.

Author: Tiago Balabuch

#>

function New-FabricLakehouse
{
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
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/lakehouses" -f $FabricConfig.BaseUrl, $WorkspaceId
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Step 3: Construct the request body
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
            # Step 4: Make the API request
            $response = Invoke-FabricRestMethod `
                -Uri $apiEndpointUrl `
                -Method Post `
                -Body $bodyJson
        }
        # Step 5: Handle and log the response
        switch ($statusCode)
        {
            201
            {
                Write-Message -Message "Lakehouse '$LakehouseName' created successfully!" -Level Info
                return $response
            }
            202
            {
                Write-Message -Message "Lakehouse '$LakehouseName' creation accepted. Provisioning in progress!" -Level Info

                [string]$operationId = $responseHeader["x-ms-operation-id"]
                Write-Message -Message "Operation ID: '$operationId'" -Level Debug
                Write-Message -Message "Getting Long Running Operation status" -Level Debug

                $operationStatus = Get-FabricLongRunningOperation -operationId $operationId
                Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
                # Handle operation result
                if ($operationStatus.status -eq "Succeeded")
                {
                    Write-Message -Message "Operation Succeeded" -Level Debug
                    Write-Message -Message "Getting Long Running Operation result" -Level Debug

                    $operationResult = Get-FabricLongRunningOperationResult -operationId $operationId
                    Write-Message -Message "Long Running Operation status: $operationResult" -Level Debug

                    return $operationResult
                }
                else
                {
                    Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Debug
                    Write-Message -Message "Operation failed. Status: $($operationStatus)" -Level Error
                    return $operationStatus
                }
            }
            default
            {
                Write-Message -Message "Unexpected response code: $statusCode" -Level Error
                Write-Message -Message "Error details: $($response.message)" -Level Error
                throw "API request failed with status code $statusCode."
            }
        }
    }
    catch
    {
        # Step 6: Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to create Lakehouse. Error: $errorDetails" -Level Error
    }
}
