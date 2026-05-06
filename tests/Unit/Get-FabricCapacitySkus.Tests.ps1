#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCapacitySkus'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricCapacitySkus" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricCapacitySkus
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'subscriptionID'; Mandatory = $true }
            @{ Name = 'ResourceGroupName'; Mandatory = $true }
            @{ Name = 'capacity'; Mandatory = $true }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting capacity SKUs successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-PSFConfigValue -MockWith {
                if ($args[0] -eq 'FabricTools.AzureApi.BaseUrl') {
                    return 'https://management.azure.com'
                }
                if ($args[0] -eq 'FabricTools.AzureSession.Headers') {
                    return @{ Authorization = 'Bearer token' }
                }
            }
            Mock -CommandName Invoke-RestMethod -MockWith {
                return @{
                    value = @(
                        [pscustomobject]@{ name = 'F2'; tier = 'Fabric' }
                        [pscustomobject]@{ name = 'F4'; tier = 'Fabric' }
                        [pscustomobject]@{ name = 'F8'; tier = 'Fabric' }
                    )
                }
            }
        }

        It 'Should call Invoke-RestMethod with the correct parameters' {
            $mockSubscriptionId = [guid]::NewGuid()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            Get-FabricCapacitySkus -subscriptionID $mockSubscriptionId -ResourceGroupName $mockResourceGroup -capacity $mockCapacity

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like "*subscriptions/*/resourceGroups/*/providers/Microsoft.Fabric/capacities/*/skus*"
            }
        }

        It 'Should return the list of SKUs' {
            $mockSubscriptionId = [guid]::NewGuid()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            $result = Get-FabricCapacitySkus -subscriptionID $mockSubscriptionId -ResourceGroupName $mockResourceGroup -capacity $mockCapacity

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-PSFConfigValue -MockWith {
                if ($args[0] -eq 'FabricTools.AzureApi.BaseUrl') {
                    return 'https://management.azure.com'
                }
                if ($args[0] -eq 'FabricTools.AzureSession.Headers') {
                    return @{ Authorization = 'Bearer token' }
                }
            }
            Mock -CommandName Invoke-RestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should throw an exception when API call fails' {
            $mockSubscriptionId = [guid]::NewGuid()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            { Get-FabricCapacitySkus -subscriptionID $mockSubscriptionId -ResourceGroupName $mockResourceGroup -capacity $mockCapacity } | Should -Throw -ExpectedMessage '*API connection failed*'
        }
    }
}
