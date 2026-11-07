function Connect-FabricGit {
    <#
    .SYNOPSIS
        Connects a Fabric workspace to a Git repository and branch.

    .DESCRIPTION
        Connects the specified workspace to an Azure DevOps or GitHub repository, branch and
        folder. After connecting, the connection must be initialized; use -Initialize to do this
        in the same call, or run Initialize-FabricGitConnection afterwards.

        -GitProviderType is mandatory and must match the provider parameters supplied:
        AzureDevOps requires -OrganizationName and -ProjectName, GitHub requires -OwnerName and
        -ConnectionId.

    .PARAMETER WorkspaceId
        The ID of the workspace to connect. Accepts pipeline input by property name (alias Id).

    .PARAMETER GitProviderType
        The Git provider: AzureDevOps or GitHub.

    .PARAMETER OrganizationName
        Azure DevOps only. The Azure DevOps organization name.

    .PARAMETER ProjectName
        Azure DevOps only. The Azure DevOps project name.

    .PARAMETER OwnerName
        GitHub only. The owner (user or organization) of the GitHub repository.

    .PARAMETER RepositoryName
        The name of the Git repository to connect to.

    .PARAMETER BranchName
        The name of the branch in the repository to connect to.

    .PARAMETER DirectoryName
        The folder in the repository that holds the workspace content. Defaults to '/'.

    .PARAMETER ConnectionId
        The ID of a configured Fabric connection holding the Git credentials. When supplied, the
        credentials source is 'ConfiguredConnection'; otherwise 'Automatic' (Azure DevOps with
        the signed-in user's identity). Required for GitHub.

    .PARAMETER Initialize
        Also initializes the Git connection after connecting (see Initialize-FabricGitConnection).

    .PARAMETER InitializationStrategy
        Used with -Initialize. None (default), PreferRemote or PreferWorkspace.

    .PARAMETER NoWait
        Used with -Initialize. Returns the long-running operation details instead of waiting.

    .OUTPUTS
        System.Management.Automation.PSCustomObject
        Nothing without -Initialize. With -Initialize, the initialization result (requiredAction,
        workspaceHead, remoteCommitHash, WorkspaceId).

    .EXAMPLE
        Connect-FabricGit -WorkspaceId '11111111-1111-1111-1111-111111111111' -GitProviderType AzureDevOps -OrganizationName 'contoso' -ProjectName 'Fabric' -RepositoryName 'sales' -BranchName 'main' -DirectoryName '/workspace' -Initialize -InitializationStrategy PreferRemote

        Connects the workspace to an Azure DevOps repository and initializes the connection,
        preferring the content of the branch.

    .EXAMPLE
        Connect-FabricGit -WorkspaceId '11111111-1111-1111-1111-111111111111' -GitProviderType GitHub -OwnerName 'contoso' -RepositoryName 'sales' -BranchName 'main' -ConnectionId '22222222-2222-2222-2222-222222222222'

        Connects the workspace to a GitHub repository using the credentials stored in a
        configured connection. Initialize-FabricGitConnection must be run afterwards.

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/git/connect

        Requires the workspace Admin role. Service principals require -ConnectionId.

        Author: Kamil Nowinski
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AzureDevOps')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateSet('AzureDevOps', 'GitHub')]
        [string]$GitProviderType,

        [Parameter(Mandatory = $true, ParameterSetName = 'AzureDevOps')]
        [ValidateNotNullOrEmpty()]
        [string]$OrganizationName,

        [Parameter(Mandatory = $true, ParameterSetName = 'AzureDevOps')]
        [ValidateNotNullOrEmpty()]
        [string]$ProjectName,

        [Parameter(Mandatory = $true, ParameterSetName = 'GitHub')]
        [ValidateNotNullOrEmpty()]
        [string]$OwnerName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$RepositoryName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$BranchName,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DirectoryName = '/',

        [Parameter(Mandatory = $false)]
        [guid]$ConnectionId,

        [Parameter(Mandatory = $false)]
        [switch]$Initialize,

        [Parameter(Mandatory = $false)]
        [ValidateSet('None', 'PreferRemote', 'PreferWorkspace')]
        [string]$InitializationStrategy = 'None',

        [Parameter(Mandatory = $false)]
        [switch]$NoWait
    )

    process {
        if ($PSCmdlet.ParameterSetName -ne $GitProviderType) {
            $expected = if ($GitProviderType -eq 'GitHub') { '-OwnerName' } else { '-OrganizationName and -ProjectName' }
            throw "GitProviderType '$GitProviderType' requires $expected."
        }
        if ($GitProviderType -eq 'GitHub' -and -not $PSBoundParameters.ContainsKey('ConnectionId')) {
            throw "GitProviderType 'GitHub' requires -ConnectionId (a configured connection with GitHub credentials)."
        }

        $providerDetails = [ordered]@{
            gitProviderType = $GitProviderType
        }
        if ($GitProviderType -eq 'AzureDevOps') {
            $providerDetails.organizationName = $OrganizationName
            $providerDetails.projectName = $ProjectName
        } else {
            $providerDetails.ownerName = $OwnerName
        }
        $providerDetails.repositoryName = $RepositoryName
        $providerDetails.branchName = $BranchName
        $providerDetails.directoryName = $DirectoryName

        $credentials = if ($PSBoundParameters.ContainsKey('ConnectionId')) {
            [ordered]@{ source = 'ConfiguredConnection'; connectionId = $ConnectionId.ToString() }
        } else {
            [ordered]@{ source = 'Automatic' }
        }

        $body = [ordered]@{
            gitProviderDetails = $providerDetails
            myGitCredentials   = $credentials
        } | ConvertTo-Json -Depth 5

        $target = "Workspace '$WorkspaceId'"
        $action = "Connect to $GitProviderType repository '$RepositoryName' (branch '$BranchName', folder '$DirectoryName')"
        if (-not $PSCmdlet.ShouldProcess($target, $action)) {
            return
        }

        $apiParams = @{
            Uri              = "workspaces/$WorkspaceId/git/connect"
            Method           = 'Post'
            Body             = $body
            TypeName         = 'Git connection'
            ObjectIdOrName   = $WorkspaceId
            HandleResponse   = $true
            TestTokenExpired = $true
            SuccessMessage   = "Workspace '$WorkspaceId' connected to $GitProviderType repository '$RepositoryName' (branch '$BranchName')."
        }
        $null = Invoke-FabricRestMethod @apiParams

        if ($Initialize) {
            $initParams = @{
                WorkspaceId            = $WorkspaceId
                InitializationStrategy = $InitializationStrategy
                NoWait                 = $NoWait
                Confirm                = $false
            }
            Initialize-FabricGitConnection @initParams
        } else {
            Write-Message -Message "Run Initialize-FabricGitConnection -WorkspaceId '$WorkspaceId' to complete the connection." -Level Verbose
        }
    }
}
