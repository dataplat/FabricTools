function Get-CommandItemTypeMap
{
    <#
    .SYNOPSIS
        Maps each public cmdlet to its item type.

    .DESCRIPTION
        The item type of a cmdlet is the name of the folder under src/Public that holds it,
        for example 'Lakehouse' or 'KQL Database'. Cmdlets placed directly in src/Public get
        the item type 'Core'.

        The documentation tasks write the item type into each help file's frontmatter as
        'itemType', and the documentation website groups and filters commands by it.

    .PARAMETER PublicPath
        Path to the src/Public folder.

    .EXAMPLE
        $map = Get-CommandItemTypeMap -PublicPath ./src/Public
        $map['Get-FabricLakehouse']   # Lakehouse
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PublicPath
    )

    $root = (Resolve-Path -Path $PublicPath).Path.TrimEnd('\', '/')
    $map = @{}

    foreach ($file in Get-ChildItem -Path $root -Filter '*.ps1' -Recurse -File)
    {
        $relative = $file.DirectoryName.Substring($root.Length).Trim('\', '/')
        $itemType = if ($relative) { ($relative -split '[\\/]')[0] } else { 'Core' }

        # Key by the function(s) defined in the file; the file name does not always match.
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref] $null, [ref] $null)
        $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)
        $names = @($functions | Where-Object { $_.Parent.Parent -eq $ast -or $_.Parent -eq $ast.EndBlock } | ForEach-Object Name)
        if (-not $names) { $names = @($file.BaseName) }

        foreach ($name in $names) { $map[$name] = $itemType }
    }

    $map
}
