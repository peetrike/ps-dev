#Requires -Modules UserProfile

[CmdletBinding()]
param ()

function Get-CurrentUser {
    [Security.Principal.WindowsIdentity]::GetCurrent() |
        Add-Member -MemberType AliasProperty -Name SID -Value User -PassThru
}

gcim Win32_UserAccount -f "Local=True AND Name='administrator'" | Get-UserProfile
Get-CurrentUser | Get-UserProfile
