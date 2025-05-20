#Requires -Modules ActiveDirectory

function Get-UserLogonInfo {
    <#
        .SYNOPSIS
            Retrieves user logon information form AD.
        .DESCRIPTION
            This function retrieves logon information for Active Directory users.
        .EXAMPLE
            Get-UserLogonInfo -Filter 'samAccountName -like "admin*"'

            This example retrieves all users with names starting with "admin"
        .LINK
            https://learn.microsoft.com/powershell/module/activedirectory/get-aduser
    #>
    [OutputType([Microsoft.ActiveDirectory.Management.ADUser])]
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                HelpMessage = "A filter, such as 'samAccountName -like `"admin*`"', which is used to search for users."
            )]
            [Alias('SearchFilter', 'Query')]
            [ValidateNotNullOrEmpty()]
            [string]
            # Specifies filter to search for users
        $Filter,
            [Parameter(
                ValueFromPipeline
            )]
            [Alias('OU')]
            [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit]
            # Search users from the specified organizational unit
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

# Comment-based help is most easily added INSIDE the START of the function
# as shown here.

# Important points:
# - The help will not work if any of it is syntactically wrong
# - Do not number .EXAMPLE blocks and separate example code from explanation with
#   a blank line
