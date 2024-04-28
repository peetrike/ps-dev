[CmdletBinding()]
param ()

if ($PSBoundParameters.ContainsKey('Verbose')) {
    Write-Verbose -Message 'Showing the effect of verbose output'
    Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3'
}

Write-Verbose -Message 'Showing the effect of suppressing verbose output'
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' -Verbose:$false
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' 4> $null
