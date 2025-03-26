function Set-FabricKQLQueryset {
#Requires -Version 7.1

<#
.SYNOPSIS
    Updates Properties of an existing Fabric KQLQueryset

.DESCRIPTION
    Updates Properties of an existing Fabric KQLQueryset. The KQLQueryset is identified by
    the WorkspaceId and KQLQuerysetId.

.PARAMETER WorkspaceId
    Id of the Fabric Workspace for which the KQLQueryset should be updated. The value for WorkspaceId is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'. This parameter is mandatory.

.PARAMETER KQLQuerysetId
    The Id of the KQLQueryset to update. The value for KQLQuerysetId is a GUID. An example of a GUID is '12345678-1234-1234-1234-123456789012'.
    This parameter is mandatory.

.PARAMETER KQLQuerysetName
    The new name of the KQLQueryset. This parameter is optional.

.PARAMETER KQLQuerysetDescription
    The new description of the KQLQueryset. This parameter is optional.

.EXAMPLE
    Set-FabricKQLQueryset `
        -WorkspaceId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetId '12345678-1234-1234-1234-123456789012' `
        -KQLQuerysetNewName 'MyKQLQueryset' `
        -KQLQuerysetDescription 'This is my KQLQueryset'

    This example will update the KQLQueryset. The KQLQueryset will have the name 'MyKQLQueryset'
    and the description 'This is my KQLQueryset'.

.NOTES

    Revsion History:

    - 2024-11-07 - FGE: Implemented SupportShouldProcess
    - 2024-11-09 - FGE: Added NewDisplaName as Alias for KQLQuerysetNewName
    - 2024-12-22 - FGE: Added Verbose Output

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/KQLQueryset/items/create-KQLQueryset?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory=$true)]
        [Alias("Id")]
        [string]$KQLQuerysetId,

        [Alias("NewName", "NewDisplayName")]
        [string]$KQLQuerysetNewName,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$KQLQuerysetDescription
    )

begin {
    Confirm-FabricAuthToken | Out-Null

    Write-Verbose "Create body of request"
    $body = @{}

    if ($PSBoundParameters.ContainsKey("KQLQuerysetName")) {
        $body["displayName"] = $KQLQuerysetNName
    }

    if ($PSBoundParameters.ContainsKey("KQLQuerysetDescription")) {
        $body["description"] = $KQLQuerysetDescription
    }

    $body = $body | ConvertTo-Json -Depth 1

    # Create KQLQueryset API URL
    $KQLQuerysetApiUrl = "$($FabricSession.BaseApiUrl)/workspaces/$WorkspaceId/KQLQuerysets/$KQLQuerysetId"
    }

process {

    # Call KQLQueryset API
        if($PSCmdlet.ShouldProcess($KQLQuerysetId)) {
            Write-Verbose "Calling KQLQueryset API with KQLQuerysetId $KQLQuerysetId"
            Write-Verbose "---------------------------------------------------------"
            Write-Verbose "Sending the following values to the KQLQueryset API:"
            Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
            Write-Verbose "Method: PATCH"
            Write-Verbose "URI: $KQLQuerysetApiUrl"
            Write-Verbose "Body of request: $body"
            Write-Verbose "ContentType: application/json"
            $response = Invoke-RestMethod `
                                -Headers $FabricSession.headerParams `
                                -Method PATCH `
                                -Uri $KQLQuerysetApiUrl `
                                -Body ($body) `
                                -ContentType "application/json"

            $response
        }
}

end {}

}