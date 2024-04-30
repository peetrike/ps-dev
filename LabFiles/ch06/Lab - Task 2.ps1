#Requires -Modules UserProfile

[CmdletBinding()]
param ()


function Get-CurrentUser {
    [Security.Principal.WindowsIdentity]::GetCurrent() |
        Add-Member -MemberType AliasProperty -Name SID -Value User -PassThru
}

$Filter = "Local=True AND Name='administrator'"
Get-CimInstance -ClassName Win32_UserAccount -Filter $Filter -ErrorVariable problem |
    Get-UserProfile

Get-CurrentUser | Select-Object SID | Get-UserProfile -ErrorVariable +problem

if ($PSBoundParameters.ContainsKey('Debug')) {
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
    $problem | Write-LogError
}
