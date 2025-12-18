#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Resume-FabricCapacity'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Resume-FabricCapacity" -Tag "UnitTests" {

    BeforeAll {
        $command = Get-Command -Name Resume-FabricCapacity
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

        It 'Should support ShouldProcess' {
            $command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context 'When resuming capacity successfully (202)' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Invoke-RestMethod -MockWith {
                return [pscustomobject]@{
                    status = 'Succeeded'
                }
            }
        }

        It 'Should call Invoke-RestMethod with the correct parameters' {
            $mockSubscriptionId = [guid]::NewGuid().ToString()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            Resume-FabricCapacity -subscriptionID $mockSubscriptionId -resourcegroup $mockResourceGroup -capacity $mockCapacity -Confirm:$false

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -like "*subscriptions/*/resourceGroups/*/providers/Microsoft.Fabric/capacities/*/resume*" -and
                $Method -eq 'Post'
            }
        }

        It 'Should complete without error' {
            $mockSubscriptionId = [guid]::NewGuid().ToString()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            { Resume-FabricCapacity -subscriptionID $mockSubscriptionId -resourcegroup $mockResourceGroup -capacity $mockCapacity -Confirm:$false } | Should -Not -Throw
        }
    }

    Context 'When an exception is thrown' {
        BeforeAll {
            Mock -CommandName Confirm-TokenState -MockWith { }
            Mock -CommandName Invoke-RestMethod -MockWith {
                throw 'API connection failed'
            }
        }

        It 'Should throw when API call fails' {
            $mockSubscriptionId = [guid]::NewGuid().ToString()
            $mockResourceGroup = 'TestResourceGroup'
            $mockCapacity = 'TestCapacity'

            { Resume-FabricCapacity -subscriptionID $mockSubscriptionId -resourcegroup $mockResourceGroup -capacity $mockCapacity -Confirm:$false } | Should -Throw
        }
    }
}
