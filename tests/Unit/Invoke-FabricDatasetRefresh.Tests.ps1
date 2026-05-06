#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Invoke-FabricDatasetRefresh'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Invoke-FabricDatasetRefresh
}

Describe "Invoke-FabricDatasetRefresh" -Tag "UnitTests" {

    Context 'Command definition' {
        It 'Should have a command definition' {
            $Command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'DatasetId';          Mandatory = $true  }
            @{ Name = 'WorkspaceId';        Mandatory = $false }
            @{ Name = 'NotifyOption';       Mandatory = $false }
            @{ Name = 'Type';               Mandatory = $false }
            @{ Name = 'CommitMode';         Mandatory = $false }
            @{ Name = 'MaxParallelism';     Mandatory = $false }
            @{ Name = 'RetryCount';         Mandatory = $false }
            @{ Name = 'Timeout';            Mandatory = $false }
            @{ Name = 'EffectiveDate';      Mandatory = $false }
            @{ Name = 'ApplyRefreshPolicy'; Mandatory = $false }
            @{ Name = 'Objects';            Mandatory = $false }
        ) {
            $Command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }

        It 'Should have GroupId as an alias for WorkspaceId' {
            $Command.Parameters['WorkspaceId'].Aliases | Should -Contain 'GroupId'
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf')   | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm')  | Should -BeTrue
        }

        It 'Should have a ValidateSet on NotifyOption' {
            $validateSet = $Command.Parameters['NotifyOption'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $validateSet.ValidValues | Should -Contain 'NoNotification'
            $validateSet.ValidValues | Should -Contain 'MailOnFailure'
            $validateSet.ValidValues | Should -Contain 'MailOnCompletion'
        }

        It 'Should have a ValidateSet on Type' {
            $validateSet = $Command.Parameters['Type'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $validateSet.ValidValues | Should -Contain 'Full'
            $validateSet.ValidValues | Should -Contain 'Automatic'
            $validateSet.ValidValues | Should -Contain 'DataOnly'
        }

        It 'Should have a ValidateSet on CommitMode' {
            $validateSet = $Command.Parameters['CommitMode'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] }
            $validateSet.ValidValues | Should -Contain 'Transactional'
            $validateSet.ValidValues | Should -Contain 'PartialBatch'
        }
    }

    Context 'When refreshing a dataset in My Workspace (no WorkspaceId)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should call Invoke-FabricRestMethod with the My Workspace URI' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "datasets/$mockDatasetId/refreshes" -and
                $Method -eq 'Post' -and
                $PowerBIApi -eq $true
            }
        }

        It 'Should include notifyOption in the request body defaulting to NoNotification' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $parsed.notifyOption -eq 'NoNotification'
            }
        }
    }

    Context 'When refreshing a dataset in a specific workspace (WorkspaceId provided)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should call Invoke-FabricRestMethod with the group URI' {
            $mockDatasetId   = [guid]::NewGuid()
            $mockWorkspaceId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -WorkspaceId $mockWorkspaceId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "groups/$mockWorkspaceId/datasets/$mockDatasetId/refreshes" -and
                $Method -eq 'Post'
            }
        }

        It 'Should also accept GroupId alias for WorkspaceId' {
            $mockDatasetId   = [guid]::NewGuid()
            $mockWorkspaceId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -GroupId $mockWorkspaceId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq "groups/$mockWorkspaceId/datasets/$mockDatasetId/refreshes"
            }
        }
    }

    Context 'When NotifyOption is explicitly specified' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should include the specified NotifyOption in the body' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -NotifyOption MailOnFailure -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $parsed.notifyOption -eq 'MailOnFailure'
            }
        }
    }

    Context 'When enhanced refresh parameters are provided' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should include Type in the body when specified' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -Type Full -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $parsed.type -eq 'Full'
            }
        }

        It 'Should include CommitMode in the body when specified' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -CommitMode PartialBatch -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $parsed.commitMode -eq 'PartialBatch'
            }
        }

        It 'Should include MaxParallelism in the body when specified' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -MaxParallelism 4 -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $parsed.maxParallelism -eq 4
            }
        }

        It 'Should include RetryCount in the body when specified' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -RetryCount 2 -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $parsed.retryCount -eq 2
            }
        }

        It 'Should include Timeout in the body when specified' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -Timeout '02:00:00' -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $parsed.timeout -eq '02:00:00'
            }
        }

        It 'Should not include optional fields in the body when not specified' {
            $mockDatasetId = [guid]::NewGuid()

            Invoke-FabricDatasetRefresh -DatasetId $mockDatasetId -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $parsed = $Body | ConvertFrom-Json
                $null -eq $parsed.type -and
                $null -eq $parsed.commitMode -and
                $null -eq $parsed.maxParallelism
            }
        }
    }

    Context 'When -WhatIf is specified' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith { }
        }

        It 'Should not call Invoke-FabricRestMethod' {
            Invoke-FabricDatasetRefresh -DatasetId ([guid]::NewGuid()) -WhatIf

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 0
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should handle exceptions gracefully without re-throwing' {
            { Invoke-FabricDatasetRefresh -DatasetId ([guid]::NewGuid()) -Confirm:$false } | Should -Not -Throw
        }

        It 'Should log an error message' {
            Invoke-FabricDatasetRefresh -DatasetId ([guid]::NewGuid()) -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like '*Failed to trigger refresh*'
            }
        }
    }
}
