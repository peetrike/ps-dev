#Requires -Modules AdatumTools

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $ReportFilename
)

$frag1 = Get-AdatumOSInfo |
    ConvertTo-HTML -Fragment -As List -PreContent '<h2>Basic Info</h2>' |
    Out-String

$frag2 = Get-CorpNetAdapterInfo |
    ConvertTo-HTML -Fragment -As Table -PreContent '<h2>Network Adapters</h2>' |
    Out-String
