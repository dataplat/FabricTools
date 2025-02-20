<#
.SYNOPSIS
Retrieves all refreshes for all datasets in all PowerBI workspaces.

.DESCRIPTION
The Get-AllFabricDatasetRefreshes function retrieves all refreshes for all datasets in all PowerBI workspaces. It supports multiple aliases for flexibility.

.EXAMPLE
Get-AllFabricDatasetRefreshes

This example retrieves all refreshes for all datasets in all PowerBI workspaces.

.NOTES
The function makes a GET request to the PowerBI API to retrieve the refreshes. It loops through each workspace and each dataset in each workspace. If a dataset is refreshable, it retrieves the refreshes for the dataset and selects the most recent one. It then creates a PSCustomObject with information about the refresh and adds it to an array of refreshes. Finally, it returns the array of refreshes.
#>

# This function retrieves all refreshes for all datasets in all PowerBI workspaces.
function Get-AllFabricDatasetRefreshes {
    # Define aliases for the function for flexibility.
    [Alias("Get-AllFabDatasetRefreshes")]

    # Retrieve all PowerBI workspaces.
    $wsps = Get-FabricWorkspace
    # Initialize an array to store the refreshes.
    $refs = @()
    # Loop through each workspace.
    foreach ($w in $wsps) {
        # Get a list of all the datasets in the workspace.
        $d = Get-FabricDataset -workspaceid $w.Id -ErrorAction SilentlyContinue
        # Loop through each dataset.
        foreach ($di in $d) {
            # Check if the dataset is refreshable.
            if ($di.isrefreshable ) {
                # Get a list of all the refreshes for the dataset.
                $results = (Invoke-PowerBIRestMethod -Method get -Url ("datasets/" + $di.id + "/Refreshes") | ConvertFrom-Json)
                # Select the most recent refresh.
                $results.value[0]
                # Create a PSCustomObject with the information about the refresh.
                $refresh = [PSCustomObject] @{
                    Clock        = Get-Date # Current date and time.
                    Workspace    = $w.name # Name of the workspace.
                    Dataset      = $di.Name # Name of the dataset.
                    refreshtype  = $results.value[0].refreshType # Type of the refresh.
                    startTime    = $results.value[0].startTime # Start time of the refresh.
                    endTime      = $results.value[0].endTime # End time of the refresh.
                    status       = $results.value[0].status # Status of the refresh.
                    ErrorMessage = $results.value[0].serviceExceptionJson # Error message of the refresh, if any.
                }
                # Add the refresh to the array of refreshes.
                $refs += $refresh
            }
        }
    }
    # Return the array of refreshes.
    return $refs
}