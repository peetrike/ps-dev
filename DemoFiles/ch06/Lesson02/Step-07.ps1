# Re-introducing an error and removing Write-Debug so that
# we can look at breakpoints instead
# In the ISE, set a breakpoint on line 14 and then
# press F5 to run the script

function Get-ServiceProcess {
    [CmdletBinding()]
    param (
            [SupportsWildcards()]
            [string]
        $ServiceName = '*'
    )

    $ServiceName = $ServiceName.Replace('*', '%')
    Get-CimInstance -ClassName Win32_Service -Filter "Name LIKE '$ServiceName'" -Verbose:$false | ForEach-Object {
        $process = Get-Process -Id $_.ProcessId

        [PSCustomObject] @{
            ComputerName = $env:COMPUTERNAME
            ServiceName  = $_.Name
            ProcessName  = $process.name
        }
    }
}

Get-ServiceProcess -ServiceName Win*
