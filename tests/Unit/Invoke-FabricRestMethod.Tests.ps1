#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Invoke-FabricRestMethod'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Invoke-FabricRestMethod
}

Describe "Invoke-FabricRestMethod" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'Uri'; ExpectedParameterType = 'string'; Mandatory = 'True' }
            @{ ExpectedParameterName = 'Method'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Body'; ExpectedParameterType = 'object'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'TestTokenExpired'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'PowerBIApi'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ApiType'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'NoWait'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'Timeout'; ExpectedParameterType = 'int'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'HandleResponse'; ExpectedParameterType = 'switch'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ExtractValue'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'TypeName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'ObjectIdOrName'; ExpectedParameterType = 'string'; Mandatory = 'False' }
            @{ ExpectedParameterName = 'SuccessMessage'; ExpectedParameterType = 'string'; Mandatory = 'False' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    AfterAll {
        Remove-Variable -Name statusCode, responseHeader -Scope Global -ErrorAction SilentlyContinue
    }

    Context "Successful REST call" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                param($StatusCodeVariable, $ResponseHeadersVariable)
                Set-Variable -Name $StatusCodeVariable -Value 200 -Scope Global
                Set-Variable -Name $ResponseHeadersVariable -Value $null -Scope Global
                return @{
                    value = @(@{ id = 'test-id'; name = 'test-name' })
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
            Mock -CommandName Test-FabricApiResponse -MockWith {
                param($Response, $ResponseHeader, $StatusCode)
                return $Response
            }
        }

        It 'Should invoke REST method successfully' {
            InModuleScope -ModuleName 'FabricTools' {
                { Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/workspaces' } | Should -Not -Throw

                Should -Invoke -CommandName Test-FabricApiResponse -Times 1 -Exactly -ParameterFilter {
                    $ResponseHeader -is [hashtable]
                }
            }
        }
    }

    Context "Error handling" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -MockWith {
                param($StatusCodeVariable, $ResponseHeadersVariable)
                Set-Variable -Name $StatusCodeVariable -Value 200 -Scope Global
                Set-Variable -Name $ResponseHeadersVariable -Value $null -Scope Global
                return @{
                    errorCode = 'TestError'
                    message = 'API Error'
                }
            }
            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should not throw when API returns error response (SkipHttpErrorCheck is used)' {
            InModuleScope -ModuleName 'FabricTools' {
                { Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/workspaces' } | Should -Not -Throw
            }
        }
    }

    Context "User-Agent header" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith {
                param($FullName)
                switch ($FullName) {
                    'FabricTools.UserAgent' { return 'TestUA/1.2' }
                    'FabricTools.FabricSession.Headers' { return @{} }
                    'FabricTools.FabricApi.ContentType' { return 'application/json; charset=utf-8' }
                    Default { return $null }
                }
            }

            Mock -CommandName Invoke-RestMethod -MockWith {
                param($StatusCodeVariable, $ResponseHeadersVariable)
                Set-Variable -Name $StatusCodeVariable -Value 200 -Scope Global
                Set-Variable -Name $ResponseHeadersVariable -Value $null -Scope Global
                return @{ value = @(); statusCode = 200 }
            }

            Mock -CommandName Confirm-TokenState -MockWith { return $true }
        }

        It 'Should include configured User-Agent header in request' {
            InModuleScope -ModuleName 'FabricTools' {
                Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/test' | Out-Null

                Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                    $Headers -ne $null -and $Headers['User-Agent'] -eq 'TestUA/1.2'
                } -Because 'Invoke-RestMethod should be called with User-Agent header set to configured value'
            }
        }

        It 'Should convert the timeout from minutes to seconds for the request' {
            InModuleScope -ModuleName 'FabricTools' {
                Invoke-FabricRestMethod -Uri 'https://api.fabric.microsoft.com/v1/test' -Timeout 2 -HandleResponse:$false | Out-Null

                Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                    $TimeoutSec -gt 0 -and $TimeoutSec -le 120
                }
            }
        }
    }

    Context "ApiType routing" {
        BeforeAll {
            Mock -CommandName Get-PSFConfigValue -MockWith {
                param($FullName)
                switch ($FullName) {
                    'FabricTools.UserAgent' { return 'TestUA/1.2' }
                    'FabricTools.FabricApi.ContentType' { return 'application/json; charset=utf-8' }
                    Default { return $null }
                }
            }

            Mock -CommandName Get-FabricApiSession -MockWith {
                param($ApiType)
                $baseUrl = switch ($ApiType) {
                    'Fabric' { 'https://api.fabric.microsoft.com/v1' }
                    'PowerBI' { 'https://api.powerbi.com/v1.0/myorg' }
                    'Azure' { 'https://management.azure.com' }
                    'Kusto' { $null }
                }
                [pscustomobject]@{
                    ApiType = $ApiType
                    BaseUrl = $baseUrl
                    Headers = @{ Authorization = "Bearer $ApiType-token" }
                }
            }

            Mock -CommandName Invoke-RestMethod -MockWith {
                param($StatusCodeVariable, $ResponseHeadersVariable)
                Set-Variable -Name $StatusCodeVariable -Value 200 -Scope Global
                Set-Variable -Name $ResponseHeadersVariable -Value $null -Scope Global
                return @{ statusCode = 200 }
            }
        }

        It 'Should use the Fabric API by default' {
            InModuleScope -ModuleName 'FabricTools' {
                Invoke-FabricRestMethod -Uri 'workspaces' | Out-Null

                Should -Invoke -CommandName Get-FabricApiSession -Times 1 -Exactly -ParameterFilter { $ApiType -eq 'Fabric' }
                Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ParameterFilter {
                    $Uri -eq 'https://api.fabric.microsoft.com/v1/workspaces' -and
                    $Headers['Authorization'] -eq 'Bearer Fabric-token' -and
                    $Headers['User-Agent'] -eq 'TestUA/1.2'
                }
            }
        }

        It 'Should use the base URL and headers of ApiType <_>' -ForEach @('PowerBI', 'Azure') {
            InModuleScope -ModuleName 'FabricTools' -Parameters @{ apiType = $_ } {
                param($apiType)
                Invoke-FabricRestMethod -Uri 'test' -ApiType $apiType | Out-Null

                $expectedBaseUrl = @{ PowerBI = 'https://api.powerbi.com/v1.0/myorg'; Azure = 'https://management.azure.com' }[$apiType]
                Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ParameterFilter {
                    $Uri -eq "$expectedBaseUrl/test" -and $Headers['Authorization'] -eq "Bearer $apiType-token"
                }
            }
        }

        It 'Should map the PowerBIApi switch to ApiType PowerBI' {
            InModuleScope -ModuleName 'FabricTools' {
                Invoke-FabricRestMethod -Uri 'datasets' -PowerBIApi | Out-Null

                Should -Invoke -CommandName Get-FabricApiSession -Times 1 -Exactly -ParameterFilter { $ApiType -eq 'PowerBI' }
                Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ParameterFilter {
                    $Uri -eq 'https://api.powerbi.com/v1.0/myorg/datasets'
                }
            }
        }

        It 'Should keep a full Uri and use the Kusto headers for ApiType Kusto' {
            InModuleScope -ModuleName 'FabricTools' {
                Invoke-FabricRestMethod -Uri 'https://test.kusto.fabric.microsoft.com/v1/rest/query' -Method Post -ApiType Kusto | Out-Null

                Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly -ParameterFilter {
                    $Uri -eq 'https://test.kusto.fabric.microsoft.com/v1/rest/query' -and
                    $Headers['Authorization'] -eq 'Bearer Kusto-token'
                }
            }
        }

        It 'Should throw for a relative Uri with ApiType Kusto' {
            InModuleScope -ModuleName 'FabricTools' {
                { Invoke-FabricRestMethod -Uri 'v1/rest/query' -ApiType Kusto } | Should -Throw -ExpectedMessage "*has no base URL*"
                Should -Invoke -CommandName Invoke-RestMethod -Times 0 -Exactly
            }
        }
    }
}
