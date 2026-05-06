function Invoke-FabricDatasetRefresh {
    <#
    .SYNOPSIS
        Triggers a refresh of a Power BI dataset.

    .DESCRIPTION
        Calls the Power BI REST API to trigger an on-demand refresh for a specified dataset.
        When `WorkspaceId` is supplied the request targets the dataset inside a specific workspace
        (`groups/{groupId}/datasets/{datasetId}/refreshes`); otherwise it targets the dataset
        in My Workspace (`datasets/{datasetId}/refreshes`).

        Providing any parameter beyond `NotifyOption` triggers an enhanced refresh (requires
        Premium or Fabric capacity). Shared capacity supports only `NotifyOption` and is
        limited to 8 refreshes per day.

    .PARAMETER DatasetId
        (Mandatory) The unique identifier of the dataset to refresh.

    .PARAMETER WorkspaceId
        (Optional) The unique identifier of the workspace that contains the dataset.
        When omitted, the My Workspace endpoint is used.

    .PARAMETER NotifyOption
        (Optional) Mail notification preference for the refresh.
        Valid values: NoNotification, MailOnFailure, MailOnCompletion.
        Defaults to NoNotification. Not applicable to enhanced refreshes or service principal operations.

    .PARAMETER Type
        (Optional) The type of processing to perform.
        Valid values: Full, ClearValues, Calculate, DataOnly, Automatic, Defragment.
        Triggers an enhanced refresh when specified.

    .PARAMETER CommitMode
        (Optional) Determines whether objects are committed in batches or only when complete.
        Valid values: Transactional, PartialBatch.
        Triggers an enhanced refresh when specified.

    .PARAMETER MaxParallelism
        (Optional) The maximum number of threads on which to run parallel processing commands.
        Triggers an enhanced refresh when specified.

    .PARAMETER RetryCount
        (Optional) The number of times the operation is retried before failing.
        Triggers an enhanced refresh when specified.

    .PARAMETER Timeout
        (Optional) The timeout per individual refresh attempt, in HH:MM:SS format (max 24 hours
        total including retries). Defaults to 5 hours.
        Triggers an enhanced refresh when specified.

    .PARAMETER EffectiveDate
        (Optional) If an incremental refresh policy is applied, overrides the current date used
        to determine the rolling window period.
        Triggers an enhanced refresh when specified.

    .PARAMETER ApplyRefreshPolicy
        (Optional) Whether to apply the configured incremental refresh policy.
        Triggers an enhanced refresh when specified.

    .PARAMETER Objects
        (Optional) An array of hashtables specifying specific tables and/or partitions to process.
        Each entry should contain 'table' and optionally 'partition' keys.
        Triggers an enhanced refresh when specified.

        Example: @(@{ table = 'Sales' }, @{ table = 'Date'; partition = 'Date-2024' })

    .EXAMPLE
        Triggers a simple refresh of a dataset in My Workspace.

        ```powershell
        Invoke-FabricDatasetRefresh -DatasetId "12345678-90ab-cdef-1234-567890abcdef"
        ```

    .EXAMPLE
        Triggers a full refresh of a dataset in a specific workspace with email notification on failure.

        ```powershell
        Invoke-FabricDatasetRefresh `
            -DatasetId   "12345678-90ab-cdef-1234-567890abcdef" `
            -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" `
            -Type        Full `
            -NotifyOption MailOnFailure
        ```

    .EXAMPLE
        Triggers an enhanced refresh targeting specific tables only.

        ```powershell
        Invoke-FabricDatasetRefresh `
            -DatasetId  "12345678-90ab-cdef-1234-567890abcdef" `
            -WorkspaceId "abcdef12-3456-7890-abcd-ef1234567890" `
            -Objects    @(@{ table = 'Sales' }, @{ table = 'Date' }) `
            -CommitMode PartialBatch
        ```

    .NOTES
        - Requires a valid Power BI / Fabric token (call `Connect-FabricAccount` first).
        - Calls `Confirm-TokenState` to ensure token validity before making the API request.
        - The API responds with 202 Accepted; the refresh runs asynchronously in the background.
        - Use `Get-FabricDatasetRefreshHistory` to monitor refresh status.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$DatasetId,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Alias('GroupId')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('NoNotification', 'MailOnFailure', 'MailOnCompletion')]
        [string]$NotifyOption = 'NoNotification',

        [Parameter(Mandatory = $false)]
        [ValidateSet('Full', 'ClearValues', 'Calculate', 'DataOnly', 'Automatic', 'Defragment')]
        [string]$Type,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Transactional', 'PartialBatch')]
        [string]$CommitMode,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$MaxParallelism,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$RetryCount,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Timeout,

        [Parameter(Mandatory = $false)]
        [datetime]$EffectiveDate,

        [Parameter(Mandatory = $false)]
        [bool]$ApplyRefreshPolicy,

        [Parameter(Mandatory = $false)]
        [hashtable[]]$Objects
    )

    try {
        # Ensure token validity
        Confirm-TokenState

        # Build the endpoint path depending on whether a workspace is specified
        if ($PSBoundParameters.ContainsKey('WorkspaceId')) {
            $apiEndpointUrl = "groups/{0}/datasets/{1}/refreshes" -f $WorkspaceId, $DatasetId
        } else {
            $apiEndpointUrl = "datasets/{0}/refreshes" -f $DatasetId
        }

        Write-Message -Message "API Endpoint: $apiEndpointUrl" -Level Debug

        # Build the request body — always include notifyOption
        $body = @{
            notifyOption = $NotifyOption
        }

        if ($PSBoundParameters.ContainsKey('Type'))              { $body.type              = $Type }
        if ($PSBoundParameters.ContainsKey('CommitMode'))        { $body.commitMode        = $CommitMode }
        if ($PSBoundParameters.ContainsKey('MaxParallelism'))    { $body.maxParallelism    = $MaxParallelism }
        if ($PSBoundParameters.ContainsKey('RetryCount'))        { $body.retryCount        = $RetryCount }
        if ($PSBoundParameters.ContainsKey('Timeout'))           { $body.timeout           = $Timeout }
        if ($PSBoundParameters.ContainsKey('EffectiveDate'))     { $body.effectiveDate     = $EffectiveDate.ToString('o') }
        if ($PSBoundParameters.ContainsKey('ApplyRefreshPolicy')){ $body.applyRefreshPolicy = $ApplyRefreshPolicy }
        if ($PSBoundParameters.ContainsKey('Objects'))           { $body.objects           = $Objects }

        $bodyJson = $body | ConvertTo-Json -Depth 10
        Write-Message -Message "Request Body: $bodyJson" -Level Debug

        if ($PSCmdlet.ShouldProcess($DatasetId, "Refresh Dataset")) {
            $apiParams = @{
                Uri            = $apiEndpointUrl
                Method         = 'Post'
                Body           = $bodyJson
                PowerBIApi     = $true
                TypeName       = 'Dataset'
                ObjectIdOrName = $DatasetId
                HandleResponse = $true
            }
            Invoke-FabricRestMethod @apiParams
        }
    } catch {
        $errorDetails = $_.Exception.Message
        Write-Message -Message "Failed to trigger refresh for dataset '$DatasetId'. Error: $errorDetails" -Level Error
    }
}
