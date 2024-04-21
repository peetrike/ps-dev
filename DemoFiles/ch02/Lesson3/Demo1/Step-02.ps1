# Define parameter as mandatory

function Get-UserLogonInfo {
    [CmdletBinding()]
    param (
            [Parameter(Mandatory)]
            [string]
        $Filter,
            [string]
        $SearchBase
    )

    Get-ADUser @PSBoundParameters -Properties LastLogonDate, PasswordLastSet
}
