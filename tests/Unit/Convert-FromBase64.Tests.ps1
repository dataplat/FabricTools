#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Convert-FromBase64'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Convert-FromBase64
}

Describe "Convert-FromBase64" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'Base64String'; ExpectedParameterType = 'string'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful Base64 conversion" {
        It 'Should convert Base64 string back to original text' {
            $originalText = 'Hello World'
            $base64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($originalText))
            $result = Convert-FromBase64 -Base64String $base64
            $result | Should -Be $originalText
        }
    }

    Context "Error handling" {
        It 'Should handle invalid Base64 string gracefully' {
            { Convert-FromBase64 -Base64String 'NotValidBase64!!!' } | Should -Throw
        }
    }
}
