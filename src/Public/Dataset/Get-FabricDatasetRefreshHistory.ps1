function Get-FabricDatasetRefreshHistory {
    <#
    .SYNOPSIS
        Retrieves the refresh history of a Power BI dataset.

    .DESCRIPTION
        Calls the Power BI REST API to retrieve refresh history for a dataset or all datasets
        in a workspace. When `GroupId` is supplied the request targets the dataset inside a
        specific workspace (`groups/{groupId}/datasets/{datasetId}/refreshes`); otherwise it
        targets the dataset in My Workspace (`datasets/{datasetId}/refreshes`).

    .PARAMETER DatasetId
        The unique identifier of the dataset whose refresh history to retrieve. Omit this
        parameter with `WorkspaceId` to retrieve refresh history for every dataset in the workspace.

    .PARAMETER WorkspaceId
        The unique identifier of the workspace that contains the dataset(s). When omitted,
        the My Workspace endpoint is used and `DatasetId` is required.

    .PARAMETER Top
        (Optional) The number of refresh history entries to return. Must be at least 1.
        When omitted, the Power BI API default of up to 60 entries is returned.

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

    .EXAMPLE
        Retrieves the latest refresh for every dataset in a workspace.

        ```powershell
        Get-FabricDatasetRefreshHistory -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" -Top 1
        ```

    .NOTES
        - Requires a valid Power BI / Fabric token (call `Connect-FabricAccount` first).
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.
        - OneDrive refresh history is not returned by the Power BI API.
        - The API retains at most 60 entries; entries older than 3 days are pruned once more
          than 20 exist.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(DefaultParameterSetName = 'DatasetInMyWorkspace')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'DatasetInMyWorkspace')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DatasetInWorkspace')]
        [ValidateNotNullOrEmpty()]
        [guid]$DatasetId,

        [Parameter(Mandatory = $true, ParameterSetName = 'DatasetInWorkspace')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Workspace')]
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

        if ($PSBoundParameters.ContainsKey('DatasetId')) {
            $datasetParams = @{
                DatasetId = $DatasetId
            }
            if ($PSBoundParameters.ContainsKey('WorkspaceId')) {
                $datasetParams.WorkspaceId = $WorkspaceId
            }
            $datasets = @(Get-FabricDataset @datasetParams)
        } else {
            $datasets = @(Get-FabricDataset -WorkspaceId $WorkspaceId)
        }

        $allRefreshes = @()
        foreach ($dataset in $datasets) {
            $currentDatasetId = if ($dataset.Id) { $dataset.Id } else { $DatasetId }
            $apiEndpointUrl = if ($PSBoundParameters.ContainsKey('WorkspaceId')) {
                "groups/{0}/datasets/{1}/refreshes" -f $WorkspaceId, $currentDatasetId
            } else {
                "datasets/{0}/refreshes" -f $currentDatasetId
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
                ObjectIdOrName = $currentDatasetId
                HandleResponse = $true
                ExtractValue   = 'True'
            }
            $refreshes = @(Invoke-FabricRestMethod @apiParams)

            if ($refreshes) {
                foreach ($refresh in $refreshes) {
                    $refresh | Add-Member -NotePropertyName WorkspaceId -NotePropertyValue $WorkspaceId -Force
                    $refresh | Add-Member -NotePropertyName DatasetId -NotePropertyValue $currentDatasetId -Force
                    $refresh | Add-Member -NotePropertyName DatasetName -NotePropertyValue $dataset.Name -Force
                }
                $allRefreshes += $refreshes
                Write-Message -Message "Retrieved $($refreshes.Count) refresh history entries for dataset '$currentDatasetId'." -Level Debug
            } else {
                Write-Message -Message "No refresh history found for dataset '$currentDatasetId'." -Level Warning
            }
        }

        if ($allRefreshes) {
            return $allRefreshes
        }
    } catch {
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to retrieve refresh history. Error: $errorDetails" -Level Error
        if ($PSCmdlet.ParameterSetName -eq 'Workspace') {
            throw
        }
    }
}
