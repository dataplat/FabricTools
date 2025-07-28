#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $expectedParams = @(
        "SubscriptionId"
        "ResourceGroupName"
        "CapacityName"
        "SkuName"
        "AdministrationMembers"
        "Tags"
        "NoWait"
        "WhatIf"
        "Confirm"
        "Verbose"
        "Debug"
        "ErrorAction"
        "WarningAction"
        "InformationAction"
        "ProgressAction"
        "ErrorVariable"
        "WarningVariable"
        "InformationVariable"
        "OutVariable"
        "OutBuffer"
        "PipelineVariable"
    )
)

Describe "Update-FabricCapacity" -Tag "UnitTests" {

    BeforeDiscovery {
        $command = Get-Command -Name Update-FabricCapacity
        $expected = $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Update-FabricCapacity
            $expected = $expectedParams
        }

        It "Has parameter: <_>" -ForEach $expected {
            $command | Should -HaveParameter $PSItem
        }

        It "Should have exactly the number of expected parameters $($expected.Count)" {
            $hasparms = $command.Parameters.Values.Name
            Compare-Object -ReferenceObject $expected -DifferenceObject $hasparms | Should -BeNullOrEmpty
        }
    }

    Context "Parameter validation rules" {
        BeforeAll {
            $command = Get-Command -Name Update-FabricCapacity
        }

        It "SubscriptionId should be mandatory" {
            $command.Parameters['SubscriptionId'].Attributes.Mandatory | Should -Be $true
        }

        It "ResourceGroupName should be mandatory" {
            $command.Parameters['ResourceGroupName'].Attributes.Mandatory | Should -Be $true
        }

        It "CapacityName should be mandatory" {
            $command.Parameters['CapacityName'].Attributes.Mandatory | Should -Be $true
        }

        It "SkuName should be mandatory" {
            $command.Parameters['SkuName'].Attributes.Mandatory | Should -Be $true
        }

        It "AdministrationMembers should be mandatory" {
            $command.Parameters['AdministrationMembers'].Attributes.Mandatory | Should -Be $true
        }

        It "Tags should not be mandatory" {
            $command.Parameters['Tags'].Attributes.Mandatory | Should -Be $false
        }

        It "NoWait should not be mandatory" {
            $command.Parameters['NoWait'].Attributes.Mandatory | Should -Be $false
        }

        It "SubscriptionId should be of type Guid" {
            $command.Parameters['SubscriptionId'].ParameterType.Name | Should -Be "Guid"
        }

        It "ResourceGroupName should be of type String" {
            $command.Parameters['ResourceGroupName'].ParameterType.Name | Should -Be "String"
        }

        It "CapacityName should be of type String" {
            $command.Parameters['CapacityName'].ParameterType.Name | Should -Be "String"
        }

        It "SkuName should be of type String" {
            $command.Parameters['SkuName'].ParameterType.Name | Should -Be "String"
        }

        It "AdministrationMembers should be of type String array" {
            $command.Parameters['AdministrationMembers'].ParameterType.Name | Should -Be "String[]"
        }

        It "Tags should be of type Hashtable" {
            $command.Parameters['Tags'].ParameterType.Name | Should -Be "Hashtable"
        }

        It "NoWait should be of type SwitchParameter" {
            $command.Parameters['NoWait'].ParameterType.Name | Should -Be "SwitchParameter"
        }
    }

    Context "Parameter validation attributes" {
        BeforeAll {
            $command = Get-Command -Name Update-FabricCapacity
        }

        It "ResourceGroupName should have ValidateLength attribute with max length 90" {
            $validateLengthAttr = $command.Parameters['ResourceGroupName'].Attributes | Where-Object { $_.GetType().Name -eq "ValidateLengthAttribute" }
            $validateLengthAttr | Should -Not -BeNullOrEmpty
            $validateLengthAttr.MaxLength | Should -Be 90
        }

        It "CapacityName should have ValidateLength attribute with min length 3 and max length 63" {
            $validateLengthAttr = $command.Parameters['CapacityName'].Attributes | Where-Object { $_.GetType().Name -eq "ValidateLengthAttribute" }
            $validateLengthAttr | Should -Not -BeNullOrEmpty
            $validateLengthAttr.MinLength | Should -Be 3
            $validateLengthAttr.MaxLength | Should -Be 63
        }

        It "CapacityName should have ValidatePattern attribute" {
            $validatePatternAttr = $command.Parameters['CapacityName'].Attributes | Where-Object { $_.GetType().Name -eq "ValidatePatternAttribute" }
            $validatePatternAttr | Should -Not -BeNullOrEmpty
        }
    }
}
