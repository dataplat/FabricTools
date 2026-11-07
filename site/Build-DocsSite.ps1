<#
.SYNOPSIS
    Builds the FabricTools documentation website from docs/en-US.

.DESCRIPTION
    Generates a static website from the PlatyPS v1 markdown help in docs/en-US:

    - index.html                     Command Explorer: search by name, filter by item type and verb
    - commands/<Name>/index.html     One page per cmdlet, at a stable URL (suitable for HelpUri)
    - assets/commands.js             Search index used by the explorer and for linking in code samples
    - 404.html, sitemap.xml, robots.txt, .nojekyll

    Every page is fully rendered at build time; assets/site.js only adds search, highlighting
    and copy buttons. The item type of a command is read from the 'itemType' frontmatter key,
    which the generate_docs / Generate_help_from_built_module build tasks write. The latest
    released version is read from CHANGELOG.md.

.PARAMETER DocsPath
    Folder with the PlatyPS markdown files.

.PARAMETER ChangelogPath
    CHANGELOG.md used to show the latest released version.

.PARAMETER OutputPath
    Folder the site is written to. It is deleted and recreated.

.PARAMETER BaseUrl
    Public URL of the site root, used for canonical links, sitemap.xml and 404.html.

.PARAMETER RepositoryUrl
    GitHub repository URL used for "Edit on GitHub" and release links.

.PARAMETER Branch
    Branch used for "Edit on GitHub" links.

