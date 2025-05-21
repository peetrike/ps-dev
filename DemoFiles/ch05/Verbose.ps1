[CmdletBinding()]
param ()

if ($PSBoundParameters.ContainsKey('Verbose')) {
    Write-Verbose -Message 'Showing the effect of verbose output'
    Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3'
}

$MyVariable = @{ Verbose = $false }

Write-Verbose -Message 'Showing the effect of suppressing verbose output'
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' -Verbose:$false
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' 4> $null

$Parameters = @{
	ClassName = 'Win32_LogicalDisk'
	Filter    = 'DriveType=3'
}
$Parameters['NameSpace'] = 'root\cimv2'
Get-CimInstance @Parameters @MyVariable
