function Write-CsvLog {
    param (
        [Parameter(Mandatory)] [string] $Message,
        [string] $LogFile = 'C:\log.csv',
        [string] $Tag = 'Log'
    )
    Write-Information -MessageData $Message -Tags $Tag -InformationAction Continue
    [PSCustomObject] @{
        Time    = [datetime]::Now.ToString('o')
        Message = $Message
        Tag     = $Tag
    } | Export-Csv -Path $LogFile -Append -NotypeInformation -Encoding UTF8
}
