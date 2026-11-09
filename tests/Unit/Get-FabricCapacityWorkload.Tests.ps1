#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCapacityWorkload'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricCapacityWorkload" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricCapacityWorkload
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'capacityID'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting capacity workloads successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            # Invoke-FabricRestMethod (ExtractValue = 'True') returns the items of the 'value' array
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                [pscustomobject]@{ name = 'Lakehouse'; state = 'Enabled'; maxMemoryPercentageSetByUser = 100 }
                [pscustomobject]@{ name = 'Warehouse'; state = 'Enabled'; maxMemoryPercentageSetByUser = 100 }
            }
        }

        It 'Should call Invoke-FabricRestMethod with the correct parameters' {
            $mockCapacityId = [guid]::NewGuid()

            Get-FabricCapacityWorkload -capacityID $mockCapacityId

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -like "*capacities/*/Workloads*" -and
                $ApiType -eq 'PowerBI' -and
                $ExtractValue -eq 'True'
            }
        }

        It 'Should return the list of workloads' {
            $mockCapacityId = [guid]::NewGuid()

            $result = @(Get-FabricCapacityWorkload -capacityID $mockCapacityId)

            $result.Count | Should -Be 2
            $result[1].name | Should -Be 'Warehouse'
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

        It 'Should throw an exception when API call fails' {
            $mockCapacityId = [guid]::NewGuid()

            { Get-FabricCapacityWorkload -capacityID $mockCapacityId } | Should -Throw -ExpectedMessage '*API connection failed*'
        }
    }
}
