#Requires -Modules UserProfile

[CmdletBinding()]
param ()

function Get-CurrentUser {
    [Security.Principal.WindowsIdentity]::GetCurrent() |
        Add-Member -MemberType AliasProperty -Name SID -Value User -PassThru
}

Get-CimInstance -ClassName Win32_UserAccount -Filter "Local=True AND Name='administrator'" -Verbose |
    Get-UserProfile
Get-CurrentUser | Get-UserProfile

# We are assuming that the filter is useful.
# https://learn.microsoft.com/windows/win32/cimwin32prov/win32-useraccount
# We are assuming that Get-UserProfile gets SID from Get-CurrentUser.
