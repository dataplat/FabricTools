<#
.SYNOPSIS
    Builds the command index used by the documentation site prototype.

.DESCRIPTION
    Parses the PlatyPS v1 markdown files in docs/en-US and writes commands.js
    (window.FABRIC_COMMANDS = [...]) next to this script. The file is loaded with a plain
    <script> tag, so the prototype also works when index.html is opened from disk (file://).

    Item type is read from the `itemType` frontmatter key. Until
    Generate_help_from_built_module writes that key, the script falls back to the
    src/Public/<folder> that contains the cmdlet ('Core' for cmdlets in src/Public itself).

.EXAMPLE
    ./site/prototype/Build-CommandIndex.ps1
#>
[CmdletBinding()]
param(
    [string] $DocsPath   = (Join-Path $PSScriptRoot '../../docs/en-US'),
    [string] $SourcePath = (Join-Path $PSScriptRoot '../../src/Public'),
    [string] $ChangelogPath = (Join-Path $PSScriptRoot '../../CHANGELOG.md'),
    [string] $OutFile    = (Join-Path $PSScriptRoot 'commands.js')
)

$ErrorActionPreference = 'Stop'

# Fallback item-type map: cmdlet name -> src/Public folder
$folderMap = @{}
if (Test-Path $SourcePath) {
    $root = (Resolve-Path $SourcePath).Path
    Get-ChildItem -Path $root -Filter '*.ps1' -Recurse | ForEach-Object {
        $parent = $_.Directory.FullName
        $folderMap[$_.BaseName] = if ($parent -eq $root) { 'Core' } else { $_.Directory.Name }
    }
}

function Get-Sections {
    # Splits markdown lines into sections keyed by heading text, ignoring headings inside code fences.
    param([string[]] $Lines, [string] $Prefix)
    $sections = [ordered]@{}
    $current = $null
    $inFence = $false
    foreach ($line in $Lines) {
        if ($line -match '^```') { $inFence = -not $inFence }
        if (-not $inFence -and $line.StartsWith($Prefix)) {
            $current = $line.Substring($Prefix.Length).Trim()
            $sections[$current] = [System.Collections.Generic.List[string]]::new()
            continue
        }
        if ($null -ne $current) { $sections[$current].Add($line) }
    }
    $sections
}

function Get-Text {
    param($Lines)
    if (-not $Lines) { return '' }
    $text = ($Lines -join "`n").Trim()
    if ($text -match '^\{\{.*\}\}$') { return '' }   # PlatyPS placeholder
    $text
}

function Get-YamlValue {
    param([string] $Yaml, [string] $Key)
    if ($Yaml -match "(?m)^[ \t]*-?[ \t]*${Key}:[ \t]*(.*)$") { return $Matches[1].Trim().Trim("'") }
    $null
}

function Get-YamlList {
    # Reads a top-level YAML list, either inline ([a, b]) or block style (- a).
    param([string] $Yaml, [string] $Key)
    $inline = Get-YamlValue $Yaml $Key
    if ($inline) { return @($inline.Trim('[', ']') -split ',' | ForEach-Object { $_.Trim().Trim("'") } | Where-Object { $_ }) }
    if ($Yaml -match "(?m)^${Key}:[ \t]*\r?\n((?:- .*\r?\n?)+)") {
        return @($Matches[1] -split '\r?\n' | Where-Object { $_ } | ForEach-Object { $_.Substring(2).Trim().Trim("'") })
    }
    @()
}

# Short PowerShell-style type names (same style as the SYNTAX block, e.g. <guid>)
$typeAccelerators = @{
    'System.Management.Automation.SwitchParameter' = 'switch'
    'System.Management.Automation.PSCredential'    = 'pscredential'
    'System.Management.Automation.ScriptBlock'     = 'scriptblock'
    'System.Security.SecureString'                 = 'securestring'
    'System.Collections.Hashtable'                 = 'hashtable'
    'System.Int32'   = 'int';    'System.Int64'  = 'long'
    'System.Boolean' = 'bool';   'System.String' = 'string'
    'System.Guid'    = 'guid';   'System.Object' = 'object'
    'System.DateTime' = 'datetime'; 'System.Array' = 'array'
}

function Get-ShortTypeName {
    param([string] $Type)
    if (-not $Type) { return '' }
    $isArray = $Type.EndsWith('[]')
    $base = $Type.TrimEnd('[', ']')
    $short = if ($typeAccelerators.ContainsKey($base)) { $typeAccelerators[$base] } else { ($base -split '\.')[-1] }
    if ($isArray) { "$short[]" } else { $short }
}

$commands = foreach ($file in Get-ChildItem -Path $DocsPath -Filter '*.md' | Sort-Object Name) {
    $lines = Get-Content -Path $file.FullName -Encoding UTF8

    # Frontmatter
    $front = @{}
    $bodyStart = 0
    if ($lines[0] -eq '---') {
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -eq '---') { $bodyStart = $i + 1; break }
            if ($lines[$i] -match '^([^:]+):\s*(.*)$') { $front[$Matches[1].Trim()] = $Matches[2].Trim().Trim("'") }
        }
    }
    if ($front['document type'] -ne 'cmdlet') { continue }

    $name = $file.BaseName
    $body = $lines[$bodyStart..($lines.Count - 1)]
    $s = Get-Sections -Lines $body -Prefix '## '

    # Syntax: one code block per parameter set
    $syntax = @()
    if ($s['SYNTAX']) {
        $sets = Get-Sections -Lines $s['SYNTAX'] -Prefix '### '
        foreach ($setName in $sets.Keys) {
            $code = ($sets[$setName] | Where-Object { $_ -notmatch '^```' }) -join "`n"
            $syntax += [ordered]@{
                set  = if ($setName -eq '__AllParameterSets') { '' } else { $setName }
                code = $code.Trim()
            }
        }
    }

    # Examples: title, intro text, code
    $examples = @()
    if ($s['EXAMPLES']) {
        $exs = Get-Sections -Lines $s['EXAMPLES'] -Prefix '### '
        foreach ($title in $exs.Keys) {
            $examples += [ordered]@{ title = $title; body = Get-Text $exs[$title] }
        }
    }

    # Parameters: description + selected YAML metadata
    $parameters = @()
    if ($s['PARAMETERS']) {
        $ps = Get-Sections -Lines $s['PARAMETERS'] -Prefix '### '
        foreach ($pName in $ps.Keys) {
            if ($pName -eq 'CommonParameters') { continue }
            $pLines = $ps[$pName]
            $yamlStart = [array]::IndexOf([string[]]$pLines, '```yaml')
            $desc = if ($yamlStart -ge 0) { Get-Text $pLines[0..([Math]::Max(0, $yamlStart - 1))] } else { Get-Text $pLines }
            if ($yamlStart -eq 0) { $desc = '' }
            $yaml = if ($yamlStart -ge 0) { ($pLines[$yamlStart..($pLines.Count - 1)]) -join "`n" } else { '' }
            $parameters += [ordered]@{
                name        = $pName.TrimStart('-')
                description = $desc
                type        = Get-ShortTypeName (Get-YamlValue $yaml 'Type')
                fullType    = Get-YamlValue $yaml 'Type'
                default     = Get-YamlValue $yaml 'DefaultValue'
                required    = (Get-YamlValue $yaml 'IsRequired') -eq 'true'
                position    = Get-YamlValue $yaml 'Position'
                pipeline    = (Get-YamlValue $yaml 'ValueFromPipeline') -eq 'true'
                pipelineByName = (Get-YamlValue $yaml 'ValueFromPipelineByPropertyName') -eq 'true'
                aliases     = (Get-YamlList $yaml 'Aliases') -join ', '
            }
        }
    }

    $verb, $noun = $name -split '-', 2
    $itemType = $front['itemType']
    if (-not $itemType) { $itemType = $folderMap[$name] }
    if (-not $itemType) { $itemType = 'Uncategorized' }

    [ordered]@{
        name        = $name
        verb        = $verb
        noun        = $noun
        itemType    = $itemType
        synopsis    = Get-Text $s['SYNOPSIS']
        description = Get-Text $s['DESCRIPTION']
        aliases     = Get-Text $s['ALIASES']
        syntax      = $syntax
        examples    = $examples
        parameters  = $parameters
        inputs      = Get-Text $s['INPUTS']
        outputs     = Get-Text $s['OUTPUTS']
        notes       = Get-Text $s['NOTES']
        source      = "docs/en-US/$($file.Name)"
    }
}

