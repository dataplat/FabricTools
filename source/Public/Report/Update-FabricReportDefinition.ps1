<#
.SYNOPSIS
    Updates the definition of an existing Report in a specified Microsoft Fabric workspace.

.DESCRIPTION
    This function sends a PATCH request to the Microsoft Fabric API to update the definition of an existing Report
    in the specified workspace. It supports optional parameters for Report definition and platform-specific definition.

.PARAMETER WorkspaceId
    The unique identifier of the workspace where the Report exists. This parameter is mandatory.

.PARAMETER ReportId
    The unique identifier of the Report to be updated. This parameter is mandatory.

.PARAMETER ReportPathDefinition
    A mandatory path to the Report definition file to upload.

.EXAMPLE
    This example updates the definition of the Report with ID "Report-67890" in the workspace with ID "workspace-12345" using the provided definition file.

    ```powershell
    Update-FabricReportDefinition -WorkspaceId "workspace-12345" -ReportId "Report-67890" -ReportPathDefinition "C:\Path\To\ReportDefinition.json"
    ```

.NOTES
    - Requires `$FabricConfig` global configuration, including `BaseUrl` and `FabricHeaders`.
    - Calls `Confirm-TokenState` to ensure token validity before making the API request.

    Author: Tiago Balabuch

#>
function Update-FabricReportDefinition
{
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$ReportId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ReportPathDefinition
    )
    try
    {
        # Step 1: Ensure token validity
        Confirm-TokenState

        # Step 2: Construct the API URL
        $apiEndpointUrl = "{0}/workspaces/{1}/Reports/{2}/updateDefinition" -f $FabricConfig.BaseUrl, $WorkspaceId, $ReportId

        #if ($UpdateMetadata -eq $true) {


        # Step 3: Construct the request body
        $body = @{
            definition = @{
                parts = @()
            }
        }

        if ($ReportPathDefinition)
        {
            if (-not $body.definition)
            {
                $body.definition = @{
                    parts = @()
                }
            }
            $jsonObjectParts = Get-FileDefinitionParts -sourceDirectory $ReportPathDefinition
            # Add new part to the parts array
            $body.definition.parts = $jsonObjectParts.parts
        }
        # Check if any path is .platform
        foreach ($part in $jsonObjectParts.parts)
        {
            if ($part.path -eq ".platform")
            {
                $hasPlatformFile = $true
                Write-Message -Message "Platform File: $hasPlatformFile" -Level Debug
            }
        }

        if ($hasPlatformFile -eq $true)
        {
            $apiEndpointUrl += "?updateMetadata=true" -f $apiEndpointUrl
        }
        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug


        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update Report Definition"))
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
            200
            {
                Write-Message -Message "Update definition for Report '$ReportId' created successfully!" -Level Info
                return $response
            }
            202
            {
                Write-Message -Message "Update definition for Report '$ReportId' accepted. Operation in progress!" -Level Info

                [string]$operationId = $responseHeader["x-ms-operation-id"]
                [string]$location = $responseHeader["Location"]
                [string]$retryAfter = $responseHeader["Retry-After"]

                Write-Message -Message "Operation ID: '$operationId'" -Level Debug
                Write-Message -Message "Location: '$location'" -Level Debug
                Write-Message -Message "Retry-After: '$retryAfter'" -Level Debug
                Write-Message -Message "Getting Long Running Operation status" -Level Debug

                $operationStatus = Get-FabricLongRunningOperation -operationId $operationId -location $location
                Write-Message -Message "Long Running Operation status: $operationStatus" -Level Debug
                # Handle operation result
                if ($operationStatus.status -eq "Succeeded")
                {
                    Write-Message -Message "Operation Succeeded" -Level Debug
                    Write-Message -Message "Update definition operation for Report '$ReportId' succeeded!" -Level Info
                    return $operationStatus
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
        Write-Message -Message "Failed to update Report. Error: $errorDetails" -Level Error
    }
}
