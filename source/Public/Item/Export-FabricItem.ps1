<#
.SYNOPSIS
Exports items from a Fabric workspace. Either all items in a workspace or a specific item.

.DESCRIPTION
The Export-FabricItem function exports items from a Fabric workspace to a specified directory. It can export items of type "Report", "SemanticModel", "SparkJobDefinitionV1" or "Notebook". If a specific item ID is provided, only that item will be exported. Otherwise, all items in the workspace will be exported.

.PARAMETER path
The path to the directory where the items will be exported. The default value is '.\pbipOutput'.

.PARAMETER workspaceId
The ID of the Fabric workspace.

.PARAMETER filter
A script block used to filter the items to be exported. Only items that match the filter will be exported. The default filter includes items of type "Report", "SemanticModel", "SparkJobDefinitionV1" or "Notebook".

.PARAMETER itemID
The ID of the specific item to export. If provided, only that item will be exported.

.EXAMPLE
Export-FabricItem -workspaceId "12345678-1234-1234-1234-1234567890AB" -path "C:\ExportedItems"

This example exports all items from the Fabric workspace with the specified ID to the "C:\ExportedItems" directory.

.EXAMPLE
Export-FabricItem -workspaceId "12345678-1234-1234-1234-1234567890AB" -itemID "98765432-4321-4321-4321-9876543210BA" -path "C:\ExportedItems"

This example exports the item with the specified ID from the Fabric workspace with the specified ID to the "C:\ExportedItems" directory.

.NOTES

Author: Rui Romano

This function is based on the Export-FabricItems function written by Rui Romano.
https://github.com/microsoft/Analysis-Services/tree/master/pbidevmode/fabricps-pbip

#>
Function Export-FabricItem {
    [Alias("Export-FabItem")]
    [CmdletBinding()]
    param
    (
        [string]$path = '.\pbipOutput',
        [guid]$WorkspaceId = '',
        [scriptblock]$filter = { $_.type -in @("Report", "SemanticModel", "Notebook", "SparkJobDefinitionV1") },
        [guid]$itemID = $null
    )
    if (-not $itemID) {
        # Invoke the Fabric API to get the specific item in the workspace

        $item = Invoke-FabricRestMethod -Uri "workspaces/$workspaceId/items/$itemID/getDefinition" -Method POST
        # If a filter is provided


        $parts = $item.definition.parts

        if (!(Test-Path $path)) {
            New-Item -ItemType Directory -Force -Path $path
        }


        foreach ($part in $parts) {
            $filename = $part.path
            $payload = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($part.payload))
            $payload | Out-File -FilePath "$path\$filename"
        }

        # Display a message indicating the items were exported
        Write-Output "Items exported to $path"
    } else {
        $items = Invoke-FabricRestMethod -Uri "workspaces/$workspaceId/items" -Method Get

        if ($filter) {
            $items = $items.value | Where-Object $filter
        } else {
            $items = $items.value
        }

        Write-Output "Existing items: $($items.Count)"

        foreach ($item in $items) {
            $itemId = $item.id
            $itemName = $item.displayName
            $itemType = $item.type
            $itemOutputPath = "$path\$workspaceId\$($itemName).$($itemType)"

            if ($itemType -in @("report", "semanticmodel", "notebook", "SparkJobDefinitionV1", "DataPipeline")) {
                Write-Output "Getting definition of: $itemId / $itemName / $itemType"

                $response = Invoke-FabricRestMethod -Uri "workspaces/$workspaceId/items/$itemId/getDefinition" -Method Post

                $partCount = $response.definition.parts.Count

                Write-Output "Parts: $partCount"
                if ($partCount -gt 0) {
                    foreach ($part in $response.definition.parts) {
                        Write-Output "Saving part: $($part.path)"
                        $outputFilePath = "$itemOutputPath\$($part.path.Replace("/", "\"))"

                        New-Item -ItemType Directory -Path (Split-Path $outputFilePath -Parent) -ErrorAction SilentlyContinue | Out-Null
                        $payload = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($part.payload))
                        $payload | Out-File -FilePath "$outputFilePath"

                    }

                    @{
                        "type"        = $itemType
                        "displayName" = $itemName

                    } | ConvertTo-Json | Out-File "$itemOutputPath\item.metadata.json"
                }
            } else {
                Write-Output "Type '$itemType' not available for export."
            }
        }
    }
}
