#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricCapacities'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricCapacities" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Get-FabricCapacities
    }

    Context 'Command definition' {
        It 'Should have a command definition' {
            $command | Should -Not -BeNullOrEmpty
        }

        It 'Should have the expected parameter: <Name>' -ForEach @(
            @{ Name = 'subscriptionID'; Mandatory = $false }
        ) {
            $command | Should -HaveParameter $Name -Mandatory:$Mandatory
        }
    }

    Context 'When getting capacities successfully' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Set-AzContext -MockWith { }
            Mock -CommandName Get-AzResourceGroup -MockWith {
                return @(
                    [pscustomobject]@{ ResourceGroupName = 'rg1' }
                    [pscustomobject]@{ ResourceGroupName = 'rg2' }
                )
            }
            Mock -CommandName Get-AzResource -MockWith {
                return [pscustomobject]@{ Name = 'Capacity1'; ResourceType = 'Microsoft.Fabric/capacities' }
            }
        }

        It 'Should call Get-AzResource with the correct resource type' {
            $mockSubscriptionId = [guid]::NewGuid()

            Get-FabricCapacities -subscriptionID $mockSubscriptionId

            Should -Invoke -CommandName Get-AzResource -ParameterFilter {
                $ResourceType -eq 'Microsoft.Fabric/capacities'
            }
        }

        It 'Should return the list of capacities' {
            $mockSubscriptionId = [guid]::NewGuid()

            $result = Get-FabricCapacities -subscriptionID $mockSubscriptionId

            $result | Should -Not -BeNullOrEmpty
        }
    }

    Context 'When no subscription ID is provided' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-AzSubscription -MockWith {
                return @(
                    [pscustomobject]@{ Id = [guid]::NewGuid().ToString() }
                )
            }
            Mock -CommandName Set-AzContext -MockWith { }
            Mock -CommandName Get-AzResourceGroup -MockWith {
                return @(
                    [pscustomobject]@{ ResourceGroupName = 'rg1' }
                )
            }
            Mock -CommandName Get-AzResource -MockWith {
                return [pscustomobject]@{ Name = 'Capacity1'; ResourceType = 'Microsoft.Fabric/capacities' }
            }
        }

        It 'Should get all subscriptions when no subscription ID is provided' {
            Get-FabricCapacities

            Should -Invoke -CommandName Get-AzSubscription -Times 1
        }
    }
}
