Import-Module -Name platyPS

$mdHelpParams = @{
    Module                = 'FabricTools'
    OutputFolder          = ".\documentation"
    AlphabeticParamsOrder = $true
    UseFullTypeName       = $true
    WithModulePage        = $true
    ExcludeDontShow       = $false
    Encoding              = [System.Text.Encoding]::UTF8
    ModulePagePath        = ".\documentation\readme.md"
}
New-MarkdownHelp @mdHelpParams -Force

. .\helper\Update-ReadmeDescriptions.ps1
