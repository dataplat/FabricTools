function New-FabricLakehouse {
#Requires -Version 7.1

<#
.SYNOPSIS
    Creates a new Fabric Lakehouse

.DESCRIPTION
    Creates a new Fabric Lakehouse

.PARAMETER WorkspaceID
    Id of the Fabric Workspace for which the Lakehouse should be created. The value for WorkspaceID is a GUID.
    An example of a GUID is '12345678-1234-1234-1234-123456789012'.

.PARAMETER LakehouseName
    The name of the Lakehouse to create.

.PARAMETER LakehouseDescription
    The description of the Lakehouse to create.

.EXAMPLE
    New-FabricLakehouse `
        -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -LakehouseName 'MyLakehouse' `
        -LakehouseSchemaEnabled $true `
        -LakehouseDescription 'This is my Lakehouse'

    This example will create a new Lakehouse with the name 'MyLakehouse' and the description 'This is my Lakehouse'.

  .EXAMPLE
  New-FabricLakehouse `
      -WorkspaceID '12345678-1234-1234-1234-123456789012' `
        -LakehouseName 'MyLakehouse' `
        -LakehouseSchemaEnabled $true `
        -LakehouseDescription 'This is my Lakehouse'
        -Verbose
  
    This example will create a new Lakehouse with the name 'MyLakehouse' and the description 'This is my Lakehouse'.
    It will also give you verbose output which is useful for debugging.

.NOTES

.LINK
    https://learn.microsoft.com/en-us/rest/api/fabric/lakehouse/items/create-lakehouse?tabs=HTTP
#>

[CmdletBinding(SupportsShouldProcess)]
    param (

        [Parameter(Mandatory=$true)]
        [string]$WorkspaceID,

        [Parameter(Mandatory=$true)]
        [Alias("Name", "DisplayName")]
        [string]$LakehouseName,

        [Parameter(Mandatory=$true)]
        [Alias("Schema", "SchemaEnabled")]
        [bool]$LakehouseSchemaEnabled,

        [ValidateLength(0, 256)]
        [Alias("Description")]
        [string]$LakehouseDescription
    )

begin {
    Write-Verbose "Checking if session is established. If not throw error"
    if ($null -eq $FabricSession.headerParams) {
        throw "No session established to Fabric. Please run Connect-FabricAccount"
    }

    #create payload
    $body = [ordered]@{
        'displayName' = $LakehouseName
        'description' = $LakehouseDescription
    }

    #add enableSchema element if $LakehouseSchemaEnabled is true
    if ($LakehouseSchemaEnabled) {
        $body['creationPayload'] = @{
            'enableSchemas' = $LakehouseSchemaEnabled
        }
    }    

    #format payload
    $body = $body | ConvertTo-Json -Depth 1 

    # Create Eventhouse API URL
    $lakehouseApiUrl = "$($FabricSession.BaseFabricUrl)/v1/workspaces/$WorkspaceId/lakehouses"
    }

process {

    Write-Verbose "Calling Lakehouse API"
    Write-Verbose "----------------------"
    Write-Verbose "Sending the following values to the Lakehouse API:"
    Write-Verbose "Headers: $($FabricSession.headerParams | Format-List | Out-String)"
    Write-Verbose "Method: POST"
    Write-Verbose "URI: $lakehouseApiUrl"
    Write-Verbose "Body of request: $bodyJson"
    Write-Verbose "ContentType: application/json"
    if($PSCmdlet.ShouldProcess($LakehouseName)) {
        $response = Invoke-RestMethod `
                            -Headers $FabricSession.headerParams `
                            -Method POST `
                            -Uri $lakehouseApiUrl `
                            -Body ($body) `
                            -ContentType "application/json"

        $response
    }
}

end {}

}
