[CmdletBinding()]
param (
        [string]
    $ReportFile,
        [switch]
    $PassThru
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

if ($PassThru) {
    $EventReport
}

if ($ReportFile) {
    $EventReport | Export-Csv -Path $ReportFile -NoTypeInformation -Encoding utf8 -UseCulture
}
