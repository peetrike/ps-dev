# Add an alias

function Get-UserLogonInfo {
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                HelpMessage = "A filter, such as 'samAccountName -like `"admin*`"', which is used to search for users."
            )]
            [Alias('SearchFilter', 'Query')]
            [string]
        $Filter,
            [string]
        $SearchBase
    )

    Get-ADUser @PSBoundParameters -Properties LastLogonDate, PasswordLastSet
}
