#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}
param(
    $ModuleName = "FabricTools",
    $expectedParams = @(
    )
)

Describe "Get-FabricAPIclusterURI" -Tag "UnitTests" {

    BeforeDiscovery {
        $command = Get-Command -Name Get-FabricAPIclusterURI
        $expected = $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Get-FabricAPIclusterURI
            $expected = $expectedParams
        }

       #  It "Has parameter: <_>" -ForEach $expected {
       #      $command | Should -HaveParameter $PSItem
       #  }
#
       #  It "Should have exactly the number of expected parameters $($expected.Count)# " {
       #      $hasparms = $command.Parameters.Values.Name
       #      #$hasparms.Count | Should -BeExactly $expected.Count
       #      Compare-Object -ReferenceObject $expected -DifferenceObject $hasparms | # Should -BeNullOrEmpty
       #  }
    }
}
