#Requires -RunasAdministrator

[CmdletBinding()]
param (
        [Parameter(Mandatory)]
        [string]
    $Source,
        [ValidateScript({
            [Diagnostics.EventLog]::Exists($_)
        })]
        [string]
    $LogName = 'Application'
)

if ([Diagnostics.EventLog]::SourceExists($Source)) {
    Write-Warning -Message ('Source already exists: {0}' -f $Source)
} else {
    [Diagnostics.EventLog]::CreateEventSource(
        $myProvider,
        $LogName
    )
}
