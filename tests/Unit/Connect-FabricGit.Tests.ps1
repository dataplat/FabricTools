#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe 'Connect-FabricGit' -Tag 'UnitTests' {

    BeforeAll {
        $command = Get-Command -Name Connect-FabricGit
    }

    Context 'Command definition' {
        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'GitProviderType'; Mandatory = $true }
            @{ Name = 'RepositoryName'; Mandatory = $true }
            @{ Name = 'BranchName'; Mandatory = $true }
            @{ Name = 'DirectoryName'; Mandatory = $false }
            @{ Name = 'ConnectionId'; Mandatory = $false }
            @{ Name = 'Initialize'; Mandatory = $false }
            @{ Name = 'InitializationStrategy'; Mandatory = $false }
            @{ Name = 'NoWait'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should have AzureDevOps and GitHub parameter sets' {
            $command.ParameterSets.Name | Should -Contain 'AzureDevOps'
            $command.ParameterSets.Name | Should -Contain 'GitHub'
        }
    }

    Context 'When connecting to Azure DevOps' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
            Mock -CommandName Initialize-FabricGitConnection -MockWith {
                [pscustomobject]@{ requiredAction = 'None'; WorkspaceId = $WorkspaceId }
            }
            $workspaceId = [guid]::NewGuid()
            $adoParams = @{
                WorkspaceId      = $workspaceId
                GitProviderType  = 'AzureDevOps'
                OrganizationName = 'contoso'
                ProjectName      = 'Fabric'
                RepositoryName   = 'sales'
                BranchName       = 'main'
                Confirm          = $false
            }
        }

        It 'Should send Azure DevOps provider details with automatic credentials' {
            Connect-FabricGit @adoParams

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $Uri -eq "workspaces/$workspaceId/git/connect" -and
                $Method -eq 'Post' -and
                $b.gitProviderDetails.gitProviderType -eq 'AzureDevOps' -and
                $b.gitProviderDetails.organizationName -eq 'contoso' -and
                $b.gitProviderDetails.projectName -eq 'Fabric' -and
                $b.gitProviderDetails.repositoryName -eq 'sales' -and
                $b.gitProviderDetails.branchName -eq 'main' -and
                $b.gitProviderDetails.directoryName -eq '/' -and
                $null -eq $b.gitProviderDetails.ownerName -and
                $b.myGitCredentials.source -eq 'Automatic'
            }
        }

        It 'Should use a configured connection when ConnectionId is supplied' {
            $connectionId = [guid]::NewGuid()
            Connect-FabricGit @adoParams -ConnectionId $connectionId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $b.myGitCredentials.source -eq 'ConfiguredConnection' -and
                $b.myGitCredentials.connectionId -eq $connectionId.ToString()
            }
        }

        It 'Should not initialize without -Initialize and return nothing' {
            Connect-FabricGit @adoParams | Should -BeNullOrEmpty

            Should -Invoke -CommandName Initialize-FabricGitConnection -Times 0 -Exactly
        }

        It 'Should initialize with -Initialize and return its result' {
            $result = Connect-FabricGit @adoParams -Initialize -InitializationStrategy PreferWorkspace -NoWait

            $result.requiredAction | Should -Be 'None'
            Should -Invoke -CommandName Initialize-FabricGitConnection -Times 1 -Exactly -ParameterFilter {
                $WorkspaceId -eq $workspaceId -and $InitializationStrategy -eq 'PreferWorkspace' -and $NoWait
            }
        }

        It 'Should not call the API with -WhatIf' {
            $whatIfParams = $adoParams.Clone()
            $whatIfParams.Remove('Confirm')
            Connect-FabricGit @whatIfParams -Initialize -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
            Should -Invoke -CommandName Initialize-FabricGitConnection -Times 0 -Exactly
        }
    }

    Context 'When connecting to GitHub' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
            $workspaceId = [guid]::NewGuid()
            $connectionId = [guid]::NewGuid()
        }

        It 'Should send GitHub provider details' {
            Connect-FabricGit -WorkspaceId $workspaceId -GitProviderType GitHub -OwnerName 'contoso' -RepositoryName 'sales' -BranchName 'main' -DirectoryName '/ws' -ConnectionId $connectionId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly -ParameterFilter {
                $b = $Body | ConvertFrom-Json
                $b.gitProviderDetails.gitProviderType -eq 'GitHub' -and
                $b.gitProviderDetails.ownerName -eq 'contoso' -and
                $b.gitProviderDetails.directoryName -eq '/ws' -and
                $null -eq $b.gitProviderDetails.organizationName -and
                $b.myGitCredentials.source -eq 'ConfiguredConnection'
            }
        }

        It 'Should require ConnectionId for GitHub' {
            { Connect-FabricGit -WorkspaceId $workspaceId -GitProviderType GitHub -OwnerName 'contoso' -RepositoryName 'sales' -BranchName 'main' -Confirm:$false } |
                Should -Throw '*requires -ConnectionId*'
        }
    }

    Context 'When GitProviderType does not match the provider parameters' {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should throw for GitHub with Azure DevOps parameters' {
            { Connect-FabricGit -WorkspaceId ([guid]::NewGuid()) -GitProviderType GitHub -OrganizationName 'o' -ProjectName 'p' -RepositoryName 'r' -BranchName 'b' -ConnectionId ([guid]::NewGuid()) -Confirm:$false } |
                Should -Throw '*requires -OwnerName*'
        }

        It 'Should throw for AzureDevOps with GitHub parameters' {
            { Connect-FabricGit -WorkspaceId ([guid]::NewGuid()) -GitProviderType AzureDevOps -OwnerName 'o' -RepositoryName 'r' -BranchName 'b' -Confirm:$false } |
                Should -Throw '*requires -OrganizationName and -ProjectName*'
        }

        It 'Should not call the API' {
            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0 -Exactly
        }
    }
}
