#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricEventhouse'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricEventhouse" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricEventhouse
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'WorkspaceId'; Mandatory = $true }
            @{ Name = 'EventhouseId'; Mandatory = $false }
            @{ Name = 'EventhouseName'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When retrieving eventhouses successfully (200)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return @(
                    [pscustomobject]@{
                        Id = [guid]::NewGuid()
                        DisplayName = 'TestEventhouse1'
                    },
                    [pscustomobject]@{
                        Id = [guid]::NewGuid()
                        DisplayName = 'TestEventhouse2'
                    }
                )
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockWorkspaceId = [guid]::NewGuid()

            Get-FabricEventhouse -WorkspaceId $mockWorkspaceId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*workspaces/*/eventhouses*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return all eventhouses when no filter is provided' {
            $mockWorkspaceId = [guid]::NewGuid()

            $result = Get-FabricEventhouse -WorkspaceId $mockWorkspaceId

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When both EventhouseId and EventhouseName are provided' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should write an error message' {
            $mockWorkspaceId = [guid]::NewGuid()
            $mockEventhouseId = [guid]::NewGuid()

            Get-FabricEventhouse -WorkspaceId $mockWorkspaceId -EventhouseId $mockEventhouseId -EventhouseName 'TestEventhouse'

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Both*"
            }
        }
    }
}
