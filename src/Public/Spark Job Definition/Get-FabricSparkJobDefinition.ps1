function Get-FabricSparkJobDefinition {
    <#
    .SYNOPSIS
        Retrieves Spark Job Definition details from a specified Microsoft Fabric workspace.

    .DESCRIPTION
        This function retrieves SparkJobDefinition details from a specified workspace using either the provided SparkJobDefinitionId or SparkJobDefinitionName.
        It handles token validation, constructs the API URL, makes the API request, and processes the response.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace where the SparkJobDefinition exists. This parameter is mandatory.

    .PARAMETER SparkJobDefinitionId
        The unique identifier of the SparkJobDefinition to retrieve. This parameter is optional.

    .PARAMETER SparkJobDefinitionName
        The name of the SparkJobDefinition to retrieve. This parameter is optional.

    .EXAMPLE
        This example retrieves the SparkJobDefinition details for the SparkJobDefinition with ID "SparkJobDefinition-67890" in the workspace with ID "workspace-12345".

        ```powershell
        Get-FabricSparkJobDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionId "SparkJobDefinition-67890"
        ```

    .EXAMPLE
        This example retrieves the SparkJobDefinition details for the SparkJobDefinition named "My SparkJobDefinition" in the workspace with ID "workspace-12345".

        ```powershell
        Get-FabricSparkJobDefinition -WorkspaceId "workspace-12345" -SparkJobDefinitionName "My SparkJobDefinition"
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
        [string]$SparkJobDefinitionName
    )
    try {
        # Handle ambiguous input
        if ($SparkJobDefinitionId -and $SparkJobDefinitionName) {
            Write-Message -Message "Both 'SparkJobDefinitionId' and 'SparkJobDefinitionName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Construct the API endpoint URL
        $apiEndpointUrl = "workspaces/$WorkspaceId/sparkJobDefinitions"
        Write-Message -Message "Constructed API Endpoint: $apiEndpointUrl" -Level Debug

        # Invoke the Fabric API to retrieve Spark Job Definitions
        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            ExtractValue   = 'True'
            HandleResponse = $true
        }
        $SparkJobDefinitions = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $SparkJobDefinition = if ($SparkJobDefinitionId) {
            $SparkJobDefinitions | Where-Object { $_.Id -eq $SparkJobDefinitionId }
        } elseif ($SparkJobDefinitionName) {
            $SparkJobDefinitions | Where-Object { $_.DisplayName -eq $SparkJobDefinitionName }
        } else {
            # Return all SparkJobDefinitions if no filter is provided
            Write-Message -Message "No filter provided. Returning all SparkJobDefinitions." -Level Debug
            $SparkJobDefinitions
        }

        # Handle results
        if ($SparkJobDefinition) {
            Write-Message -Message "Spark Job Definition found in the Workspace '$WorkspaceId'." -Level Debug
            return $SparkJobDefinition
        } else {
            Write-Message -Message "No Spark Job Definition found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        # Capture and log error details
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve SparkJobDefinition. Error: $errorDetails" -Level Error
    }

}
