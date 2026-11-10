function Start-FabricDataPipeline {
    <#
    .SYNOPSIS
        Starts a data pipeline in Microsoft Fabric.

    .DESCRIPTION
        Submits a Pipeline job in the specified workspace, optionally passes
        execution parameters, and waits for its terminal status by default.
        Pipeline names must match exactly one pipeline in the workspace.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the pipeline.

    .PARAMETER DataPipelineId
        The ID of the pipeline to run. Cannot be combined with DataPipelineName.

    .PARAMETER DataPipelineName
        The exact display name of the pipeline to run.

    .PARAMETER Parameters
        A hashtable of pipeline parameters passed as executionData.parameters.

    .PARAMETER NoWait
        Returns the current job instance without waiting for completion.

    .EXAMPLE
        Start-FabricDataPipeline -WorkspaceId '11111111-1111-1111-1111-111111111111' -DataPipelineName 'Daily load'

    .EXAMPLE
        $parameters = @{ loadDate = '2026-11-09' }
        Start-FabricDataPipeline -WorkspaceId '11111111-1111-1111-1111-111111111111' -DataPipelineId '22222222-2222-2222-2222-222222222222' -Parameters $parameters -NoWait

    .NOTES
        Requires an authenticated Fabric session.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$DataPipelineId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [Alias('Name', 'DisplayName')]
        [string]$DataPipelineName,

        [Parameter()]
        [hashtable]$Parameters,

        [Parameter()]
        [switch]$NoWait
    )

    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/dataPipelines"
            Method           = 'Get'
            TypeName         = 'DataPipeline'
            HandleResponse   = $true
            ExtractValue     = 'True'
            TestTokenExpired = $true
        }
        $pipelines = @(Invoke-FabricRestMethod @apiParams |
            Where-Object { $_.DisplayName -ceq $DataPipelineName })
        if ($pipelines.Count -eq 0) {
            throw "Data pipeline '$DataPipelineName' was not found in workspace '$WorkspaceId'."
        }
        if ($pipelines.Count -gt 1) {
            throw "Data pipeline name '$DataPipelineName' is ambiguous in workspace '$WorkspaceId'. Specify DataPipelineId."
        }
        $DataPipelineId = $pipelines[0].Id
    }

    if (-not $PSCmdlet.ShouldProcess("Data pipeline '$DataPipelineId' in workspace '$WorkspaceId'", 'Run data pipeline')) {
        return
    }

    $apiParams = @{
        Uri              = "workspaces/$WorkspaceId/items/$DataPipelineId/jobs/instances?jobType=Pipeline"
        Method           = 'Post'
        TypeName         = 'Data pipeline'
        ObjectIdOrName   = $DataPipelineId
        HandleResponse   = $true
        NoWait           = $true
        TestTokenExpired = $true
    }
    if ($PSBoundParameters.ContainsKey('Parameters')) {
        $apiParams.Body = @{ executionData = @{ parameters = $Parameters } }
    }

    $submission = Invoke-FabricRestMethod @apiParams
    $jobLocation = [string](@($submission.Location)[0])
    if ([string]::IsNullOrWhiteSpace($jobLocation)) {
        throw 'Data pipeline submission did not return a job-instance Location.'
    }

    $retryAfter = $submission.RetryAfter
    $apiParams.Uri = $jobLocation
    $apiParams.Method = 'Get'
    $apiParams.Remove('Body')
    $apiParams.Remove('NoWait')
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
        $retryAfter = if ($script:responseHeader) { $script:responseHeader['Retry-After'] } else { $null }
        if (-not $job.status) {
            throw 'The data pipeline job-instance response did not contain a status.'
        }
        if ($NoWait) {
            return $job
        }
    } while ($job.status -notin @('Completed', 'Failed', 'Cancelled', 'Deduped'))

    $job
    if ($job.status -in @('Failed', 'Cancelled')) {
        $failureDetails = $job.failureReason | ConvertTo-Json -Depth 10 -Compress
        Write-Error -Message "Data pipeline '$DataPipelineId' job '$($job.id)' ended with status '$($job.status)'. $failureDetails" -ErrorId 'FabricDataPipelineExecutionFailed' -Category OperationStopped -TargetObject $job
    }
}
