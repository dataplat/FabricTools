#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCapacityState'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricCapacityState" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricCapacityState
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'subscriptionID'; Mandatory = $true }
            @{ Name = 'resourcegroup'; Mandatory = $true }
            @{ Name = 'capacity'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting capacity state successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-PSFConfigValue -MockWith {
                return 'https://management.azure.com'
            }
            Mock -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{
                    name = 'TestCapacity'
                    properties = @{ state = 'Active' }
                }
            }
        }

        It 'Should call Invoke-RestMethod with the correct parameters' {
            $mockSubscriptionId = [guid]::NewGuid()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            Get-FabricCapacityState -subscriptionID $mockSubscriptionId -resourcegroup $mockResourceGroup -capacity $mockCapacity

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like "*subscriptions/*/resourceGroups/*/providers/Microsoft.Fabric/capacities/*"
            }
        }

        It 'Should return the capacity state' {
            $mockSubscriptionId = [guid]::NewGuid()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            $result = Get-FabricCapacityState -subscriptionID $mockSubscriptionId -resourcegroup $mockResourceGroup -capacity $mockCapacity

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-PSFConfigValue -MockWith {
                return 'https://management.azure.com'
            }
            Mock -CommandName Invoke-RestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should throw an exception when API call fails' {
            $mockSubscriptionId = [guid]::NewGuid()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            { Get-FabricCapacityState -subscriptionID $mockSubscriptionId -resourcegroup $mockResourceGroup -capacity $mockCapacity } | Should -Throw -ExpectedMessage '*API connection failed*'
        }
    }
}
