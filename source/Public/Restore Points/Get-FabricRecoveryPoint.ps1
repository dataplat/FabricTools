<#
.SYNOPSIS
Get a list of Fabric recovery points.

.DESCRIPTION
Get a list of Fabric recovery points. Results can be filter by date or type.

.PARAMETER BaseUrl
Defaults to api.powerbi.com

.PARAMETER WorkspaceGUID
This is the workspace GUID in which the data warehouse resides.

.PARAMETER DataWarehouseGUID
The GUID for the data warehouse which we want to retrieve restore points for.

.PARAMETER Since
Filter the results to only include restore points created after this date.

.PARAMETER Type
Filter the results to only include restore points of this type.

.PARAMETER CreateTime
The specific unique time of the restore point to remove. Get this from Get-FabricRecoveryPoint.

.EXAMPLE
PS> Get-FabricRecoveryPoint -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'

Gets all the available recovery points for the specified data warehouse, in the specified workspace.

.NOTES
Based on API calls from this blog post: https://blog.fabric.microsoft.com/en-US/blog/the-art-of-data-warehouse-recovery-within-microsoft-fabric/

Author: Jess Pomfret

#>

function Get-FabricRecoveryPoint {
    param (
        [String]$WorkspaceGUID,

        [String]$DataWarehouseGUID,

        [String]$BaseUrl = 'api.powerbi.com',

        [DateTime]$Since,

        [ValidateSet("automatic", "userDefined")]
        [string]$Type,
        #TODO: accept a list of times
        [string]$CreateTime

    )

    #region handle the config parameters
    if(-not $WorkspaceGUID) {
        $WorkspaceGUID = Get-PSFConfigValue -FullName PSFabricTools.WorkspaceGUID
    }

    if(-not $DataWarehouseGUID) {
        $DataWarehouseGUID = Get-PSFConfigValue -FullName PSFabricTools.DataWarehouseGUID
    }

    if(-not $BaseUrl) {
        $BaseUrl = Get-PSFConfigValue -FullName PSFabricTools.BaseUrl
    }

    if (-not $WorkspaceGUID -or -not $DataWarehouseGUID -or -not $BaseUrl) {
        Stop-PSFFunction -Message 'WorkspaceGUID, DataWarehouseGUID, and BaseUrl are required parameters. Either set them with Set-FabricConfig or pass them in as parameter values' -EnableException $true
    } else {
        Write-PSFMessage -Level Verbose -Message ('WorkspaceGUID: {0}; DataWarehouseGUID: {1}; BaseUrl: {2}' -f $WorkspaceGUID, $DataWarehouseGUID, $BaseUrl)
    }
    #endregion

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

        # set the body to list restore points
        $command = [PSCustomObject]@{
            Commands = @(@{
                '$type' = 'WarehouseListRestorePointsCommand'
            })
        }

        try {
            # add the body and invoke
            $iwr.Add('Body', ($command | ConvertTo-Json -Compress))
            $content = Invoke-WebRequest @iwr

            if($content) {
                # change output to be a PowerShell object and view restore points
                $restorePoints = ($content.Content | ConvertFrom-Json).operationInformation.progressDetail.restorePoints

                if($CreateTime) {
                    $restorePoints = $restorePoints | Select-Object @{l='createTimeWhere';e={get-date($_.createTime) -Format 'yyyy-MM-ddTHH:mm:ssZ'}}, *  | Where-Object createTimeWhere -eq $createTime
                }

                if($Since) {
                    $restorePoints = $restorePoints | Where-Object { $_.createTime -gt $Since }
                }

                if($Type) {
                    $restorePoints = $restorePoints | Where-Object { $_.createMode -eq $Type }
                }

                $restorePoints | Select-Object @{l='createTime';e={get-date($_.createTime) -Format 'yyyy-MM-ddTHH:mm:ssZ'}}, @{l='friendlyCreateTime';e={$_.createTime}}, label, createMode, type, createdByUserObjectId | Sort-Object createTime
                #TODO: default view rather than select\sort?
            } else {
                Stop-PSFFunction -Message 'No Content received from API - check authentication and parameters.' -ErrorRecord $_ -EnableException $true
            }
        } catch {
            Stop-PSFFunction -Message 'Issue calling Invoke-WebRequest' -ErrorRecord $_ -EnableException $true
        }
    }
    #endregion
}
