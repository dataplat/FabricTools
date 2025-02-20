<#
.SYNOPSIS
   Retrieves the refresh history of all datasets in a specified PowerBI workspace.

.DESCRIPTION
   The Get-FabricWorkspaceDatasetRefreshes function uses the PowerBI cmdlets to retrieve the refresh history of all datasets in a specified workspace.
   It uses the workspace ID to get the workspace and its datasets, and then retrieves the refresh history for each dataset.

.PARAMETER WorkspaceID
   The ID of the PowerBI workspace. This is a mandatory parameter.

.EXAMPLE
   Get-FabricWorkspaceDatasetRefreshes -WorkspaceID "12345678-90ab-cdef-1234-567890abcdef"

   This command retrieves the refresh history of all datasets in the workspace with the specified ID.

.INPUTS
   String. You can pipe a string that contains the workspace ID to Get-FabricWorkspaceDatasetRefreshes.

.OUTPUTS
   Array. Get-FabricWorkspaceDatasetRefreshes returns an array of refresh history objects.

.NOTES
   Alias: Get-PowerBIWorkspaceDatasetRefreshes, Get-FabWorkspaceDatasetRefreshes
#>

# Define a function to get the refresh history of all datasets in a PowerBI workspace
function Get-FabricWorkspaceDatasetRefreshes {
    # Set aliases for the function
    [Alias("Get-FabWorkspaceDatasetRefreshes")]
    param(
        # Define a mandatory parameter for the workspace ID
        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID
    )
    # Get the workspace using the workspace ID
    $wsp = Get-FabricWorkspace -workspaceid $WorkspaceID
    # Initialize an array to store the refresh history
    $refs = @()
    # Get all datasets in the workspace
    $datasets = Get-FabricDataset -workspaceid $wsp.Id

    # Loop over each dataset
    foreach ($dataset in $datasets) {
        # Get the refresh history of the dataset and add it to the array
        $refs += Get-FabricDatasetRefreshes -datasetid $dataset.Id -workspaceId $wsp.Id
    }
    # Return the refresh history array
    return $refs
}