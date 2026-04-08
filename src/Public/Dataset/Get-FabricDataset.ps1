function Get-FabricDataset {
    <#
    .SYNOPSIS
        Retrieves one or more Power BI datasets from My Workspace or a specific workspace.

    .DESCRIPTION
        Calls the Power BI REST API to list datasets.
        When `GroupId` is supplied the request targets a specific workspace
        (`groups/{groupId}/datasets`); otherwise it targets My Workspace (`datasets`).

        Optionally filter the results to a single dataset by `DatasetId` or `DatasetName`.

    .PARAMETER WorkspaceId
        (Optional) The unique identifier of the workspace to query.
        When omitted, datasets from My Workspace are returned.

    .PARAMETER DatasetId
        (Optional) The unique identifier of a specific dataset to return.
        Cannot be combined with `DatasetName`.

    .PARAMETER DatasetName
        (Optional) The display name of a specific dataset to return.
        Cannot be combined with `DatasetId`.

    .EXAMPLE
        Retrieves all datasets from My Workspace.

        ```powershell
        Get-FabricDataset
        ```

    .EXAMPLE
        Retrieves all datasets from a specific workspace.

        ```powershell
        Get-FabricDataset -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890"
        ```

    .EXAMPLE
        Retrieves a specific dataset by name from a workspace.

        ```powershell
        Get-FabricDataset -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" -DatasetName "Sales Model"
        ```

    .EXAMPLE
        Retrieves a specific dataset by ID from My Workspace.

        ```powershell
        Get-FabricDataset -DatasetId "12345678-90ab-cdef-1234-567890abcdef"
        ```

    .NOTES
        - Requires a valid Power BI / Fabric token (call `Connect-FabricAccount` first).
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.
        - Callers with Read-only access to a workspace may receive a limited response
          (only `id` and `name` fields) from the in-group endpoint.

        Author: Kamil Nowinski
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('GroupId')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [guid]$DatasetId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DatasetName
    )

    try {
        # Handle ambiguous input
        if ($DatasetId -and $DatasetName) {
            Write-Message -Message "Both 'DatasetId' and 'DatasetName' were provided. Please specify only one." -Level Error
            return $null
        }

        # Ensure token validity
        Confirm-TokenState

        # Build the endpoint path depending on whether a workspace (group) is specified
        if ($PSBoundParameters.ContainsKey('WorkspaceId')) {
            $apiEndpointUrl = "groups/{0}/datasets" -f $WorkspaceId
        } else {
            $apiEndpointUrl = "datasets"
        }

        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            PowerBIApi     = $true
            TypeName       = 'Dataset'
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $datasets = @(Invoke-FabricRestMethod @apiParams)

        # Filter results based on provided parameters
        $result = if ($DatasetId) {
            $datasets | Where-Object { $_.id -eq $DatasetId }
        } elseif ($DatasetName) {
            $datasets | Where-Object { $_.name -eq $DatasetName }
        } else {
            Write-Message -Message "No filter provided. Returning all datasets." -Level Debug
            $datasets
        }

        if ($result) {
            Write-Message -Message "Retrieved $(@($result).Count) dataset(s)." -Level Debug
            return $result
        } else {
            Write-Message -Message "No dataset found matching the provided criteria." -Level Warning
            return $null
        }
    } catch {
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve datasets. Error: $errorDetails" -Level Error
    }
}
