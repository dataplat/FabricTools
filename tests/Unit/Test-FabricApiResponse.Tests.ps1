#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

InModuleScope FabricTools {

Describe "Test-FabricApiResponse" -Tag "UnitTests" {

    BeforeAll {
        $script:Command = Get-Command -Name Test-FabricApiResponse
    }

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'Response'; ExpectedParameterType = 'Object'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ResponseHeader'; ExpectedParameterType = 'Object'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'StatusCode'; ExpectedParameterType = 'Object'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Operation'; ExpectedParameterType = 'Object'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ObjectIdOrName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'TypeName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'SuccessMessage'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'NoWait'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Timeout'; ExpectedParameterType = 'int'; Mandatory = 'False' }
        ) {
            $script:Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }
}


Describe "Test-FabricApiResponse - StatusCode Handling" -Tag "UnitTests" {

    BeforeAll {
        # Generate a random GUID for x-ms-operation-id
        $script:responseHeader = @{
            "x-ms-operation-id" = [guid]::NewGuid().ToString()
            "Location" = "https://api.fabric.microsoft.com/v1/operations/$([guid]::NewGuid().ToString())"
            "Retry-After" = 30
        }
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

    It "Returns `$null when statusCode is 200 and Operation is 'Get'" {
        $script:statusCode = 200
        $result = Test-FabricApiResponse -Response $script:response -ResponseHeader $script:responseHeader -StatusCode $script:statusCode -Operation "Get"
        $result | Should -Be $script:response
    }

    It "Returns response when statusCode is 201" {
        $script:statusCode = 201
        $result = Test-FabricApiResponse -Response $script:response -ResponseHeader $script:responseHeader -StatusCode $script:statusCode
        $result | Should -Be $script:response
    }

    It "Returns operation result when statusCode is 202 and operation succeeds" {
        $script:statusCode = 202
        $expectedResult = "Completed"
        $result = Test-FabricApiResponse -Response $script:response -ResponseHeader $script:responseHeader -StatusCode $script:statusCode -Operation "Create" -ObjectIdOrName "TestObject" -TypeName "TestType"
        $result | Should -Be $expectedResult
        Should -Invoke Get-FabricLongRunningOperation -Exactly 1
        Should -Invoke Get-FabricLongRunningOperationResult -Exactly 1
    }

    It "Passes the timeout to long-running operation polling" {
        $script:statusCode = 202
        Test-FabricApiResponse -Response $script:response -ResponseHeader $script:responseHeader -StatusCode $script:statusCode -Timeout 3 | Out-Null

        Should -Invoke Get-FabricLongRunningOperation -Exactly 1 -ParameterFilter {
            $Timeout -eq 3
        }
    }

    It "Uses scalar values from enumerable 202 response headers" {
        $headers = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.IEnumerable[string]]]::new()
        $headers.Add('x-ms-operation-id', [string[]]@('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222'))
        $headers.Add('Location', [string[]]@('https://api.fabric.microsoft.com/operations/123', 'ignored-location'))
        $headers.Add('Retry-After', [string[]]@('10', 'ignored-retry'))

        Test-FabricApiResponse -ResponseHeader $headers -StatusCode 202 -Operation 'New' -ObjectIdOrName 'TestObject' -TypeName 'TestType' | Should -Be 'Completed'

        Should -Invoke Get-FabricLongRunningOperation -Exactly 1 -ParameterFilter {
            $operationId -eq [guid]'11111111-1111-1111-1111-111111111111' -and
            $location -eq 'https://api.fabric.microsoft.com/operations/123' -and
            $retryAfter -eq '10'
        }
    }

    It "Returns PSCustomObject with 3 properties when statusCode is 202 and -NoWait is specified" {
        $script:statusCode = 202
        $result = Test-FabricApiResponse -Response $script:response -ResponseHeader $script:responseHeader -StatusCode $script:statusCode $script:responseHeader -NoWait

        $expected = [PSCustomObject]@{
            Location    = $script:responseHeader.Location
            RetryAfter  = $script:responseHeader.'Retry-After'
            OperationId = $script:responseHeader.'x-ms-operation-id'
        }
        $result.Location | Should -Be $expected.Location
        $result.RetryAfter | Should -Be $expected.RetryAfter
        $result.OperationId | Should -Be $expected.OperationId
    }

    It "Throws when statusCode is not 200, 201, or 202" {
        $script:statusCode = 400
        { Test-FabricApiResponse -Response $script:response -ResponseHeader $script:responseHeader -StatusCode $script:statusCode -ErrorAction Stop } | Should -Throw
    }
}

}
