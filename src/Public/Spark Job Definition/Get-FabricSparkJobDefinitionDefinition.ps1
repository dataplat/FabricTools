function Get-FabricSparkJobDefinitionDefinition {
    <#
    .SYNOPSIS
        Retrieves the definition of an SparkJobDefinition from a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function retrieves the definition of an SparkJobDefinition from a specified workspace using the provided SparkJobDefinitionId.
        It handles token validation, constructs the API URL, makes the API request, and processes the response.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SparkJobDefinition exists. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionId
        The unique identifier of the SparkJobDefinition to retrieve the definition for. This parameter is optional.

    .PARAMETER SparkJobDefinitionFormat
        The format in which to retrieve the SparkJobDefinition definition. This parameter is optional.

    .EXAMPLE
        This example retrieves the definition of the SparkJobDefinition with ID "SparkJobDefinition-67890" in the workspace with ID "workspace-12345".

        ```powershell
        Get-FabricSparkJobDefinitionDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionId "SparkJobDefinition-67890"
        ```

    .EXAMPLE
        This example retrieves the definition of the SparkJobDefinition with ID "SparkJobDefinition-67890" in the workspace with ID "workspace-12345" in JSON format.

        ```powershell
        Get-FabricSparkJobDefinitionDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionId "SparkJobDefinition-67890" -SparkJobDefinitionFormat "json"
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
        [guid]$SparkJobDefinitionId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('SparkJobDefinitionV1', 'SparkJobDefinitionV2')]
        [string]$SparkJobDefinitionFormat = "SparkJobDefinitionV1"
    )
    try {
        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/sparkJobDefinitions/$SparkJobDefinitionId/getDefinition"
        if ($SparkJobDefinitionFormat) {
            $apiEndpointUrl += "?format=$SparkJobDefinitionFormat"
        }
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve Spark Job Definition definition
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Post'
            HandleResponse = $true
        }
        $response = Invoke-FabricRestMethod @apiParams

        # Return the response
        return $response
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve Spark Job Definition. Error: $errorDetails" -Level Error
    }

}
