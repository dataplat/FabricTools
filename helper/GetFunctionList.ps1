$path = ".\source\public"
$op = Get-ChildItem -Path $path -Recurse -Filter *.ps1 | Select-Object -ExpandProperty Name | Sort-Object
#$op = $op | ForEach-Object { "        ""$_""," }
$op | Out-File '.\Output\FunctionList-main-public.txt'

# Author Table
# This script generates a table of PowerShell script authors from the specified directory.
$authorTable = @{}
$op | ForEach-Object {
    $file = $_.FullName
    $name = $_.Name
    $content = Get-Content $file
    $authorLine = $content | Where-Object { $_ -match 'Author:\s*(.+)' } | Select-Object -First 1
    if ($authorLine -match 'Author:\s*(.+)') {
        $author = $matches[1].Trim()
        $authorTable[$name] = $author
    } else {
        $authorTable[$name] = $null
    }
}
$authorTable

## Not a singular name option for functions (#26)
Get-Command -Module FabricTools |where Name -like '*s'
Get-Command -Module FabricTools|ForEach-Object { $name = $_.Name; $_.Parameters.Values | Where Name -like '*s' | Select @{N='FunctionName';E={$Name}},Name}
