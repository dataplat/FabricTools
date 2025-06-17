#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

InModuleScope FabricTools {

param(
    $ModuleName = "FabricTools",
    $expectedParams = @(
        "Response"
        "Name"
        "TypeName"
        "NoWait"
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

Describe "Test-FabricApiResponse" -Tag "UnitTests" {

    BeforeDiscovery {
        ipmo ".\output\module\FabricTools\0.0.1\FabricTools.psd1"

        $command = Get-Command -Name Test-FabricApiResponse
        $script:expected = $expectedParams
    }

    Context "Parameter validation" {
        BeforeAll {
            $command = Get-Command -Name Test-FabricApiResponse
            $expected = $expectedParams
        }

        It "Has parameter: <_>" -ForEach $expected {
            $command | Should -HaveParameter $PSItem
        }

        It "Should have exactly the number of expected parameters $($expected.Count)" {
            $hasparms = $command.Parameters.Values.Name
            Compare-Object -ReferenceObject $script:expected -DifferenceObject $hasparms | Should -BeNullOrEmpty
        }
    }
}


Describe "Test-FabricApiResponse - StatusCode Handling" -Tag "UnitTests" {

    BeforeAll {
        # Generate a random GUID for x-ms-operation-id
        $script:responseHeader = @{ "x-ms-operation-id" = [guid]::NewGuid().ToString() }
        $script:response = @{ "foo" = "bar" }
    }

    BeforeEach {
        # Always mock these functions
        Mock -CommandName Get-FabricLongRunningOperation -MockWith {
            return @{ "status" = "Succeeded" }
        }
        Mock -CommandName Get-FabricLongRunningOperationResult -MockWith {
            return "Completed"
        }
        Mock -CommandName Write-Message -MockWith { }
    }

    It "Returns `$null when statusCode is 200" {
        $script:statusCode = 200
        $result = Test-FabricApiResponse -Response $script:response
        $result | Should -Be $null
    }

    It "Returns response when statusCode is 201" {
        $script:statusCode = 201
        $result = Test-FabricApiResponse -Response $script:response
        $result | Should -Be $script:response
    }

    It "Returns operation result when statusCode is 202 and operation succeeds" {
        $script:statusCode = 202
        $expectedResult = "Completed"
        $result = Test-FabricApiResponse -Response $script:response
        $result | Should -Be $expectedResult
        Should -Invoke Get-FabricLongRunningOperation -Exactly 1
        Should -Invoke Get-FabricLongRunningOperationResult -Exactly 1
    }

    It "Returns responseHeader when statusCode is 202 and -NoWait is specified" {
        $script:statusCode = 202
        $result = Test-FabricApiResponse -Response $script:response -NoWait
        $result | Should -Be $script:responseHeader
    }

    It "Throws when statusCode is not 200, 201, or 202" {
        $script:statusCode = 400
        { Test-FabricApiResponse -Response $script:response -ErrorAction Stop } | Should -Throw
    }
}

}