.PARAMETER LocalPreview
    Appends index.html to internal links so the site can be browsed from disk (file://).

.EXAMPLE
    ./site/Build-DocsSite.ps1 -LocalPreview
    start ./output/site/index.html

.EXAMPLE
    ./site/Build-DocsSite.ps1 -BaseUrl 'https://fabrictools.io/'
#>
[CmdletBinding()]
param
(
    [Parameter()]
    [System.String]
    $DocsPath = (Join-Path $PSScriptRoot '../docs/en-US'),

    [Parameter()]
    [System.String]
    $ChangelogPath = (Join-Path $PSScriptRoot '../CHANGELOG.md'),

    [Parameter()]
    [System.String]
    $OutputPath = (Join-Path $PSScriptRoot '../output/site'),

    [Parameter()]
    [System.String]
    $BaseUrl = 'https://dataplat.github.io/FabricTools/',

    [Parameter()]
    [System.String]
    $RepositoryUrl = 'https://github.com/dataplat/FabricTools',

    [Parameter()]
    [System.String]
    $Branch = 'main',

    [Parameter()]
    [System.Management.Automation.SwitchParameter]
    $LocalPreview
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

if (-not $BaseUrl.EndsWith('/')) { $BaseUrl += '/' }
$RepositoryUrl = $RepositoryUrl.TrimEnd('/')
$linkSuffix = if ($LocalPreview) { 'index.html' } else { '' }
$verbOrder = @('Get', 'New', 'Update', 'Remove', 'Add', 'Set', 'Invoke', 'Start', 'Stop', 'Connect', 'Disconnect', 'Export', 'Import')

#region Parsing

function Get-MarkdownSection
{
    # Splits lines into sections keyed by heading text, ignoring headings inside code fences.
    param ([string[]] $Lines, [string] $Prefix)

    $sections = [ordered]@{}
    $current = $null
    $inFence = $false
    foreach ($line in $Lines)
    {
        if ($line -match '^```') { $inFence = -not $inFence }
        if (-not $inFence -and $line.StartsWith($Prefix))
        {
            $current = $line.Substring($Prefix.Length).Trim()
            $sections[$current] = [System.Collections.Generic.List[string]]::new()
            continue
        }
        if ($null -ne $current) { $sections[$current].Add($line) }
    }
    $sections
}

function Get-SectionText
{
    param ($Lines)

    if (-not $Lines) { return '' }
    $text = ($Lines -join "`n").Trim()
    if ($text -match '^\{\{.*\}\}$') { return '' }   # PlatyPS placeholder
    $text
}

function Get-YamlValue
{
    param ([string] $Yaml, [string] $Key)

    if ($Yaml -match "(?m)^[ \t]*-?[ \t]*${Key}:[ \t]*(.*)$") { return $Matches[1].Trim().Trim("'") }
    $null
}

function Get-YamlList
{
    # Reads a top-level YAML list, either inline ([a, b]) or block style (- a).
    param ([string] $Yaml, [string] $Key)

    $inline = Get-YamlValue $Yaml $Key
    if ($inline) { return @($inline.Trim('[', ']') -split ',' | ForEach-Object { $_.Trim().Trim("'") } | Where-Object { $_ }) }
    if ($Yaml -match "(?m)^${Key}:[ \t]*\r?\n((?:- .*\r?\n?)+)")
    {
        return @($Matches[1] -split '\r?\n' | Where-Object { $_ } | ForEach-Object { $_.Substring(2).Trim().Trim("'") })
    }
    @()
}

$typeAccelerators = @{
    'System.Management.Automation.SwitchParameter' = 'switch'
    'System.Management.Automation.PSCredential'    = 'pscredential'
    'System.Management.Automation.ScriptBlock'     = 'scriptblock'
    'System.Management.Automation.PSObject'        = 'psobject'
    'System.Security.SecureString'                 = 'securestring'
    'System.Collections.Hashtable'                 = 'hashtable'
    'System.Int32'    = 'int'
    'System.Int64'    = 'long'
    'System.Boolean'  = 'bool'
    'System.String'   = 'string'
    'System.Guid'     = 'guid'
    'System.Object'   = 'object'
    'System.DateTime' = 'datetime'
    'System.Array'    = 'array'
}

function Get-ShortTypeName
{
    # Short PowerShell-style type names, as used in the SYNTAX block (e.g. <guid>).
    param ([string] $Type)

    if (-not $Type) { return '' }
    $isArray = $Type.EndsWith('[]')
    $base = $Type.TrimEnd('[', ']')
    $short = if ($typeAccelerators.ContainsKey($base)) { $typeAccelerators[$base] } else { ($base -split '\.')[-1] }
    if ($isArray) { "$short[]" } else { $short }
}

function ConvertFrom-CommandHelpFile
{
    # Parses a PlatyPS v1 cmdlet markdown file. Returns $null for non-cmdlet files (e.g. the module page).
    param ([System.IO.FileInfo] $File)

    $lines = [System.IO.File]::ReadAllLines($File.FullName)

    $front = @{}
    $bodyStart = 0
    if ($lines.Count -and $lines[0] -eq '---')
    {
        for ($i = 1; $i -lt $lines.Count; $i++)
        {
            if ($lines[$i] -eq '---') { $bodyStart = $i + 1; break }
            if ($lines[$i] -match '^([^:]+):\s*(.*)$') { $front[$Matches[1].Trim()] = $Matches[2].Trim().Trim("'") }
        }
    }
    if ($front['document type'] -ne 'cmdlet') { return $null }

    $name = $File.BaseName
    $sections = Get-MarkdownSection -Lines $lines[$bodyStart..($lines.Count - 1)] -Prefix '## '

    $syntax = @(
        if ($sections.Contains('SYNTAX'))
        {
            $sets = Get-MarkdownSection -Lines $sections['SYNTAX'] -Prefix '### '
            foreach ($setName in $sets.Keys)
            {
                [ordered]@{
                    set  = if ($setName -eq '__AllParameterSets') { '' } else { $setName }
                    code = (($sets[$setName] | Where-Object { $_ -notmatch '^```' }) -join "`n").Trim()
                }
            }
        }
    )

    $examples = @(
        if ($sections.Contains('EXAMPLES'))
        {
            $exampleSections = Get-MarkdownSection -Lines $sections['EXAMPLES'] -Prefix '### '
            foreach ($title in $exampleSections.Keys)
            {
                [ordered]@{ title = $title; body = Get-SectionText $exampleSections[$title] }
            }
        }
    )

    $parameters = @(
        if ($sections.Contains('PARAMETERS'))
        {
            $parameterSections = Get-MarkdownSection -Lines $sections['PARAMETERS'] -Prefix '### '
            foreach ($parameterName in $parameterSections.Keys)
            {
                if ($parameterName -eq 'CommonParameters') { continue }
                $pLines = [string[]] $parameterSections[$parameterName]
                $yamlStart = [array]::IndexOf($pLines, '```yaml')
                $description = if ($yamlStart -gt 0) { Get-SectionText $pLines[0..($yamlStart - 1)] } elseif ($yamlStart -lt 0) { Get-SectionText $pLines } else { '' }
                $yaml = if ($yamlStart -ge 0) { $pLines[$yamlStart..($pLines.Count - 1)] -join "`n" } else { '' }
                $fullType = Get-YamlValue $yaml 'Type'
                [ordered]@{
                    name           = $parameterName.TrimStart('-')
                    description    = $description
                    type           = Get-ShortTypeName $fullType
                    fullType       = $fullType
                    default        = Get-YamlValue $yaml 'DefaultValue'
                    required       = (Get-YamlValue $yaml 'IsRequired') -eq 'true'
                    position       = Get-YamlValue $yaml 'Position'
                    pipeline       = (Get-YamlValue $yaml 'ValueFromPipeline') -eq 'true'
                    pipelineByName = (Get-YamlValue $yaml 'ValueFromPipelineByPropertyName') -eq 'true'
                    aliases        = (Get-YamlList $yaml 'Aliases') -join ', '
                }
            }
        }
    )

    $verb, $noun = $name -split '-', 2
    $itemType = $front['itemType']
    if (-not $itemType)
    {
        Write-Warning "$($File.Name) has no 'itemType' in its frontmatter. Regenerate the docs with './build.ps1 -Tasks generate_docs'."
        $itemType = 'Uncategorized'
    }

    $section = { param($key) if ($sections.Contains($key)) { Get-SectionText $sections[$key] } else { '' } }

    [ordered]@{
        name        = $name
        verb        = $verb
        noun        = $noun
        itemType    = $itemType
        synopsis    = & $section 'SYNOPSIS'
        description = & $section 'DESCRIPTION'
        aliases     = & $section 'ALIASES'
        syntax      = $syntax
        examples    = $examples
        parameters  = $parameters
        inputs      = & $section 'INPUTS'
        outputs     = & $section 'OUTPUTS'
        notes       = & $section 'NOTES'
        source      = "docs/en-US/$($File.Name)"
    }
}

#endregion

#region Rendering

function ConvertTo-HtmlText
{
    param ([AllowNull()] [string] $Text)

    [System.Net.WebUtility]::HtmlEncode([string] $Text)
}

function Get-CommandHref
{
    # Relative link from the current page to a command page.
    param ([string] $Name)

    "$script:PageRoot" + 'commands/' + [uri]::EscapeDataString($Name) + '/' + $linkSuffix
}

function ConvertTo-InlineHtml
{
    # Inline markdown: `code` (linked when it names a command), [text](url), **bold**, bare URLs.
    param ([string] $Text)

    $html = ConvertTo-HtmlText $Text
    $html = [regex]::Replace($html, '`([^`]+)`', {
            param($m)
            $code = $m.Groups[1].Value
            $command = $script:CommandsByName[[System.Net.WebUtility]::HtmlDecode($code)]
            if ($command -and $command.name -ne $script:CurrentCommand) { "<a href=""$(Get-CommandHref $command.name)""><code>$code</code></a>" }
            else { "<code>$code</code>" }
        })
    $html = [regex]::Replace($html, '\[([^\]]+)\]\((https?:[^)\s]+)\)', '<a href="$2" rel="noopener">$1</a>')
    $html = [regex]::Replace($html, '\*\*([^*]+)\*\*', '<strong>$1</strong>')
    $html = [regex]::Replace($html, '(^|[\s(])(https?://[^\s<)]+)', '$1<a href="$2" rel="noopener">$2</a>')
    $html
}

function New-CodeBlockHtml
{
    param ([string] $Code, [string] $Label, [string] $Class)

    $labelHtml = if ($Label) { "<div class=""set"">$(ConvertTo-HtmlText $Label)</div>" } else { '' }
    "<div class=""code $Class"">$labelHtml<pre><code>$(ConvertTo-HtmlText $Code)</code></pre></div>"
}

function ConvertTo-BlockHtml
{
    # Block markdown: paragraphs, bullet lists, code fences and ### headings. All text is HTML-encoded.
    param ([string] $Text)

    if (-not $Text) { return '' }
    $sb = [System.Text.StringBuilder]::new()
    $paragraph = [System.Collections.Generic.List[string]]::new()
    $list = [System.Collections.Generic.List[string]]::new()
    $flushParagraph = {
        if ($paragraph.Count) { [void] $sb.Append("<p>$(ConvertTo-InlineHtml ($paragraph -join ' '))</p>"); $paragraph.Clear() }
    }
    $flushList = {
        if ($list.Count) { [void] $sb.Append('<ul>' + (($list | ForEach-Object { "<li>$(ConvertTo-InlineHtml $_)</li>" }) -join '') + '</ul>'); $list.Clear() }
    }

    $lines = $Text -split '\r?\n'
    for ($i = 0; $i -lt $lines.Count; $i++)
    {
        $line = $lines[$i]
        if ($line -match '^```')
        {
            & $flushParagraph; & $flushList
            $code = [System.Collections.Generic.List[string]]::new()
            for ($i++; $i -lt $lines.Count -and $lines[$i] -notmatch '^```'; $i++) { $code.Add($lines[$i]) }
            [void] $sb.Append((New-CodeBlockHtml -Code ($code -join "`n")))
        }
        elseif ($line -match '^#{3,6}\s+(.+)$')
        {
            & $flushParagraph; & $flushList
            [void] $sb.Append("<h3>$(ConvertTo-InlineHtml $Matches[1])</h3>")
        }
        elseif ($line -match '^\s*[-*]\s+(.*)$')
        {
            & $flushParagraph
            $list.Add($Matches[1])
        }
        elseif (-not $line.Trim())
        {
            & $flushParagraph; & $flushList
        }
        elseif ($list.Count -and $line -match '^\s+\S')
        {
            $list[$list.Count - 1] += ' ' + $line.Trim()
        }
        else
        {
            & $flushList
            $paragraph.Add($line.Trim())
        }
    }
    & $flushParagraph; & $flushList
    $sb.ToString()
}

function ConvertTo-ExampleHtml
{
    # Some help files write example code without ``` fences; wrap lines that look like PowerShell.
    param ([string] $Text)

    if (-not $Text -or $Text.Contains('```')) { return ConvertTo-BlockHtml $Text }
    $isCode = '^\s*(\$\w|[A-Z][a-z]+-[A-Z]\w+|\.\\|#\s|\||@\{|\}|foreach\b|if\s*\()'
    $out = [System.Collections.Generic.List[string]]::new()
    $inCode = $false
    foreach ($line in $Text -split '\r?\n')
    {
        $code = ($line -cmatch $isCode) -or ($inCode -and $line -match '^\s+\S')
        if ($code -and -not $inCode) { $out.Add('```'); $inCode = $true }
        if (-not $code -and $inCode -and $line.Trim())
        {
            while ($out.Count -and -not $out[$out.Count - 1].Trim()) { $out.RemoveAt($out.Count - 1) }
            $out.Add('```'); $out.Add(''); $inCode = $false
        }
        $out.Add($line)
    }
    if ($inCode)
    {
        while ($out.Count -and -not $out[$out.Count - 1].Trim()) { $out.RemoveAt($out.Count - 1) }
        $out.Add('```')
    }
    ConvertTo-BlockHtml ($out -join "`n")
}

function Get-SortedCommand
{
    param ($Commands)

    $Commands | Sort-Object -Property @{ Expression = { $_.noun } }, @{ Expression = { $i = $verbOrder.IndexOf($_.verb); if ($i -lt 0) { 99 } else { $i } } }, @{ Expression = { $_.name } }
}

function Get-ItemTypeOrder
{
    param ([string[]] $ItemTypes)

    @($ItemTypes | Where-Object { $_ -eq 'Core' }) + @($ItemTypes | Where-Object { $_ -ne 'Core' } | Sort-Object)
}

function New-PageHtml
{
    param (
        [string] $Title,
        [string] $Description,
        [string] $Root,
        [string] $Canonical,
        [string] $Main,
        [string] $Command = ''
    )

    $indexHref = "$Root$linkSuffix"
    $versionHtml = if ($meta.version)
    {
        "<a class=""badge-version"" href=""$RepositoryUrl/releases/tag/v$($meta.version)"" title=""Latest release$(if ($meta.date) { " ($($meta.date))" })"" rel=""noopener"">v$(ConvertTo-HtmlText $meta.version)</a>"
    }
    $canonicalHtml = if ($Canonical) { "<link rel=""canonical"" href=""$(ConvertTo-HtmlText $Canonical)"">" }

    @"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$(ConvertTo-HtmlText $Title)</title>
<meta name="description" content="$(ConvertTo-HtmlText $Description)">
$canonicalHtml
<meta name="color-scheme" content="light dark">
<script>try { var t = localStorage.getItem('ft-theme'); if (t) document.documentElement.dataset.theme = t; } catch (e) {}</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${Root}assets/site.css?v=$buildStamp">
<link rel="icon" href="${Root}assets/favicon.svg" type="image/svg+xml">
</head>
<body data-root="$Root" data-link-suffix="$linkSuffix" data-command="$(ConvertTo-HtmlText $Command)">
<header class="top">
  <div class="top-inner">
    <a class="brand" href="$indexHref"><span class="logo">FT</span>FabricTools</a>
    $versionHtml
    <span class="badge-preview">Public Preview</span>
    <nav>
      <a href="$indexHref">Commands</a>
      <a class="hide-sm" href="$RepositoryUrl" rel="noopener">GitHub</a>
      <a class="hide-sm" href="https://www.powershellgallery.com/packages/FabricTools" rel="noopener">Gallery</a>
      <button class="icon-btn" id="theme" type="button" title="Toggle light/dark theme" aria-label="Toggle light/dark theme">&#9680;</button>
    </nav>
  </div>
</header>
<main>
$Main
</main>
<footer class="bottom">
  <div class="inner">
    <span>Generated from <a href="$RepositoryUrl/tree/$Branch/docs/en-US" rel="noopener">docs/en-US</a> on $(Get-Date -Format 'yyyy-MM-dd')</span>
    <a href="$RepositoryUrl/blob/$Branch/CHANGELOG.md" rel="noopener">Changelog</a>
    <a href="$RepositoryUrl/issues" rel="noopener">Issues</a>
    <a href="$RepositoryUrl/blob/$Branch/LICENSE" rel="noopener">MIT License</a>
  </div>
</footer>
<script src="${Root}assets/commands.js?v=$buildStamp"></script>
<script src="${Root}assets/site.js?v=$buildStamp"></script>
</body>
</html>
"@
}

function New-CommandPageHtml
{
    param ($Command)

    $script:PageRoot = '../../'
    $script:CurrentCommand = $Command.name
    $typeHref = "../../$linkSuffix#type=$([uri]::EscapeDataString($Command.itemType))"
    $siblings = Get-SortedCommand ($commands | Where-Object { $_.itemType -eq $Command.itemType })
    $related = @($commands | Where-Object { $_.noun -eq $Command.noun -and $_.name -ne $Command.name } |
            Sort-Object -Property @{ Expression = { $i = $verbOrder.IndexOf($_.verb); if ($i -lt 0) { 99 } else { $i } } })

    $sections = [System.Collections.Generic.List[object]]::new()
    $addSection = { param($id, $title, $html) if ($html) { $sections.Add([pscustomobject]@{ id = $id; title = $title; html = $html }) } }

    & $addSection 'syntax' 'Syntax' (($Command.syntax | ForEach-Object {
                New-CodeBlockHtml -Code $_.code -Label $(if ($_.set) { "Parameter set: $($_.set)" }) -Class 'syntax'
            }) -join '')

    $descriptionHtml = ConvertTo-BlockHtml $Command.description
    if ($Command.aliases) { $descriptionHtml += "<p><strong>Aliases:</strong> $(ConvertTo-InlineHtml $Command.aliases)</p>" }
    & $addSection 'description' 'Description' $descriptionHtml

    & $addSection 'examples' 'Examples' (($Command.examples | ForEach-Object {
                $title = $_.title -replace '^EXAMPLE', 'Example'
                $id = ($title.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
                "<h3 id=""$id"">$(ConvertTo-HtmlText $title)</h3>$(ConvertTo-ExampleHtml $_.body)"
            }) -join '')

    if ($Command.parameters.Count)
    {
        $rows = foreach ($p in ($Command.parameters | Sort-Object -Property @{ Expression = { -not $_.required } }, @{ Expression = { $_.name } }))
        {
            $pipeline = if ($p.pipeline -and $p.pipelineByName) { 'Value, By name' } elseif ($p.pipeline) { 'Value' } elseif ($p.pipelineByName) { 'By name' } else { '&ndash;' }
            $alias = if ($p.aliases) { "<span class=""alias"">alias: $(ConvertTo-HtmlText $p.aliases)</span>" }
            $default = if ($p.default) { "<div class=""def"">Default: <code>$(ConvertTo-HtmlText $p.default)</code></div>" }
            $required = if ($p.required) { '<span class="req" title="Required">&#10003;<span class="sr-only">Required</span></span>' }
            @"
<tr>
  <td class="pn" id="param-$($p.name.ToLower())">-$(ConvertTo-HtmlText $p.name)$alias</td>
  <td class="pt" title="$(ConvertTo-HtmlText $p.fullType)">$(ConvertTo-HtmlText $p.type)</td>
  <td class="c">$required</td>
  <td class="c">$(ConvertTo-HtmlText $p.position)</td>
  <td class="c">$pipeline</td>
  <td class="desc">$(ConvertTo-BlockHtml $p.description)$default</td>
</tr>
"@
        }
        & $addSection 'parameters' 'Parameters' @"
<div class="table-scroll"><table class="params">
<thead><tr><th>Name</th><th>Type</th><th>Req.</th><th>Pos.</th><th>Pipeline</th><th class="d">Description</th></tr></thead>
<tbody>$($rows -join '')</tbody>
</table></div>
<p class="notice">This cmdlet also supports the common parameters, such as -Verbose and -ErrorAction. See <a href="https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_commonparameters" rel="noopener">about_CommonParameters</a>.</p>
"@
    }

    & $addSection 'inputs' 'Inputs' (ConvertTo-BlockHtml $Command.inputs)
    & $addSection 'outputs' 'Outputs' (ConvertTo-BlockHtml $Command.outputs)
    & $addSection 'notes' 'Notes' (ConvertTo-BlockHtml $Command.notes)

    $siblingLinks = ($siblings | ForEach-Object {
            $current = if ($_.name -eq $Command.name) { ' cur" aria-current="page' } else { '' }
            "<a class=""mono$current"" href=""$(Get-CommandHref $_.name)"">$(ConvertTo-HtmlText $_.name)</a>"
        }) -join "`n"
    $tocLinks = ($sections | ForEach-Object { "<a href=""#$($_.id)"">$($_.title)</a>" }) -join "`n"
    $relatedHtml = ''
    if ($related.Count)
    {
        $relatedLinks = ($related | ForEach-Object { '<a class="mono" href="{0}">{1}</a>' -f (Get-CommandHref $_.name), (ConvertTo-HtmlText $_.name) }) -join "`n"
        $relatedHtml = "<nav class=""block"" aria-label=""Related commands""><h4>Related commands</h4>$relatedLinks</nav>"
    }
    $type = ConvertTo-HtmlText $Command.itemType

    $main = @"
<div class="doc">
  <aside class="side left">
    <a class="back" href="$typeHref">&larr; All $type commands</a>
    <nav class="block" aria-label="$type commands">
      <h4>$type</h4>
      $siblingLinks
    </nav>
  </aside>
  <article>
    <div class="crumbs"><a href="../../$linkSuffix">Commands</a> / <a href="$typeHref">$type</a></div>
    <h1>$(ConvertTo-HtmlText $Command.name)</h1>
    <div class="tags"><a class="tag" href="$typeHref">$type</a><a class="tag verb" href="../../$linkSuffix#verb=$([uri]::EscapeDataString($Command.verb))">$(ConvertTo-HtmlText $Command.verb)</a></div>
    <p class="lead">$(ConvertTo-InlineHtml $Command.synopsis)</p>
    $(($sections | ForEach-Object { "<h2 id=""$($_.id)"">$($_.title)</h2><div class=""md"">$($_.html)</div>" }) -join "`n")
    <div class="foot-links">
      <a href="$RepositoryUrl/edit/$Branch/$($Command.source)" rel="noopener">Edit this page on GitHub</a>
      <a href="$RepositoryUrl/issues/new?title=$([uri]::EscapeDataString("Docs: $($Command.name)"))" rel="noopener">Report a docs issue</a>
    </div>
  </article>
  <aside class="side right">
    <nav class="block" aria-label="On this page">
      <h4>On this page</h4>
      $tocLinks
    </nav>
    $relatedHtml
  </aside>
</div>
"@

    New-PageHtml -Title "$($Command.name) - FabricTools" -Description $Command.synopsis -Root '../../' `
        -Canonical "${BaseUrl}commands/$($Command.name)/" -Main $main -Command $Command.name
}

function New-IndexPageHtml
{
    $script:PageRoot = ''
    $script:CurrentCommand = ''
    $itemTypes = Get-ItemTypeOrder ($commands.itemType | Sort-Object -Unique)

    # Server-rendered list (grouped by item type): works without JavaScript; site.js replaces it.
    $groups = foreach ($type in $itemTypes)
    {
        $items = @(Get-SortedCommand ($commands | Where-Object { $_.itemType -eq $type }))
        $rows = ($items | ForEach-Object {
                "<a class=""row"" href=""$(Get-CommandHref $_.name)""><span class=""name"">$(ConvertTo-HtmlText $_.name)</span><span class=""syn"">$(ConvertTo-HtmlText $_.synopsis)</span><span></span></a>"
            }) -join ''
        "<section class=""group""><h2>$(ConvertTo-HtmlText $type)<span>$($items.Count)</span></h2><div class=""list"">$rows</div></section>"
    }

    $releaseHtml = if ($meta.version)
    {
        @"
<div class="release">
  <span>Latest release <strong>v$(ConvertTo-HtmlText $meta.version)</strong>$(if ($meta.date) { " &middot; $(ConvertTo-HtmlText $meta.date)" })</span>
  <a href="$RepositoryUrl/releases/tag/v$($meta.version)" rel="noopener">Release notes</a>
  <a href="$RepositoryUrl/blob/$Branch/CHANGELOG.md" rel="noopener">Changelog</a>
</div>
"@
    }

    $main = @"
<div class="wrap">
  <section class="hero">
    <h1>PowerShell for Microsoft Fabric</h1>
    <p>Automate Microsoft Fabric and Power BI administration: $($commands.Count) commands across $($itemTypes.Count) item types.</p>
    <div class="install"><code>Install-Module FabricTools</code><button class="copy" type="button" data-copy="Install-Module FabricTools">Copy</button></div>
    $releaseHtml
  </section>
  <div class="search-row">
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></svg>
    <input id="q" type="search" autocomplete="off" spellcheck="false" placeholder="Search commands, e.g. get lakehouse" aria-label="Search commands" aria-controls="results">
    <span class="count" id="count" aria-live="polite">$($commands.Count) of $($commands.Count)</span>
  </div>
  <div class="filters" id="filters">
    <div class="label" id="types-label">Item type</div><div class="chips" id="types" role="group" aria-labelledby="types-label"></div>
    <div class="label" id="verbs-label">Verb</div><div class="chips" id="verbs" role="group" aria-labelledby="verbs-label"></div>
  </div>
  <div class="results" id="results">
$($groups -join "`n")
  </div>
</div>
"@

    New-PageHtml -Title 'FabricTools - PowerShell for Microsoft Fabric' `
        -Description "Documentation for FabricTools, the PowerShell module for Microsoft Fabric and Power BI administration. $($commands.Count) commands, searchable by name and item type." `
        -Root '' -Canonical $BaseUrl -Main $main
}

#endregion

#region Build

$buildStamp = Get-Date -Format 'yyyyMMddHHmm'

# Commands
$commands = @(
    Get-ChildItem -Path $DocsPath -Filter '*.md' -File | Sort-Object -Property Name | ForEach-Object {
        ConvertFrom-CommandHelpFile -File $_
    } | Where-Object { $_ }
)
if (-not $commands.Count) { throw "No cmdlet help files found in '$DocsPath'." }
$script:CommandsByName = @{}
foreach ($c in $commands) { $script:CommandsByName[$c.name] = $c }

# Latest released version: first versioned heading in CHANGELOG.md, e.g. "## 0.32.0 - 2026-05-06" or "## [0.32.0] - 2026-05-06"
$meta = [ordered]@{ version = ''; date = '' }
if (Test-Path -Path $ChangelogPath)
{
    $release = Select-String -Path $ChangelogPath -Pattern '^## \[?v?(\d+\.\d+\.\d+[^\]\s]*)\]?(?:\s*-\s*(\d{4}-\d{2}-\d{2}))?' | Select-Object -First 1
    if ($release)
    {
        $meta.version = $release.Matches[0].Groups[1].Value
        $meta.date = $release.Matches[0].Groups[2].Value
    }
}

# Output folder
if (Test-Path -Path $OutputPath) { Remove-Item -Path $OutputPath -Recurse -Force }
$assetsPath = Join-Path $OutputPath 'assets'
$null = New-Item -Path $assetsPath -ItemType Directory -Force
Copy-Item -Path (Join-Path $PSScriptRoot 'assets/*') -Destination $assetsPath -Recurse
$utf8 = [System.Text.UTF8Encoding]::new($false)

# Search index (light: only what the explorer and code linking need)
$index = @($commands | ForEach-Object { [ordered]@{ name = $_.name; verb = $_.verb; noun = $_.noun; itemType = $_.itemType; synopsis = $_.synopsis } })
$indexJson = ConvertTo-Json -InputObject $index -Depth 3 -Compress
$metaJson = ConvertTo-Json -InputObject $meta -Compress
[System.IO.File]::WriteAllText((Join-Path $assetsPath 'commands.js'),
    "// Generated by site/Build-DocsSite.ps1 from docs/en-US. Do not edit.`nwindow.FABRIC_META = $metaJson;`nwindow.FABRIC_COMMANDS = $indexJson;`n", $utf8)

# Pages
[System.IO.File]::WriteAllText((Join-Path $OutputPath 'index.html'), (New-IndexPageHtml), $utf8)

foreach ($command in $commands)
{
    $folder = Join-Path $OutputPath "commands/$($command.name)"
    $null = New-Item -Path $folder -ItemType Directory -Force
    [System.IO.File]::WriteAllText((Join-Path $folder 'index.html'), (New-CommandPageHtml -Command $command), $utf8)
}

# 404 page: served for any missing path, so it uses absolute links based on BaseUrl.
$basePath = ([uri] $BaseUrl).AbsolutePath
$script:PageRoot = $basePath
$notFound = New-PageHtml -Title 'Page not found - FabricTools' -Description 'Page not found' -Root $basePath -Main @"
<div class="wrap"><div class="empty">
  <h1>Page not found</h1>
  <p>The page you are looking for does not exist. <a href="$basePath">Search all commands</a>.</p>
</div></div>
"@
[System.IO.File]::WriteAllText((Join-Path $OutputPath '404.html'), $notFound, $utf8)

# GitHub Pages and crawler files
[System.IO.File]::WriteAllText((Join-Path $OutputPath '.nojekyll'), '', $utf8)
$urls = @($BaseUrl) + @($commands | ForEach-Object { "${BaseUrl}commands/$($_.name)/" })
$sitemap = "<?xml version=""1.0"" encoding=""UTF-8""?>`n<urlset xmlns=""http://www.sitemaps.org/schemas/sitemap/0.9"">`n" +
    (($urls | ForEach-Object { "  <url><loc>$([System.Security.SecurityElement]::Escape($_))</loc></url>" }) -join "`n") + "`n</urlset>`n"
[System.IO.File]::WriteAllText((Join-Path $OutputPath 'sitemap.xml'), $sitemap, $utf8)
[System.IO.File]::WriteAllText((Join-Path $OutputPath 'robots.txt'), "User-agent: *`nAllow: /`nSitemap: ${BaseUrl}sitemap.xml`n", $utf8)

$uncategorized = @($commands | Where-Object { $_.itemType -eq 'Uncategorized' })
Write-Host "Documentation site: $($commands.Count) commands, $(@($commands.itemType | Sort-Object -Unique).Count) item types, latest release $(if ($meta.version) { "v$($meta.version)" } else { 'unknown' })"
Write-Host "Output: $((Resolve-Path -Path $OutputPath).Path)"
if ($uncategorized.Count) { Write-Warning "$($uncategorized.Count) command(s) without itemType: $($uncategorized.name -join ', ')" }

#endregion
