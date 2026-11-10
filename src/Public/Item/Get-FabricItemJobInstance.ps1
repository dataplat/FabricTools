function Get-FabricItemJobInstance {
    <#
    .SYNOPSIS
        Gets job instances for a Fabric item.

    .DESCRIPTION
        Retrieves a specific job instance or lists recent instances for the
        specified item and job type.

    .PARAMETER WorkspaceId
        The ID of the workspace containing the item.

    .PARAMETER ItemId
        The ID of the item whose job instances are retrieved.

    .PARAMETER JobType
        The job type to list, such as Pipeline or RunNotebook.

    .PARAMETER JobInstanceId
        The ID of a job instance to retrieve. Omit to list recent instances.

    .EXAMPLE
        ```powershell
        Get-FabricItemJobInstance -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline
        ```

    .EXAMPLE
        ```powershell
        Get-FabricItemJobInstance -WorkspaceId '11111111-1111-1111-1111-111111111111' -ItemId '22222222-2222-2222-2222-222222222222' -JobType Pipeline -JobInstanceId '33333333-3333-3333-3333-333333333333'
        ```

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/job-scheduler/list-item-job-instances

        Author: Kamil Nowinski
    #>
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$ItemId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$JobType,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [guid]$JobInstanceId
    )

    $apiParams = @{
        Method           = 'Get'
        TypeName         = 'Item job instance'
        ObjectIdOrName   = $ItemId
        HandleResponse   = $true
        TestTokenExpired = $true
    }
    if ($PSBoundParameters.ContainsKey('JobInstanceId')) {
        $apiParams.Uri = "workspaces/$WorkspaceId/items/$ItemId/jobs/instances/${JobInstanceId}?jobType=$([uri]::EscapeDataString($JobType))"
        return Invoke-FabricRestMethod @apiParams
    }

    $apiParams.Uri = "workspaces/$WorkspaceId/items/$ItemId/jobs/instances?jobType=$([uri]::EscapeDataString($JobType))"
    $apiParams.ExtractValue = 'True'
    $jobInstances = @(Invoke-FabricRestMethod @apiParams)
    $jobInstances
}
