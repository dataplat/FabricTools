#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCopyJob'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricCopyJob
}

Describe "Get-FabricCopyJob" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'CopyJobId'; ExpectedParameterType = 'guid'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'CopyJob'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful copy job retrieval" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    value = @(
                        [pscustomobject]@{ id = 'copyjob-guid'; displayName = 'TestCopyJob'; type = 'CopyJob' }
                    )
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should return copy jobs when WorkspaceId is provided' {
            $result = Get-FabricCopyJob -WorkspaceId (New-Guid)

            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should handle errors gracefully and call Write-Message with Error level' {
            Get-FabricCopyJob -WorkspaceId (New-Guid)
            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Failed to retrieve CopyJob*"
            }
        }
    }
}
