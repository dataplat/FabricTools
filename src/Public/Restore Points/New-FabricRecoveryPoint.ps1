function New-FabricRecoveryPoint {
<#
.SYNOPSIS
Create a recovery point for a Fabric data warehouse

.DESCRIPTION
Create a recovery point for a Fabric data warehouse

.PARAMETER BaseUrl
Defaults to api.powerbi.com

.PARAMETER WorkspaceGUID
This is the workspace GUID in which the data warehouse resides.

.PARAMETER DataWarehouseGUID
The GUID for the data warehouse which we want to retrieve restore points for.

.EXAMPLE
PS> New-FabricRecoveryPoint

Create a new recovery point for the data warehouse specified in the configuration.

.EXAMPLE
    Create a new recovery point for the specified data warehouse, in the specified workspace.

    ```powershell
    New-FabricRecoveryPoint -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
    ```
.NOTES

Author: Jess Pomfret

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [guid]$WorkspaceGUID,

        [guid]$DataWarehouseGUID,

        [String]$BaseUrl = 'api.powerbi.com'
    )

    #region handle the config parameters
    if(-not $WorkspaceGUID) {
        $WorkspaceGUID = Get-PSFConfigValue -FullName FabricTools.WorkspaceGUID
    }

    if(-not $DataWarehouseGUID) {
        $DataWarehouseGUID = Get-PSFConfigValue -FullName FabricTools.DataWarehouseGUID
    }

    if(-not $BaseUrl) {
        $BaseUrl = Get-PSFConfigValue -FullName FabricTools.BaseUrl
    }

    if (-not $WorkspaceGUID -or -not $DataWarehouseGUID -or -not $BaseUrl) {
        Stop-PSFFunction -Message 'WorkspaceGUID, DataWarehouseGUID, and BaseUrl are required parameters. Either set them with Set-FabricConfig or pass them in as parameter values' -EnableException $true
    } else {
        Write-PSFMessage -Level Verbose -Message ('WorkspaceGUID: {0}; DataWarehouseGUID: {1}; BaseUrl: {2}' -f $WorkspaceGUID, $DataWarehouseGUID, $BaseUrl)
    }
    #endregion

    if ($PSCmdlet.ShouldProcess("Create a recovery point for a Fabric Data Warehouse")) {
        #region setting up the API call
        try {
            # Get token and setup the uri
            $getUriParam = @{
                BaseUrl = $BaseUrl
                WorkspaceGUID = $WorkspaceGUID
                DataWarehouseGUID = $DataWarehouseGUID
            }
            $iwr = Get-FabricUri @getUriParam
        } catch {
            Stop-PSFFunction -Message 'Failed to get Fabric URI - check authentication and parameters.' -ErrorRecord $_ -EnableException $true
        }
        #endregion

        #region call the API
        if (-not $iwr) {
            Stop-PSFFunction -Message 'No URI received from API - check authentication and parameters.' -ErrorRecord $_ -EnableException $true
        } else {
            $command = [PSCustomObject]@{
                Commands = @(@{
                    '$type' = 'WarehouseCreateRestorePointCommand'
                })
            }

            try {
                # add the body and invoke
                $iwr.Add('Body', ($command | ConvertTo-Json -Compress))
                $content = Invoke-WebRequest @iwr

                if($content) {
                    # change output to be a PowerShell object and view new restore point
                    #TODO: output - select default view but return more?
                    ($content.Content | ConvertFrom-Json) | Select-Object progressState,@{l='type';e={$_.operationInformation.progressDetail.restorePoint.type}},@{l='createTime';e={get-date($_.operationInformation.progressDetail.restorePoint.createTime) -format 'yyyy-MM-ddTHH:mm:ssZ'}},@{l='friendlyCreateTime';e={$_.operationInformation.progressDetail.restorePoint.createTime}}, @{l='label';e={$_.operationInformation.progressDetail.restorePoint.label}}, @{l='createMode';e={$_.operationInformation.progressDetail.restorePoint.createMode}}, @{l='description';e={$_.operationInformation.progressDetail.restorePoint.description}}, @{l='createdByUserObjectId';e={$_.operationInformation.progressDetail.restorePoint.createdByUserObjectId}}, @{l='lastModifiedByUserObjectId';e={$_.operationInformation.progressDetail.restorePoint.lastModifiedByUserObjectId}}, @{l='lastModifiedTime';e={$_.operationInformation.progressDetail.restorePoint.lastModifiedTime}}
                } else {
                    Stop-PSFFunction -Message 'No Content received from API - check authentication and parameters.' -ErrorRecord $_ -EnableException $true
                }
            } catch {
                Stop-PSFFunction -Message 'Issue calling Invoke-WebRequest' -ErrorRecord $_ -EnableException $true
            }
        }
        #endregion
    }
}
