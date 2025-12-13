#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCapacity'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricCapacity" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricCapacity
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'capacityId'; Mandatory = $false }
            @{ Name = 'capacityName'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When retrieving capacities successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                return [pscustomobject]@{
                    Value = @(
                        [pscustomobject]@{
                            Id = [guid]::NewGuid()
                            DisplayName = 'TestCapacity1'
                            Sku = 'F64'
                        },
                        [pscustomobject]@{
                            Id = [guid]::NewGuid()
                            DisplayName = 'TestCapacity2'
                            Sku = 'F128'
                        }
                    )
                }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            Get-FabricCapacity

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*capacities*" -and
                $Method -eq 'Get'
            }
        }

        It 'Should return all capacities when no filter is provided' {
            $result = Get-FabricCapacity

            $result | Should -Not -BeNullOrEmpty
            $result.Count | Should -Be 2
        }
    }

    Context 'When both capacityId and capacityName are provided' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
        }

        It 'Should write an error message' {
            $mockCapacityId = [guid]::NewGuid()

            Get-FabricCapacity -capacityId $mockCapacityId -capacityName 'TestCapacity'

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error' -and $Message -like "*Both*"
            }
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

        It 'Should handle exceptions gracefully' {
            { Get-FabricCapacity } | Should -Not -Throw

            Should -Invoke -CommandName Write-Message -ParameterFilter {
                $Level -eq 'Error'
            }
        }
    }
}
