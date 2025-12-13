#Requires -Module @{ ModuleName="Pester"; ModuleVersion="5.0"}

BeforeDiscovery {
    $CommandName = 'Convert-ToBase64'
}

BeforeAll {
    $ModuleName = 'FabricTools'
    $PSDefaultParameterValues['Mock:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $ModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $ModuleName

    $Command = Get-Command -Name Convert-ToBase64
}

Describe "Convert-ToBase64" -Tag "UnitTests" {

    Context "Command definition" {
        It 'Should have <ExpectedParameterName> parameter' -ForEach @(
            @{ ExpectedParameterName = 'filePath'; ExpectedParameterType = 'string'; Mandatory = 'True' }
        ) {
            $Command | Should -HaveParameter -ParameterName $ExpectedParameterName -Type $ExpectedParameterType -Mandatory:([bool]::Parse($Mandatory))
        }
    }

    Context "Successful Base64 conversion" {
        BeforeAll {
            $testFilePath = Join-Path $TestDrive 'testfile.txt'
            Set-Content -Path $testFilePath -Value 'Hello World'
        }

        It 'Should convert file to Base64 string' {
            $result = Convert-ToBase64 -filePath $testFilePath
            $result | Should -Not -BeNullOrEmpty
            $result | Should -BeOfType [string]
        }
    }

    Context "Error handling" {
        It 'Should throw when file does not exist' {
            { Convert-ToBase64 -filePath 'C:\nonexistent\file.txt' } | Should -Throw
        }
    }
}
