function Remove-FabricEnvironmentStagingLibrary
{
    <#
.SYNOPSIS
Deletes a specified library from the staging environment in a Microsoft Fabric workspace.

.DESCRIPTION
This function allows for the deletion of a library from the staging environment, one file at a time.
It ensures token validity, constructs the appropriate API request, and handles both success and failure responses.

.PARAMETER WorkspaceId
The unique identifier of the workspace from which the library is to be deleted.

.PARAMETER EnvironmentId
The unique identifier of the staging environment containing the library.

.PARAMETER LibraryName
The name of the library to be deleted from the environment.

.EXAMPLE
    Deletes the specified library from the staging environment in the specified workspace.

    ```powershell
    Remove-FabricEnvironmentStagingLibrary -WorkspaceId "workspace-12345" -EnvironmentId "environment-67890" -LibraryName "library-to-delete"
    ```

.NOTES
- Validates token expiration before making the API request.
- This function currently supports deleting one library at a time.

Author: Tiago Balabuch, Kamil Nowinski

    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [guid]$EnvironmentId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LibraryName
    )

    # Ensure token validity
    Confirm-TokenState

    if ($PSCmdlet.ShouldProcess($LibraryName, "Remove Staging Library"))
    {
        $apiParams = @{
            Uri            = "workspaces/$WorkspaceId/environments/$EnvironmentId/staging/libraries?libraryToDelete=$LibraryName"
            Method         = 'Delete'
            TypeName       = 'Environment'
            ObjectIdOrName = $LibraryName
            HandleResponse = $true
        }

        Invoke-FabricRestMethod @apiParams
        Write-Message -Message "Staging library $LibraryName for the Environment '$EnvironmentId' deleted successfully from workspace '$WorkspaceId'." -Level Info
    }
}
