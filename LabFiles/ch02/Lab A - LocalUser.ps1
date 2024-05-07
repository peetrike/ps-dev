function Get-UserLogonInfo {
    [CmdletBinding()]
    param (
            [string]
        $UserName
    )

    Get-LocalUser $UserName | Select-Object name, LastLogon, PasswordLastSet
}
