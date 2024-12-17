[CmdletBinding()]
param ()

$EventFilter = @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 19, 20
}

Get-WinEvent -FilterHashtable $EventFilter | ForEach-Object {
    $EventXml = [xml] $_.ToXml()
    $EventId = $_.Id
    $UpdateTitle = $EventXml.SelectSingleNode('//*[@Name = "updateTitle"]').InnerText
    $KbArticleId = if ($UpdateTitle -match 'KB\d{6,7}') {
        $Matches.0
    } else { $null }

    $ErrorCode = if ($EventId -eq 20) {
        $EventXml.SelectSingleNode('//*[@Name = "errorCode"]').InnerText
    } else { $null }

    [PSCustomObject] @{
        TimeCreated = $_.TimeCreated
        Id          = $EventId
        Level       = [Diagnostics.Eventing.Reader.StandardEventLevel] $_.Level
        UpdateTitle = $UpdateTitle
        UpdateGuid  = $EventXml.SelectSingleNode('//*[@Name="updateGuid"]').InnerText
        ErrorCode   = $ErrorCode
        KBArticleId = $KbArticleId
    }
}
