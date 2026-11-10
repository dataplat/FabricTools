function Remove-FabricConnection {
    <#
    .SYNOPSIS
        Removes a Fabric connection.

    .DESCRIPTION
        Permanently deletes the specified Microsoft Fabric connection. Items that
        use the connection can no longer authenticate through it.

    .PARAMETER ConnectionId
        The ID of the connection to remove.

    .EXAMPLE
        ```powershell
        Remove-FabricConnection -ConnectionId '11111111-1111-1111-1111-111111111111'
        ```

    .NOTES
        https://learn.microsoft.com/en-us/rest/api/fabric/core/connections/delete-connection

        Author: Kamil Nowinski
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
