function Remove-FabricConnection {
    <#
    .SYNOPSIS
        Removes a Fabric connection.

    .PARAMETER ConnectionId
        The ID of the connection to remove.

    .EXAMPLE
        Remove-FabricConnection -ConnectionId '11111111-1111-1111-1111-111111111111'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Id')]
        [guid]$ConnectionId
    )

    if (-not $PSCmdlet.ShouldProcess("Connection '$ConnectionId'", 'Remove connection')) {
        return
    }
    $apiParams = @{
        Uri              = "connections/$ConnectionId"
        Method           = 'Delete'
        TypeName         = 'Connection'
        ObjectIdOrName   = $ConnectionId
        HandleResponse   = $true
        TestTokenExpired = $true
    }
    Invoke-FabricRestMethod @apiParams
}
