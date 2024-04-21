# This is our starting point

function Get-UserLogonInfo {
    [CmdletBinding()]
    param (

            [string]
        $Filter = "SamAccountName -eq '$env:USERNAME'",
            [string]
        $SearchBase
    )

    $UserParams = @{
        Filter = $Filter
    }
    if ($SearchBase) {
        $UserParams.SearchBase = $SearchBase
    }
    Get-ADUser @UserParams -Properties LastLogonDate, PasswordLastSet
}
