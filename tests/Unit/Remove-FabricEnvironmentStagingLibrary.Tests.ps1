#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Remove-FabricEnvironmentStagingLibrary'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Remove-FabricEnvironmentStagingLibrary
}

Describe "Remove-FabricEnvironmentStagingLibrary" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'EnvironmentId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'LibraryName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful staging library removal" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should remove staging library with valid parameters' {
            { Remove-FabricEnvironmentStagingLibrary -WorkspaceId (New-Guid) -EnvironmentId (New-Guid) -LibraryName 'TestLibrary' -Confirm:$false } | Should -Not -Throw

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle error gracefully and write error message' {
            {
                Remove-FabricEnvironmentStagingLibrary -WorkspaceId (New-Guid) -EnvironmentId (New-Guid) -LibraryName 'TestLibrary' -Confirm:$false
            } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to delete environment*"
            }
        }
    }
}
