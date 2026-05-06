#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricSparkSettings'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricSparkSettings
}

Describe "Update-FabricSparkSettings" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'automaticLogEnabled'; ExpectedParameterType = 'bool'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'notebookInteractiveRunEnabled'; ExpectedParameterType = 'bool'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'customizeComputeEnabled'; ExpectedParameterType = 'bool'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'defaultPoolName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'defaultPoolType'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'starterPoolMaxNode'; ExpectedParameterType = 'int'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'starterPoolMaxExecutors'; ExpectedParameterType = 'int'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'EnvironmentName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'EnvironmentRuntimeVersion'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Successful Spark Settings update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return $null
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should update Spark Settings with valid parameters' {
            { Update-FabricSparkSettings -WorkspaceId (New-Guid) -Confirm:$false } | Should -Not -Throw

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
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle error when API call fails' {
            {
                Update-FabricSparkSettings -WorkspaceId (New-Guid) -Confirm:$false
            } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter { $Level -eq 'Error' } -Times 1 -Exactly -Scope It
        }
    }
}
