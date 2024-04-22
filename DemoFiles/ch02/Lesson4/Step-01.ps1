# This is our starting point

function Get-UserLogonInfo {
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                HelpMessage = "A filter, such as 'samAccountName -like `"admin*`"', which is used to search for users."
            )]
            [Alias('SearchFilter', 'Query')]
            [ValidateNotNullOrEmpty()]
            [string]
        $Filter,
            [string]
        $SearchBase
    )

    Get-ADUser @PSBoundParameters -Properties LastLogonDate, PasswordLastSet
}
