function New-FabricWorkspace2 {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Workspace

.DESCRIPTION
    Creates a new Fabric Workspace

.PARAMETER CapacityID
    Id of the Fabric Capacity for which the Workspace should be created. The value for CapacityID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER WorkspaceName
    The name of the Workspace to create. This parameter is mandatory.

.PARAMETER WorkspaceDescription
    The description of the Workspace to create.

.EXAMPLE
    New-FabricWorkspace `
        -CapacityID '12345678-1234-1234-1234-123456789012' `
        -WorkspaceName 'TestWorkspace' `
        -WorkspaceDescription 'This is a Test Workspace'

    This example will create a new Workspace with the name 'TestWorkspace' and the description 'This is a test workspace'.

.NOTES
    Revsion History:

    - 2024-12-22 - FGE: Added Verbose Output
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$CapacityId,

        [Parameter(Mandatory=$true)]
        [Alias("Name", "DisplayName")]
        [string]$WorkspaceName,

        [ValidateLength(0, 4000)]
        [Alias("Description")]
        [string]$WorkspaceDescription
    )

begin {
    Confirm-FabricAuthToken | Out-Null

    Write-Verbose "Create body of request"
    $body = @{
        'displayName' = $WorkspaceName
        'description' = $WorkspaceDescription
        'capacityId'  = $CapacityId
    } | ConvertTo-Json `
            -Depth 1

    Write-Verbose "Create Workspace API URL"
    $WorkspaceApiUrl = "$($FabricSession.BaseApiUrl)/workspaces"
    }

process {

    if($PSCmdlet.ShouldProcess($WorkspaceName)) {
        Write-Verbose "Calling Workspace API"
        Write-Verbose "---------------------"
        Write-Verbose "Sending the following values to the Workspace API:"
        Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
        Write-Verbose "Method: POST"
        Write-Verbose "URI: $WorkspaceApiUrl"
        Write-Verbose "Body of request: $body"
        Write-Verbose "ContentType: application/json"
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method POST `
                            -Uri $WorkspaceApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}