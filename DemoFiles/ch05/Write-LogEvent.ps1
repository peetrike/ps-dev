function Write-LogEvent {
    [CmdletBinding()]
    param (
            [Parameter(Mandatory)]
            [ValidateScript({
                [Diagnostics.EventLog]::SourceExists($_)
            })]
            [string]
        $Source,
            [Diagnostics.EventLogEntryType]
        $EntryType = [Diagnostics.EventLogEntryType]::Information,
            [Alias('Id')]
            [int]
        $EventId = 1,
            [Parameter(Mandatory)]
            [string]
        $MessageTemplate,
            [string[]]
        $Data
    )

    $Message = $MessageTemplate -f $Data

    $EventInstance = New-Object System.Diagnostics.EventInstance -ArgumentList (
        $EventID,
        0,
        $EntryType
    )
    [Diagnostics.EventLog]::WriteEvent(
        $Source,
        $EventInstance,
        @(
            $Message
            $Data
        )
    )
}
