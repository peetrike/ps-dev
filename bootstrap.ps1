#Requires -Version 3.0

[CmdletBinding()]
param ()

$ErrorActionPreference = 'Stop'

[Net.ServicePointManager]::SecurityProtocol =
    [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

try {
    Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction Stop
} catch {
    Install-PackageProvider -Name NuGet -Scope AllUsers -Force
}

if ((Get-Module -Name PowerShellGet -ListAvailable).Version | Where-Object { $_ -gt '2.2.4' }) {
    Write-Verbose -Message 'PowershellGet already up to date'
} else {
    Install-Module PowerShellGet -Force
    Remove-Module PowerShellGet, PackageManagement
    Import-Module PowerShellGet
}

# Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
if (-not (Get-Module -Name PSDepend -ListAvailable)) {
    Install-Module -Name PSDepend -Repository PSGallery -Force
}
Import-Module -Name PSDepend -Verbose:$false
Invoke-PSDepend -Path $PSScriptRoot -Install -Import -Force -WarningAction SilentlyContinue
