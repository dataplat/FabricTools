function Update-FabricSparkJobDefinition
{
    <#
    .SYNOPSIS
        Updates an existing SparkJobDefinition in a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a PATCH request to the Microsoft Fabric API to update an existing SparkJobDefinition
        in the specified workspace. It supports optional parameters for SparkJobDefinition description.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SparkJobDefinition exists. This parameter is optional.

    .PARAMETER SparkJobDefinitionId
        The unique identifier of the SparkJobDefinition to be updated. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionName
        The new name of the SparkJobDefinition. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionDescription
        An optional new description for the SparkJobDefinition.

    .EXAMPLE
        This example updates the SparkJobDefinition with ID "SparkJobDefinition-67890" in the workspace with ID "workspace-12345" with a new name and description.

        ```powershell
        Update-FabricSparkJobDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionId "SparkJobDefinition-67890" -SparkJobDefinitionName "Updated SparkJobDefinition" -SparkJobDefinitionDescription "Updated description"
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
        [guid]$SparkJobDefinitionId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$SparkJobDefinitionName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SparkJobDefinitionDescription
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/sparkJobDefinitions/$SparkJobDefinitionId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Construct the request body
        $body = @{
            displayName = $SparkJobDefinitionName
        }

        if ($SparkJobDefinitionDescription)
        {
            $body.description = $SparkJobDefinitionDescription
        }

        # Convert the body to JSON
        $bodyJson = $body | ConvertTo-Json
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Update SparkJobDefinition")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Patch'
                Body           = $bodyJson
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Spark Job Definition '$SparkJobDefinitionName' updated successfully!" -Level Info
            return $response
        }
    }
    catch
    {
        # Handle and log errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to update SparkJobDefinition. Error: $errorDetails" -Level Error
    }
}
