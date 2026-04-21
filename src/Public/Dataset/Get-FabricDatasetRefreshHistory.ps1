function Get-FabricDatasetRefreshHistory {
    <#
    .SYNOPSIS
        Retrieves the refresh history of a Power BI dataset.

    .DESCRIPTION
        Calls the Power BI REST API to retrieve the refresh history for a specified dataset.
        When `GroupId` is supplied the request targets the dataset inside a specific workspace
        (`groups/{groupId}/datasets/{datasetId}/refreshes`); otherwise it targets the dataset
        in My Workspace (`datasets/{datasetId}/refreshes`).

    .PARAMETER DatasetId
        (Mandatory) The unique identifier of the dataset whose refresh history to retrieve.

    .PARAMETER WorkspaceId
        (Optional) The unique identifier of the workspace that contains the dataset.
        When omitted, the My Workspace endpoint is used.

    .PARAMETER Top
        (Optional) The number of refresh history entries to return. Must be at least 1.
        Defaults to 60 (Power BI API default).

    .EXAMPLE
        Retrieves the refresh history for a dataset in My Workspace.

        ```powershell
        Get-FabricDatasetRefreshHistory -DatasetId "12345678-90ab-cdef-1234-567890abcdef"
        ```

    .EXAMPLE
        Retrieves the last 10 refresh history entries for a dataset in a specific workspace.

        ```powershell
        Get-FabricDatasetRefreshHistory `
            -DatasetId "12345678-90ab-cdef-1234-567890abcdef" `
            -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" `
            -Top 10
        ```

    .NOTES
        - Requires a valid Power BI / Fabric token (call `Connect-FabricAccount` first).
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.
        - OneDrive refresh history is not returned by the Power BI API.
        - The API retains at most 60 entries; entries older than 3 days are pruned once more
          than 20 exist.

        Author: Kamil Nowinski
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DatasetId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('GroupId')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$Top
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Build the endpoint path depending on whether a workspace (group) is specified
        if ($PSBoundParameters.ContainsKey('WorkspaceId')) {
            $apiEndpointUrl = "groups/{0}/datasets/{1}/refreshes" -f $WorkspaceId, $DatasetId
        } else {
            $apiEndpointUrl = "datasets/{0}/refreshes" -f $DatasetId
        }

        # Append $top query parameter when requested
        if ($PSBoundParameters.ContainsKey('Top')) {
            $apiEndpointUrl = "{0}?`$top={1}" -f $apiEndpointUrl, $Top
        }

        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        $apiParams = @{
            Uri            = $apiEndpointUrl
            Method         = 'Get'
            PowerBIApi     = $true
            TypeName       = 'Dataset'
            ObjectIdOrName = $DatasetId
            HandleResponse = $true
            ExtractValue   = 'True'
        }
        $refreshes = Invoke-FabricRestMethod @apiParams

        if ($refreshes) {
            Write-Message -Message "Retrieved $($refreshes.Count) refresh history entries for dataset '$DatasetId'." -Level Debug
            return $refreshes
        } else {
            Write-Message -Message "No refresh history found for dataset '$DatasetId'." -Level Warning
            return $null
        }
    } catch {
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve refresh history for dataset '$DatasetId'. Error: $errorDetails" -Level Error
    }
}
