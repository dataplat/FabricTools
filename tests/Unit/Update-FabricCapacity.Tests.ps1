#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Update-FabricCapacity'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Update-FabricCapacity
}

Describe "Update-FabricCapacity" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'SubscriptionId'; ExpectedParameterType = 'guid'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'ResourceGroupName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'CapacityName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'SkuName'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Location'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'AdministrationMembers'; ExpectedParameterType = 'string[]'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Tags'; ExpectedParameterType = 'hashtable'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'NoWait'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }

        It 'Should support ShouldProcess' {
            $Command.Parameters.ContainsKey('WhatIf') | Should -BeTrue
            $Command.Parameters.ContainsKey('Confirm') | Should -BeTrue
        }
    }

    Context "Parameter validation attributes" {
        It "ResourceGroupName should have ValidateLength attribute with max length 90" {
            $validateLengthAttr = $Command.Parameters['ResourceGroupName'].Attributes | Where-Object { $_.GetType().Name -eq "ValidateLengthAttribute" }
            $validateLengthAttr | Should -Not -BeNullOrEmpty
            $validateLengthAttr.MaxLength | Should -Be 90
        }

        It "CapacityName should have ValidateLength attribute with min length 3 and max length 63" {
            $validateLengthAttr = $Command.Parameters['CapacityName'].Attributes | Where-Object { $_.GetType().Name -eq "ValidateLengthAttribute" }
            $validateLengthAttr | Should -Not -BeNullOrEmpty
            $validateLengthAttr.MinLength | Should -Be 3
            $validateLengthAttr.MaxLength | Should -Be 63
        }

        It "CapacityName should have ValidatePattern attribute" {
            $validatePatternAttr = $Command.Parameters['CapacityName'].Attributes | Where-Object { $_.GetType().Name -eq "ValidatePatternAttribute" }
            $validatePatternAttr | Should -Not -BeNullOrEmpty
        }
    }

    Context "Successful capacity update" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 200
                }
                return [pscustomobject]@{
                    id = 'capacity-guid'
                    name = 'UpdatedCapacity'
                    sku = [pscustomobject]@{ name = 'F2' }
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should update capacity with valid parameters' {
            $result = Update-FabricCapacity -SubscriptionId (New-Guid) -ResourceGroupName 'TestRG' -CapacityName 'testcapacity' -SkuName 'F2' -Location 'uksouth' -AdministrationMembers @('user@domain.com') -Confirm:$false

            Should -Invoke -CommandName Invoke-FabricRestMethod -Times 1 -Exactly
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-FabricRestMethod -MockWith {
                InModuleScope -ModuleName 'FabricTools' {
                    $script:statusCode = 400
                }
                throw "API Error"
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should throw an error when API call fails' {
            {
                Update-FabricCapacity -SubscriptionId (New-Guid) -ResourceGroupName 'TestRG' -CapacityName 'testcapacity' -SkuName 'F2' -Location 'uksouth' -AdministrationMembers @('user@domain.com') -Confirm:$false
            } | Should -Throw
        }
    }
}
