# TECHNIQUE 4: Get-Error
# PowerShell 7 contains Get-Error cmdlet to make error inspection easier
# For PowerShell 6 and lower you should have custom function

if ($PSVersionTable.PSVersion.Major -lt 6) {
    . $PSScriptRoot\..\..\Get-Error.ps1
}
$problem = 'C:\Windows\Temp'
Get-ChildItem -Path $problem -ErrorAction SilentlyContinue -ErrorVariable MyError
Write-Warning -Message 'An error from $Error'
Get-Error
Pause

Write-Warning -Message 'An error from custom ErrorVariable'
$MyError | Get-Error
