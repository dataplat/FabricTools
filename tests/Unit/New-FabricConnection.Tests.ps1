#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
}

Describe 'New-FabricConnection' -Tag 'UnitTests' {
    BeforeEach {
        InModuleScope FabricTools {
            Mock Invoke-FabricRestMethod { [pscustomobject]@{ id = 'connection-id' } }
        }
    }

    It 'Creates a Web pipeline connection with redacted credential request handling' {
        InModuleScope FabricTools {
            $credential = [pscredential]::new('app-id', (ConvertTo-SecureString 'never-log-secret' -AsPlainText -Force))
            $result = New-FabricConnection -ConnectionName 'API' -BaseUrl 'https://api.example.com' -Audience 'api://service' -CredentialType ServicePrincipal -TenantId '11111111-1111-1111-1111-111111111111' -Credential $credential -Confirm:$false
            $result.id | Should -Be 'connection-id'
            Should -Invoke Invoke-FabricRestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'connections' -and $Method -eq 'Post' -and
                $HandleResponse -and $SuppressBodyLogging -and
                $Body.connectivityType -eq 'ShareableCloud' -and
                $Body.connectionDetails.type -eq 'WebForPipeline' -and
                $Body.connectionDetails.creationMethod -eq 'WebForPipeline.Contents' -and
                $Body.credentialDetails.credentialType -eq 'ServicePrincipal'
            }
        }
    }

    It 'Requires credentials for Basic authentication' {
        InModuleScope FabricTools {
            { New-FabricConnection -ConnectionName API -BaseUrl 'https://api.example.com' -Audience api -CredentialType Basic -Confirm:$false } | Should -Throw '*Credential is required*'
            Should -Invoke Invoke-FabricRestMethod -Times 0
        }
    }

    It 'Does not submit a request for WhatIf' {
        InModuleScope FabricTools {
            New-FabricConnection -ConnectionName API -BaseUrl 'https://api.example.com' -Audience api -CredentialType Anonymous -WhatIf
            Should -Invoke Invoke-FabricRestMethod -Times 0
        }
    }
}
