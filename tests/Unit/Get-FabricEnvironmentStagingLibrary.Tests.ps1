#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricEnvironmentStagingLibrary'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricEnvironmentStagingLibrary
}

Describe "Get-FabricEnvironmentStagingLibrary" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'EnvironmentId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful staging library retrieval" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    customLibraries = @(
                        [pscustomobject]@{ name = 'TestStagingLibrary'; version = '1.0.0' }
                    )
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should return staging libraries when WorkspaceId and EnvironmentId are provided' {
            $result = Get-FabricEnvironmentStagingLibrary -WorkspaceId (New-Guid) -EnvironmentId (New-Guid)

            $result | Should -Not -BeNullOrEmpty

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }
}
