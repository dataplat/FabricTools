$path = ".\FabricTools\public"
$op = Get-ChildItem -Path $path -Recurse -Filter *.ps1 | Select-Object -ExpandProperty Name | Sort-Object
#$op = $op | ForEach-Object { "        ""$_""," }
$op | Out-File '.\Output\FunctionList-main-public.txt'

$path = ".\FabricTools\tiago\public"
$tp = Get-ChildItem -Path $path -Recurse -Filter *.ps1 | Select-Object -ExpandProperty Name | Sort-Object
$tp | Out-File '.\Output\FunctionList-tiago-public.txt'

$common = Compare-Object -ReferenceObject $op -DifferenceObject $tp -IncludeEqual -ExcludeDifferent | Select-Object -ExpandProperty InputObject
$common
$common | Out-File '.\Output\FunctionList-public-collision.txt'
