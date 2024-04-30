function Get-ServiceProcess {
    [CmdletBinding()]
    param (
            [SupportsWildcards()]
            [string]
        $ServiceName = '*'
    )

    $ServiceName = $ServiceName.Replace('*', '%')
    Write-Debug -Message ('Searching with filter: {0}' -f $ServiceName)
    Get-CimInstance -ClassName Win32_Service -Filter "Name LIKE '$ServiceName'" -Verbose:$false | ForEach-Object {
        $message = 'Querying process for {0}, with State {1}' -f $_.name, $_.State
        Write-Verbose -Message $message

        if ($_.State -ne 'Running') {
            $processName = '(Not started)'
        } else {
            $process = Get-Process -Id $_.ProcessId
            $processName = $process.name
        }
        [PSCustomObject] @{
            PSTypeName   = 'PSDevOps.ServiceProcess'
            ComputerName = $env:COMPUTERNAME
            ServiceName  = $_.Name
            ProcessName  = $processName
        }
    }
}
