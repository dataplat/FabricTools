
<#
    .SYNOPSIS
        Imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source.

    .PARAMETER fileOverrides
        This parameter let's you override a PBIP file without altering the local file.

    .PARAMETER path
        The path to the PBIP files. Default value is '.\pbipOutput'.

    .PARAMETER workspaceId
        The ID of the Fabric workspace.

    .PARAMETER filter
        A filter to limit the search for PBIP files to specific folders.

    .EXAMPLE
        Import-FabricItems -path 'C:\PBIPFiles' -workspaceId '12345' -filter 'C:\PBIPFiles\Reports'

        This example imports PBIP files from the 'C:\PBIPFiles' folder into the Fabric workspace with ID '12345'. It only searches for PBIP files in the 'C:\PBIPFiles\Reports' folder.

    .NOTES
        This function requires the Invoke-FabricAPIRequest function to be available in the current session.
        This function was originally written by Rui Romano.
        https://github.com/RuiRomano/fabricps-pbip
    #>

Function Import-FabricItem {
    <#
    .SYNOPSIS
        Imports items using the Power BI Project format (PBIP) into a Fabric workspace from a specified file system source.

    .PARAMETER fileOverrides
        This parameter let's you override a PBIP file without altering the local file.
    #>
    [CmdletBinding()]
    param
    (
        [string]$path = '.\pbipOutput'
        ,
        [string]$workspaceId
        ,
        [string]$filter = $null
        ,
        [hashtable]$fileOverrides
    )

    # Search for folders with .pbir and .pbidataset in it

    $itemsFolders = Get-ChildItem  -Path $path -recurse -include *.pbir, *.pbidataset

    if ($filter) {
        $itemsFolders = $itemsFolders | where-object { $_.Directory.FullName -like $filter }
    }

    # Get existing items of the workspace

    $items = Invoke-FabricAPIRequest -Uri "workspaces/$workspaceId/items" -Method Get

    write-output "Existing items: $($items.Count)"

    # Datasets first

    $itemsFolders = $itemsFolders | Select-Object  @{n = "Order"; e = { if ($_.Name -like "*.pbidataset") { 1 } else { 2 } } }, * | sort-object Order

    $datasetReferences = @{}

    foreach ($itemFolder in $itemsFolders) {
        # Get the parent folder

        $itemPath = $itemFolder.Directory.FullName

        write-output "Processing item: '$itemPath'"

        $files = Get-ChildItem -Path $itemPath -Recurse -Attributes !Directory

        # Remove files not required for the API: item.*.json; cache.abf; .pbi folder

        $files = $files | Where-Object { $_.Name -notlike "item.*.json" -and $_.Name -notlike "*.abf" -and $_.Directory.Name -notlike ".pbi" }

        # There must be a item.metadata.json in the item folder containing the item type and displayname, necessary for the item creation

        $itemMetadataStr = Get-Content "$itemPath\item.metadata.json"
        if ($fileOverrides) {
        $fileOverrideMatch = $fileOverrides.GetEnumerator() | where-object { "$itemPath\item.metadata.json" -ilike $_.Name } | select-object -First 1

        if ($fileOverrideMatch) {
            $itemMetadataStr = $fileOverrideMatch.Value
        }
    }
        $itemMetadata = $itemMetadataStr | ConvertFrom-Json
        $itemType = $itemMetadata.type

        if ($itemType -ieq "dataset") {
            $itemType = "SemanticModel"
        }
        

        $displayName = $itemMetadata.displayName

        $itemPathAbs = Resolve-Path $itemPath

        $parts = $files | ForEach-Object {

            #$fileName = $_.Name
            $filePath = $_.FullName
            if ($fileOverrides) {
            $fileOverrideMatch = $fileOverrides.GetEnumerator() | Where-Object { $filePath -ilike $_.Name } | select-object -First 1
            }
            if ($fileOverrideMatch) {
                $fileContent = $fileOverrideMatch.Value

                # convert to byte array

                if ($fileContent -is [string]) {
                    $fileContent = [system.Text.Encoding]::UTF8.GetBytes($fileContent)
                }
                elseif (!($fileContent -is [byte[]])) {
                    throw "FileOverrides value type must be string or byte[]"
                }
            }
            else {
                if ($filePath -like "*.pbir") {

                    $pbirJson = Get-Content -Path $filePath | ConvertFrom-Json

                    if ($pbirJson.datasetReference.byPath -and $pbirJson.datasetReference.byPath.path) {

                        # try to swap byPath to byConnection

                        $reportDatasetPath = (Resolve-path (Join-Path $itemPath $pbirJson.datasetReference.byPath.path.Replace("/", "\"))).Path

                        $datasetReference = $datasetReferences[$reportDatasetPath]

                        if ($datasetReference) {
                            # $datasetName = $datasetReference.name
                            $datasetId = $datasetReference.id

                            $newPBIR = @{
                                "version"          = "1.0"
                                "datasetReference" = @{
                                    "byConnection" = @{
                                        "connectionString"          = $null
                                        "pbiServiceModelId"         = $null
                                        "pbiModelVirtualServerName" = "sobe_wowvirtualserver"
                                        "pbiModelDatabaseName"      = "$datasetId"
                                        "name"                      = "EntityDataSource"
                                        "connectionType"            = "pbiServiceXmlaStyleLive"
                                    }
                                }
                            } | ConvertTo-Json

                            $fileContent = [system.Text.Encoding]::UTF8.GetBytes($newPBIR)

                        }
                        else {
                            throw "Item API dont support byPath connection, switch the connection in the *.pbir file to 'byConnection'."
                        }
                    } else {
                        $fileContent = Get-Content -Path $filePath -AsByteStream -Raw
                    }
                }
                else {
                  
                    $fileContent = Get-Content -Path $filePath -AsByteStream -Raw
                }
            }
            
            $partPath = $filePath.Replace($itemPathAbs, "").TrimStart("\").Replace("\", "/")
            write-host "Processing part: '$partPath'"
            $fileEncodedContent = [Convert]::ToBase64String($fileContent)

            Write-Output @{
                Path        = $partPath
                Payload     = $fileEncodedContent
                PayloadType = "InlineBase64"
            }
        }

        $itemId = $null

        # Check if there is already an item with same displayName and type

        $foundItem = $items | Where-Object { $_.type -ieq $itemType -and $_.displayName -ieq $displayName }

        if ($foundItem) {
            if ($foundItem.Count -gt 1) {
                throw "Found more than one item for displayName '$displayName'"
            }

            Write-output "Item '$displayName' of type '$itemType' already exists." -ForegroundColor Yellow

            $itemId = $foundItem.id
        }

        if ($null -eq $itemId) {
            write-output "Creating a new item"

            # Prepare the request

            $itemRequest = @{
                displayName = $displayName
                type        = $itemType
                definition  = @{
                    Parts = $parts
                }
            } | ConvertTo-Json -Depth 3

            $createItemResult = Invoke-FabricAPIRequest -uri "workspaces/$workspaceId/items"  -method Post -body $itemRequest

            $itemId = $createItemResult.id

            write-output "Created a new item with ID '$itemId' $([datetime]::Now.ToString("s"))" -ForegroundColor Green

            Write-Output $itemId
        }
        else {
            write-output "Updating item definition"

            $itemRequest = @{
                definition = @{
                    Parts = $parts
                }
            } | ConvertTo-Json -Depth 3
            Invoke-FabricAPIRequest -Uri "workspaces/$workspaceId/items/$itemId/updateDefinition" -Method Post -Body $itemRequest

            write-output "Updated new item with ID '$itemId' $([datetime]::Now.ToString("s"))" -ForegroundColor Green

            Write-Output $itemId
        }

        # Save dataset references to swap byPath to byConnection

        if ($itemType -ieq "semanticmodel") {
            $datasetReferences[$itemPath] = @{"id" = $itemId; "name" = $displayName }
        }
    }

}
