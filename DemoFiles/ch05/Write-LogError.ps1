function Write-LogError {
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                ValueFromPipeline
            )]
            [Management.Automation.ErrorRecord]
        $ErrorRecord,
            [string]
        $LogPath = (Join-Path -Path $PWD -ChildPath 'ErrorLog.csv')
    )

    begin {
        $PropertyList = @(
            @{
                Name       = 'Time'
                Expression = { [datetime]::Now.ToString('o') }
            }
            @{
                Name       = 'Message'
                Expression = { $_.Exception.Message }
            }
            'FullyQualifiedErrorId'
            @{
                Name       = 'Command'
                Expression = { $_.InvocationInfo.MyCommand }
            }
            @{
                Name       = 'Line'
                Expression = { $_.InvocationInfo.ScriptLineNumber }
            }
            'ScriptStackTrace'
            'CategoryInfo'
            'TargetObject'
        )
    }

    process {
        $ErrorRecord |
            Select-Object -Property $PropertyList |
            Export-Csv -Path $LogPath -NoTypeInformation -Append -Encoding utf8
    }
}
