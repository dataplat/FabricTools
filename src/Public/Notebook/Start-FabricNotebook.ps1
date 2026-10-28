function Start-FabricNotebook {
    <#
    .SYNOPSIS
        Starts a notebook in Microsoft Fabric.

    .DESCRIPTION
        Submits a RunNotebook job in the specified workspace and waits for its
        terminal job status by default. Notebook names must match exactly one
        notebook in that workspace. Polling follows the job-instance Location
        and honors Retry-After, rather than using the generic LRO endpoints.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the notebook.

    .PARAMETER NotebookId
        The ID of the notebook to run. Cannot be combined with NotebookName.

    .PARAMETER NotebookName
        The display name of the notebook to run. Cannot be combined with NotebookId.

    .PARAMETER NoWait
        Returns the submitted job's current instance without waiting for completion.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        The current or final job instance, including status and failureReason.
        Failed or cancelled jobs also produce an error when waiting.

    .EXAMPLE
        Start-FabricNotebook -WorkspaceId '11111111-1111-1111-1111-111111111111' -NotebookName 'Daily load'

        Runs Daily load and returns its final job instance.

    .EXAMPLE
        Start-FabricNotebook -WorkspaceId '11111111-1111-1111-1111-111111111111' -NotebookId '22222222-2222-2222-2222-222222222222' -NoWait

        Submits the notebook and returns its current job instance promptly.

    .EXAMPLE
        Start-FabricNotebook -WorkspaceId '11111111-1111-1111-1111-111111111111' -NotebookName 'Daily load' -WhatIf

        Resolves the notebook and previews execution without submitting a job.

    .NOTES
        Requires an authenticated Fabric session. Notebook parameters and compute
        configuration are not supported.

        Author: FabricTools Team
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [guid]$NotebookId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string]$NotebookName,

        [Parameter()]
        [switch]$NoWait
    )

    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/notebooks"
            Method           = 'Get'
            TypeName         = 'Notebook'
            HandleResponse   = $true
            ExtractValue     = 'True'
            TestTokenExpired = $true
        }
        $notebooks = @(Invoke-FabricRestMethod @apiParams |
            Where-Object { $_.DisplayName -eq $NotebookName })
        if ($notebooks.Count -eq 0) {
            throw "Notebook '$NotebookName' was not found in workspace '$WorkspaceId'."
        }
        if ($notebooks.Count -gt 1) {
            throw "Notebook name '$NotebookName' is ambiguous in workspace '$WorkspaceId'. Specify NotebookId."
        }
        $NotebookId = $notebooks[0].Id
    }

    if (-not $PSCmdlet.ShouldProcess("Notebook '$NotebookId' in workspace '$WorkspaceId'", 'Run notebook')) {
        return
    }

    $apiParams = @{
        Uri              = "workspaces/$WorkspaceId/items/$NotebookId/jobs/instances?jobType=RunNotebook"
        Method           = 'Post'
        TypeName         = 'Notebook'
        ObjectIdOrName   = $NotebookId
        HandleResponse   = $true
        NoWait           = $true # Job instances are not generic long-running operations.
        TestTokenExpired = $true
    }
    $submission = Invoke-FabricRestMethod @apiParams
    $jobLocation = [string](@($submission.Location)[0])
    if ([string]::IsNullOrWhiteSpace($jobLocation)) {
        throw 'Notebook submission did not return a job-instance Location.'
    }

    $retryAfter = $submission.RetryAfter
    $apiParams.Uri = $jobLocation
    $apiParams.Method = 'Get'
    $apiParams.ExtractValue = 'False'

    do {
        if (-not $NoWait) {
            $delay = 5
            $retryAfterText = [string](@($retryAfter)[0])
            $seconds = 0
            $retryDate = [DateTimeOffset]::MinValue
            if ([int]::TryParse($retryAfterText, [ref]$seconds) -and $seconds -ge 0) {
                $delay = $seconds
            } elseif ([DateTimeOffset]::TryParse($retryAfterText, [ref]$retryDate)) {
                $delay = [Math]::Max(0, [Math]::Ceiling(($retryDate - [DateTimeOffset]::UtcNow).TotalSeconds))
            }
            Start-Sleep -Seconds $delay
        }

        $job = Invoke-FabricRestMethod @apiParams
        $retryAfter = $script:responseHeader['Retry-After']
        if (-not $job.status) {
            throw 'The notebook job-instance response did not contain a status.'
        }
        if ($NoWait) {
            return $job
        }
    } while ($job.status -notin @('Completed', 'Failed', 'Cancelled', 'Deduped'))

    $job
    if ($job.status -in @('Failed', 'Cancelled')) {
        $failureDetails = $job.failureReason | ConvertTo-Json -Depth 10 -Compress
        Write-Error -Message "Notebook '$NotebookId' job '$($job.id)' ended with status '$($job.status)'. $failureDetails" -ErrorId 'FabricNotebookExecutionFailed' -Category OperationStopped -TargetObject $job
    }
}
