#Requires -Version 3

. .\Step-04.ps1

# Select-Object will preserve the property order we specify
Get-FailedUpdateEvent -Count 2 | Select-Object TimeCreated, UpdateTitle, ErrorCode

Get-FailedUpdateEvent -Count 1 | Get-Member
$FailedEvent = Get-FailedUpdateEvent -Count 1
$FailedEvent.psobject.TypeNames
(Get-Command Get-FailedUpdateEvent).OutputType
