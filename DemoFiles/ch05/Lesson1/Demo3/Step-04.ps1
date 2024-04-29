# TECHNIQUE 4: Get-Error
# PowerShell 7 contains Get-Error cmdlet to make error inspection easier
# For PowerShell 6 and lower you should have an alternative

if ($PSVersionTable.PSVersion.Major -lt 6) {
    . $PSScriptRoot\..\..\Get-Error.ps1
}
$problem = 'C:\Windows\Temp'
Get-ChildItem -Path $problem -ErrorAction SilentlyContinue -ErrorVariable MyError
Get-Error
Pause
$MyError | Get-Error
