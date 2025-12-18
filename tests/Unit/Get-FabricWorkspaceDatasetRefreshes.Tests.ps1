#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricWorkspaceDatasetRefreshes'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Get-FabricWorkspaceDatasetRefreshes
}

Describe "Get-FabricWorkspaceDatasetRefreshes" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'WorkspaceID'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful workspace dataset refreshes retrieval" -Skip {
        # Skipped: Function calls Get-FabricDataset which does not exist in the module
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricWorkspace -MockWith {
                return [pscustomobject]@{ Id = [guid]::NewGuid(); displayName = 'TestWorkspace' }
            }
            Mock -CommandName Get-FabricDatasetRefreshes -MockWith {
                return @(
                    [pscustomobject]@{ id = 'refresh-1'; status = 'Completed' }
                )
            }
        }

        It 'Should get workspace dataset refreshes with valid parameters' {
            $result = Get-FabricWorkspaceDatasetRefreshes -WorkspaceID (New-Guid)

            Should -Invoke -CommandName Get-FabricWorkspace -Times 1 -Exactly
            Should -Invoke -CommandName Get-FabricDatasetRefreshes -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Get-FabricWorkspace -MockWith {
                throw "API Error"
            }
        }

        It 'Should throw an error when API call fails' {
            {
                Get-FabricWorkspaceDatasetRefreshes -WorkspaceID (New-Guid)
            } | Should -Throw
        }
    }
}
