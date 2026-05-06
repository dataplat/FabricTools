#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'New-FabricCopyJob'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name New-FabricCopyJob
}

Describe "New-FabricCopyJob" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'CopyJobName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'CopyJobDescription'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'CopyJobPathDefinition'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'CopyJobPathPlatformDefinition'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful copy job creation" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 201
                }
                return [pscustomobject]@{
                    id = 'copyjob-guid'
                    displayName = 'TestCopyJob'
                    type = 'CopyJob'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should create copy job with valid parameters' {
            $result = New-FabricCopyJob -WorkspaceId (New-Guid) -CopyJobName 'TestCopyJob' -Confirm:$false

            $result | Should -Not -BeNullOrEmpty
            $result.displayName | Should -Be 'TestCopyJob'

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { } -ParameterFilter { $Level -eq 'Error' }
        }

        It 'Should log error when API call fails' {
            New-FabricCopyJob -WorkspaceId (New-Guid) -CopyJobName 'TestCopyJob' -Confirm:$false

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' } -Times 1 -Exactly
        }
    }
}
