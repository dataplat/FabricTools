#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Get-FabricApiSession'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName
}

Describe "Get-FabricApiSession" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have a mandatory ApiType parameter' {
            InModuleScope -ModuleName 'FabricTools' {
                $command = Get-Command -Name Get-FabricApiSession
                $command | Should -HaveParameter -ParameterName 'ApiType' -Type 'string' -Mandatory
            }
        }

        It 'Should reject an unknown ApiType' {
            InModuleScope -ModuleName 'FabricTools' {
                { Get-FabricApiSession -ApiType 'Unknown' } | Should -Throw
            }
        }
    }

    Context "Fabric, Power BI and Azure sessions" {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Get-PSFConfigValue -MockWith {
                param($FullName)
                switch ($FullName) {
                    'FabricTools.FabricSession.Headers' { return @{ Authorization = 'Bearer fabric-token' } }
                    'FabricTools.AzureSession.Headers' { return @{ Authorization = 'Bearer azure-token' } }
                    'FabricTools.PowerBiApi.BaseUrl' { return 'https://api.powerbi.com/v1.0/myorg' }
                    'FabricTools.AzureApi.BaseUrl' { return 'https://management.azure.com' }
                    Default { return $null }
                }
            }
        }

        It 'Should return the Fabric base URL and Fabric headers for ApiType Fabric' {
            InModuleScope -ModuleName 'FabricTools' {
                $session = Get-FabricApiSession -ApiType Fabric

                $session.BaseUrl | Should -Be $script:FabricConfig.BaseUrl
                $session.Headers.Authorization | Should -Be 'Bearer fabric-token'
            }
        }

        It 'Should return the Power BI base URL and Fabric headers for ApiType PowerBI' {
            InModuleScope -ModuleName 'FabricTools' {
                $session = Get-FabricApiSession -ApiType PowerBI

                $session.BaseUrl | Should -Be 'https://api.powerbi.com/v1.0/myorg'
                $session.Headers.Authorization | Should -Be 'Bearer fabric-token'
            }
        }

        It 'Should return the Azure base URL and Azure headers for ApiType Azure' {
            InModuleScope -ModuleName 'FabricTools' {
                $session = Get-FabricApiSession -ApiType Azure

                $session.BaseUrl | Should -Be 'https://management.azure.com'
                $session.Headers.Authorization | Should -Be 'Bearer azure-token'
            }
        }
    }

    Context "Kusto session" {
        BeforeAll {
            Mock -CommandName Write-Message -MockWith { }
            Mock -CommandName Set-PSFConfig -MockWith { }
            Mock -CommandName Get-AzAccessToken -MockWith {
                [pscustomobject]@{
                    Token     = ConvertTo-SecureString -String 'new-kusto-token' -AsPlainText -Force
                    ExpiresOn = [DateTimeOffset]::Now.AddHours(1)
                }
            }
        }

        It 'Should acquire a Kusto token on first use and cache it' {
            InModuleScope -ModuleName 'FabricTools' {
                Mock -CommandName Get-PSFConfigValue -MockWith {
                    param($FullName)
                    switch ($FullName) {
                        'FabricTools.KustoApi.ResourceUrl' { return 'https://api.kusto.windows.net' }
                        'FabricTools.KustoSession.Headers' { return @{} }
                        Default { return $null }
                    }
                }

                $session = Get-FabricApiSession -ApiType Kusto

                $session.BaseUrl | Should -BeNullOrEmpty
                $session.Headers.Authorization | Should -Be 'Bearer new-kusto-token'
                Should -Invoke -CommandName Get-AzAccessToken -Times 1 -Exactly -ParameterFilter {
                    $ResourceUrl -eq 'https://api.kusto.windows.net'
                }
                Should -Invoke -CommandName Set-PSFConfig -Times 1 -Exactly -ParameterFilter {
                    $FullName -eq 'FabricTools.KustoSession.Headers' -and $Value.Authorization -eq 'Bearer new-kusto-token'
                }
            }
        }

        It 'Should reuse a cached Kusto token that has not expired' {
            InModuleScope -ModuleName 'FabricTools' {
                Mock -CommandName Get-PSFConfigValue -MockWith {
                    param($FullName)
                    switch ($FullName) {
                        'FabricTools.KustoSession.Headers' { return @{ Authorization = 'Bearer cached-kusto-token' } }
                        'FabricTools.KustoSession.TokenExpiresOn' { return [DateTimeOffset]::Now.AddMinutes(30) }
                        Default { return $null }
                    }
                }

                $session = Get-FabricApiSession -ApiType Kusto

                $session.Headers.Authorization | Should -Be 'Bearer cached-kusto-token'
                Should -Invoke -CommandName Get-AzAccessToken -Times 0 -Exactly
            }
        }

        It 'Should acquire a new Kusto token when the cached one has expired' {
            InModuleScope -ModuleName 'FabricTools' {
                Mock -CommandName Get-PSFConfigValue -MockWith {
                    param($FullName)
                    switch ($FullName) {
                        'FabricTools.KustoApi.ResourceUrl' { return 'https://api.kusto.windows.net' }
                        'FabricTools.KustoSession.Headers' { return @{ Authorization = 'Bearer expired-kusto-token' } }
                        'FabricTools.KustoSession.TokenExpiresOn' { return [DateTimeOffset]::Now.AddMinutes(-5) }
                        Default { return $null }
                    }
                }

                $session = Get-FabricApiSession -ApiType Kusto

                $session.Headers.Authorization | Should -Be 'Bearer new-kusto-token'
                Should -Invoke -CommandName Get-AzAccessToken -Times 1 -Exactly
            }
        }
    }
}
