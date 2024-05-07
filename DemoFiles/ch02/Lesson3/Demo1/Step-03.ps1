# Provide a help message

function Get-UserLogonInfo {
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                HelpMessage = "A filter, like 'samAccountName -like `"admin*`"', used to search for users."
            )]
            [string]
        $Filter,
            [string]
        $SearchBase
    )

    Get-ADUser @PSBoundParameters -Properties LastLogonDate, PasswordLastSet
}
