function Remove-FabricSparkJobDefinition
{
    <#
    .SYNOPSIS
        Removes an SparkJobDefinition from a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function sends a DELETE request to the Microsoft Fabric API to remove an SparkJobDefinition
        from the specified workspace using the provided WorkspaceId and SparkJobDefinitionId.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace from which the SparkJobDefinition will be removed.

    .PARAMETER SparkJobDefinitionId
        The unique identifier of the SparkJobDefinition to be removed.

    .EXAMPLE
        This example removes the SparkJobDefinition with ID "SparkJobDefinition-67890" from the workspace with ID "workspace-12345".

        ```powershell
        Remove-FabricSparkJobDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionId "SparkJobDefinition-67890"
        ```

    .NOTES
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.

        Author: Tiago Balabuch, Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$SparkJobDefinitionId
    )
    try
    {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/sparkJobDefinitions/$SparkJobDefinitionId"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        if ($PSCmdlet.ShouldProcess($apiEndpointUrl, "Remove SparkJobDefinition")) {
            # Invoke Fabric API request
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Delete'
                HandleResponse = $true
            }
            $response = Invoke-FabricRestMethod @apiParams
            Write-Message -Message "Spark Job Definition '$SparkJobDefinitionId' deleted successfully from workspace '$WorkspaceId'." -Level Info
        }
    }
    catch
    {
        # Log and handle errors
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to delete SparkJobDefinition '$SparkJobDefinitionId'. Error: $errorDetails" -Level Error
    }
}
