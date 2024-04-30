#Requires -Modules UserProfile

[CmdletBinding()]
param ()

function Get-CurrentUser {
    [Security.Principal.WindowsIdentity]::GetCurrent() |
        Add-Member -MemberType AliasProperty -Name SID -Value User -PassThru
}

Get-CimInstance -ClassName Win32_UserAccount -Filter "LocalAccount=True AND Name='administrator'" |
    Get-UserProfile
Get-CurrentUser |
    Select-Object @{
        Name       = 'SID'
        Expression = { $_.SID.Value }
    } |
    Get-UserProfile
