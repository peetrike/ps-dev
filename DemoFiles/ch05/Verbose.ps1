[CmdletBinding()]
param ()

if ($PSBoundParameters.ContainsKey('Verbose')) {
    Write-Verbose -Message 'Showing the effect of verbose output'
    Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3'
}

Write-Verbose -Message 'Showing the effect of suppressing verbose output'
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' 4> $null
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' -Verbose:$false

$SuppressVerbose = @{ Verbose = $false }

$Parameters = @{
    ClassName = 'Win32_LogicalDisk'
    Filter    = 'DriveType=3'
}
#$Parameters['NameSpace'] = 'root\cimv2'
Get-CimInstance @Parameters @SuppressVerbose
