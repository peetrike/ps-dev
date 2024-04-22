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
            [Parameter(
                ValueFromPipeline
            )]
            [Alias('OU')]
            [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit]
        $OrganizationalUnit
    )

    process {
        $UserParams = @{
            Filter = $Filter
        }
        if ($OrganizationalUnit) {
            $UserParams['SearchBase'] = $OrganizationalUnit.DistinguishedName
        }
        Get-ADUser @UserParams -Properties LastLogonDate, PasswordLastSet
    }
}