# Latest released version = first non-Unreleased heading in CHANGELOG.md (e.g. "## 0.32.0 - 2026-05-06")
$meta = [ordered]@{ version = ''; date = '' }
if (Test-Path $ChangelogPath) {
    $release = Select-String -Path $ChangelogPath -Pattern '^## \[?(\d+\.\d+\.\d+[^\]\s]*)\]?(?:\s*-\s*(\d{4}-\d{2}-\d{2}))?' | Select-Object -First 1
    if ($release) {
        $meta.version = $release.Matches[0].Groups[1].Value
        $meta.date    = $release.Matches[0].Groups[2].Value
    }
}

$json = ConvertTo-Json -InputObject @($commands) -Depth 6 -Compress
$metaJson = ConvertTo-Json -InputObject $meta -Compress
$header = "// Generated by Build-CommandIndex.ps1 on $(Get-Date -Format 'yyyy-MM-dd') from docs/en-US and CHANGELOG.md. Do not edit.`n"
[System.IO.File]::WriteAllText($OutFile, "${header}window.FABRIC_META = $metaJson;`nwindow.FABRIC_COMMANDS = $json;`n", [System.Text.UTF8Encoding]::new($false))

$uncategorized = @($commands | Where-Object { $_.itemType -eq 'Uncategorized' })
Write-Host "Latest release: $($meta.version) ($($meta.date))"
Write-Host "Wrote $(@($commands).Count) commands, $(@($commands.itemType | Sort-Object -Unique).Count) item types -> $OutFile"
if ($uncategorized) { Write-Warning "No item type for: $($uncategorized.name -join ', ')" }
