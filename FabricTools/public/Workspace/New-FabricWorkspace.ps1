<#
.SYNOPSIS
   Creates a new Fabric workspace.

.DESCRIPTION
   The New-FabricWorkspace function creates a new Fabric workspace. It uses the provided name to create the workspace. If the workspace already exists and the skipErrorIfExists switch is provided, it does not throw an error.

.PARAMETER Name
   The name of the new Fabric workspace. This is a mandatory parameter.

.PARAMETER SkipErrorIfExists
   A switch that indicates whether to skip the error if the workspace already exists. If provided, the function does not throw an error if the workspace already exists.

.EXAMPLE
   New-FabricWorkspace -Name "NewWorkspace" -SkipErrorIfExists

   This command creates a new Fabric workspace named "NewWorkspace". If the workspace already exists, it does not throw an error.

.INPUTS
   String, Switch. You can pipe a string that contains the name and a switch that indicates whether to skip the error if the workspace already exists to New-FabricWorkspace.

.OUTPUTS
   String. This function returns the ID of the new Fabric workspace.

.NOTES
   This function was originally written by Rui Romano.
   https://github.com/RuiRomano/fabricps-pbip
#>

Function New-FabricWorkspace {
    <#
    .SYNOPSIS
        Creates a new Fabric workspace.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param
    (
        [string]$name,
        [switch]$skipErrorIfExists
    )

    # Create a request body for the Fabric API
    $itemRequest = @{
        displayName = $name
    } | ConvertTo-Json

    try {
        # Invoke the Fabric API to create the workspace
        if ($PSCmdlet.ShouldProcess("workspaces", "create")) {
            $createResult = Invoke-FabricAPIRequest -Uri "workspaces" -Method Post -Body $itemRequest

            # Display a message indicating the workspace was created
            Write-Output "Workspace created"

            # Output the ID of the new workspace
            Write-Output $createResult.id
        }
    }
    catch {
        $ex = $_.Exception

        if ($skipErrorIfExists) {
            if ($ex.Message -ilike "*409*") {
                Write-Output "Workspace already exists"

                $listWorkspaces = Invoke-FabricAPIRequest -Uri "workspaces" -Method Get

                $workspace = $listWorkspaces | Where-Object { $_.displayName -ieq $name }

                if (!$workspace) {
                    throw "Cannot find workspace '$name'"
                }
                Write-Output $workspace.id
            }
            else {
                throw
            }
        }
    }
}
