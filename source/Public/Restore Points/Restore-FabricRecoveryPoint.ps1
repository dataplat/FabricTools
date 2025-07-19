function Restore-FabricRecoveryPoint {
<#
.SYNOPSIS
Restore a Fabric data warehouse to a specified restore pont.

.DESCRIPTION
Restore a Fabric data warehouse to a specified restore pont.

.PARAMETER CreateTime
The specific unique time of the restore point to remove. Get this from Get-FabricRecoveryPoint.

.PARAMETER BaseUrl
Defaults to api.powerbi.com

.PARAMETER WorkspaceGUID
This is the workspace GUID in which the data warehouse resides.

.PARAMETER DataWarehouseGUID
The GUID for the data warehouse which we want to retrieve restore points for.

.PARAMETER Wait
Wait for the restore to complete before returning.

.EXAMPLE
    Restore a Fabric Data Warehouse to a specific restore point that has been set using Set-FabricConfig.

    ```powershell
    Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z'
    ```

.EXAMPLE
    Restore a Fabric Data Warehouse to a specific restore point, specifying the workspace and data warehouse GUIDs.

    ```powershell
    Restore-FabricRecoveryPoint -CreateTime '2024-07-23T11:20:26Z' -WorkspaceGUID 'GUID-GUID-GUID-GUID' -DataWarehouseGUID 'GUID-GUID-GUID-GUID'
    ```

.NOTES

Author: Jess Pomfret

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string]$CreateTime,

        [guid]$WorkspaceGUID,

        [guid]$DataWarehouseGUID,

        [String]$BaseUrl = 'api.powerbi.com',

        [switch]$Wait

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

    if ($PSCmdlet.ShouldProcess("Recover a Fabric Data Warehouse to a restore point")) {
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

            #region check restore point exists
            #Get the restore point to make sure it exists before we try and restore to it
            $getSplat = @{
                WorkspaceGUID = $WorkspaceGUID
                DataWarehouseGUID = $DataWarehouseGUID
                BaseUrl = $BaseUrl
                CreateTime = $CreateTime
            }

            try {
                if(Get-FabricRecoveryPoint @getSplat) {
                    Write-PSFMessage -Level Verbose -Message ('WorkspaceGUID: {0}; DataWarehouseGUID: {1}; BaseUrl: {2}; CreateTime: {3} - restore point exists' -f $WorkspaceGUID, $DataWarehouseGUID, $BaseUrl, $CreateTime)
                } else {
                    Stop-PSFFunction -Message ('WorkspaceGUID: {0}; DataWarehouseGUID: {1}; BaseUrl: {2}; CreateTime: {3} - restore point not found!' -f $WorkspaceGUID, $DataWarehouseGUID, $BaseUrl, $CreateTime) -ErrorRecord $_ -EnableException $true
                }
            } catch {
                Stop-PSFFunction -Message 'Issue calling Get-FabricRecoveryPoint to check restore point exists before attempting recovery' -ErrorRecord $_ -EnableException $true
            }
            #endregion

            #region recover to the restore point
            # command is now WarehouseRestoreInPlaceCommand and the RestorePoint is the create time of the specific restore point to use
            $command = [PSCustomObject]@{
                commands = @([ordered]@{
                    '$type' = 'WarehouseRestoreInPlaceCommand'
                    'RestorePoint' = $CreateTime
                })
            }

            try {
                # add the body and invoke
                $iwr.Add('Body', ($command | ConvertTo-Json -Compress))
                $content = Invoke-WebRequest @iwr

                if($content) {
                    #TODO: output - select default view but return more?
                    $content = ($content.Content | ConvertFrom-Json)
                } else {
                    Stop-PSFFunction -Message 'No Content received from API - check authentication and parameters.' -ErrorRecord $_ -EnableException $true
                }
            } catch {
                Stop-PSFFunction -Message 'Issue calling Invoke-WebRequest' -ErrorRecord $_ -EnableException $true
            }
            #endregion

            #region check the progress of the restore
            if ($Wait) {
                # we need to append batches to the uri
                try {

                    while($Wait) {
                        # Get token and setup the uri
                        $getUriParam = @{
                            BaseUrl = $BaseUrl
                            WorkspaceGUID = $WorkspaceGUID
                            DataWarehouseGUID = $DataWarehouseGUID
                            BatchId = $content.batchId
                        }
                        $iwr = Get-FabricUri @getUriParam

                        $restoreProgress = ((Invoke-WebRequest @iwr).Content | ConvertFrom-Json)

                        if($restoreProgress.progressState -eq 'inProgress') {
                            Write-PSFMessage -Level Output -Message 'Restore in progress'
                        } elseif ($restoreProgress.progressState -eq 'success') {
                            Write-PSFMessage -Level Output -Message 'Restore completed successfully'
                            $restoreProgress | Select-Object progressState, @{l='startDateTimeUtc';e={$_.startTimeStamp }}, @{l='RestorePointCreateTime';e={$CreateTime }}
                            $wait = $false
                            break
                        } else {
                            Write-PSFMessage -Level Output -Message 'Restore failed'
                            $restoreProgress | Select-Object progressState, @{l='startDateTimeUtc';e={$_.startTimeStamp }}
                            $wait = $false
                            break
                        }

                        # wait a few seconds
                        Start-Sleep -Seconds 3
                    }
                } catch {
                    Stop-PSFFunction -Message 'Failed to get Fabric URI for the batchId - check authentication and parameters.' -ErrorRecord $_ -EnableException $true
                }

            } else {
                Write-PSFMessage -Level Output -Message 'Restore in progress - use the -Wait parameter to wait for restore to complete'
                $content
            }
        }
        #endregion
    }
}
