function Get-FabricDatasetRefreshes {
   <#
   .SYNOPSIS
      Retrieves the refresh history of a specified dataset in a PowerBI workspace.

   .DESCRIPTION
      The Get-FabricDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of a specified dataset in a workspace. It uses the dataset ID and workspace ID to get the dataset and checks if it is refreshable. If it is, the function retrieves the refresh history.

   .PARAMETER DatasetID
      The ID of the dataset. This is a mandatory parameter.

   .PARAMETER workspaceId
      The ID of the workspace. This is a mandatory parameter.

   .EXAMPLE
      This command retrieves the refresh history of the specified dataset in the specified workspace.

      ```powershell
      Get-FabricDatasetRefreshes -DatasetID "12345678-90ab-cdef-1234-567890abcdef" -workspaceId "abcdef12-3456-7890-abcd-ef1234567890"
      ```

   .INPUTS
      String. You can pipe two strings that contain the dataset ID and workspace ID to Get-FabricDatasetRefreshes.

   .OUTPUTS
      Object. Get-FabricDatasetRefreshes returns an object that contains the refresh history.

   .NOTES
      Author: Ioana Bouariu

   #>
    # Define aliases for the function for flexibility.

    # Define a mandatory parameter for the dataset ID.
    Param (
        [Parameter(Mandatory = $true)]
        [guid]$DatasetID,
        [Parameter(Mandatory = $true)]
        [guid]$workspaceId
    )

    # Get the dataset information.
    $di = Get-PowerBIDataset -id $DatasetID -WorkspaceId $workspaceId

    # Check if the dataset is refreshable.
    if ($di.isrefreshable -eq "True") {
        # Get a list of all the refreshes for the dataset.
        $results = Invoke-FabricRestMethod -Method get -PowerBIApi -uri ("datasets/" + $di.id + "/Refreshes")

        # Create a PSCustomObject with the information about the refresh.
        $refresh = [PSCustomObject]@{
            Clock        = Get-Date
            WorkspaceId  = $workspaceId
            Workspace    = $w.name
            DatasetId    = $di.Id
            Dataset      = $di.Name
            RefreshType  = $results.value[0].refreshType
            startTime    = $results.value[0].startTime
            endTime      = $results.value[0].endTime
            status       = $results.value[0].status
            ErrorMessage = $results.value[0].serviceExceptionJson
        }

        # Return the PSCustomObject.
        return $refresh
    } else {
        # If the dataset is not refreshable, return null.
        Write-Warning "Dataset is not refreshable."
        return $null
    }


}
