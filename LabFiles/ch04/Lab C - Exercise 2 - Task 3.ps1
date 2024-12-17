[CmdletBinding()]
param (
        [Parameter(
            Mandatory,
            HelpMessage = 'The path to the report file to save'
        )]
        [string]
    $ReportFile
)

$EventFilter = @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 19, 20
}

$EventReport = foreach ($CurrentEvent in Get-WinEvent -FilterHashtable $EventFilter) {
    $EventXml = [xml] $CurrentEvent.ToXml()
    $EventId = $CurrentEvent.Id
    $UpdateTitle = $EventXml.SelectSingleNode('//*[@Name = "updateTitle"]').InnerText
    $KbArticleId = if ($UpdateTitle -match 'KB\d{6,7}') {
        $Matches.0
    } else { $null }

    $ErrorCode = if ($EventId -eq 20) {
        $EventXml.SelectSingleNode('//*[@Name = "errorCode"]').InnerText
    } else { $null }

    [PSCustomObject] @{
        TimeCreated = $CurrentEvent.TimeCreated
        Id          = $EventId
        Level       = [Diagnostics.Eventing.Reader.StandardEventLevel] $CurrentEvent.Level
        UpdateTitle = $UpdateTitle
        UpdateGuid  = $EventXml.SelectSingleNode('//*[@Name="updateGuid"]').InnerText
        ErrorCode   = $ErrorCode
        KBArticleId = $KbArticleId
    }
}

if ($ReportFile) {
    $EventReport | Export-Csv -Path $ReportFile -NoTypeInformation -Encoding utf8 -UseCulture
}
