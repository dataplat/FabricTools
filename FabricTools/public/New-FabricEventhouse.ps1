function New-FabricEventhouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Eventhouse

.DESCRIPTION
    Creates a new Fabric Eventhouse

.PARAMETER WorkspaceID
    Id of the Fabric Workspace for which the Eventhouse should be created. The value for WorkspaceID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER EventhouseName
    The name of the Eventhouse to create.

.PARAMETER EventhouseDescription
    The description of the Eventhouse to create.

.EXAMPLE
    New-FabricEventhouse `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -EventhouseName 'MyEventhouse' `
        -EventhouseDescription 'This is my Eventhouse'

    This example will create a new Eventhouse with the name 'MyEventhouse' and the description 'This is my Eventhouse'.

.EXAMPLE
    New-FabricEventhouse `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -EventhouseName 'MyEventhouse' `
        -EventhouseDescription 'This is my Eventhouse' `
        -Verbose

    This example will create a new Eventhouse with the name 'MyEventhouse' and the description 'This is my Eventhouse'.
    It will also give you verbose output which is useful for debugging.

.NOTES
    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added DisplaName as Alias for EventhouseName
    - 2024-11-27 - FGE: Added Verbose Output


.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/eventhouse/items/create-eventhouse?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID,

        [Parameter(Mandatory=$true)]
        [Alias("Name", "DisplayName")]
        [string]$EventhouseName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$EventhouseDescription
    )

begin {
    Write-Verbose "Checking if session is established. If not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric Real-Time Intelligence. Please run Connect-FabricAccount"
    }

    # Create body of request
    $body = @{
    'displayName' = $EventhouseName
    'description' = $EventhouseDescription
    } | ConvertTo-Json `
            -Depth 1

    # Create Eventhouse API URL
    $eventhouseApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/eventhouses"
    }

process {

    Write-Verbose "Calling Eventhouse API"
    Write-Verbose "----------------------"
    Write-Verbose "Sending the following values to the Eventhouse API:"
    Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
    Write-Verbose "Method: POST"
    Write-Verbose "URI: $eventhouseApiUrl"
    Write-Verbose "Body of request: $body"
    Write-Verbose "ContentType: application/json"
    if($PSCmdlet.ShouldProcess($EventhouseName)) {
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method POST `
                            -Uri $eventhouseApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}