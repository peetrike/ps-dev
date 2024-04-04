[CmdletBinding()]
param (
        [ValidateSet(
            'Write-Error',
            'Throw',
            'PSCmdlet'
        )]
    $Action,
        [ValidateSet(
            'Message',
            'Exception',
            'ErrorRecord',
            'PSCmdlet'
        )]
    $Details,
        [switch]
    $Terminating
)

$Error.Clear()
$Server = Resolve-DnsName www.ee
$Message = 'No server name specified.'
$RecommendedAction = 'Please set default server or specify server name.'
$CategoryTargetName = 'Server'
$CategoryTargetType = $Server.GetType().Name

$Exception = [Management.Automation.RuntimeException] $Message

$ErrorId = 'MissingServer'
$errorCategory = [Management.Automation.ErrorCategory]::ObjectNotFound
$ErrorRecord = New-Object -TypeName 'System.Management.Automation.ErrorRecord' -ArgumentList @(
    $Exception
    $ErrorId
    $errorCategory
    $Server
)

switch ($Action) {
    'Write-Error' {
        switch ($Details) {
            'Message' {
                $ErrorProps = @{
                    Message            = $Message
                    Category           = $errorCategory
                    ErrorId            = $ErrorId
                    TargetObject       = $Server
                    RecommendedAction  = $RecommendedAction
                    CategoryTargetName = $CategoryTargetName
                    CategoryTargetType = $CategoryTargetType
                }
                if ($Terminating.IsPresent) {
                    $ErrorProps.ErrorAction = 'Stop'
                }
                Write-Error @ErrorProps
            }
            'Exception' {
                $ErrorProps = @{
                    Exception          = $Exception
                    ErrorId            = $ErrorId
                    Category           = $errorCategory
                    TargetObject       = $Server
                    RecommendedAction  = $RecommendedAction
                    CategoryTargetName = $CategoryTargetName
                    CategoryTargetType = $CategoryTargetType
                }
                if ($Terminating.IsPresent) {
                    $ErrorProps.ErrorAction = 'Stop'
                }
                Write-Error @ErrorProps
            }
            'ErrorRecord' {
                $ErrorProps = @{
                    ErrorRecord        = $ErrorRecord
                    RecommendedAction  = $RecommendedAction
                    CategoryTargetName = $CategoryTargetName
                }
                if ($Terminating.IsPresent) {
                    $ErrorProps.ErrorAction = 'Stop'
                }
                Write-Error @ErrorProps
            }
            'PSCmdlet' {
                $ErrorRecord.ErrorDetails = $Message
                $ErrorRecord.ErrorDetails.RecommendedAction = $RecommendedAction
                $ErrorRecord.CategoryInfo.TargetName = $CategoryTargetName
                $PSCmdlet.WriteError($ErrorRecord)
            }
        }
    }
    'Throw' {
        Write-Verbose -Message 'Adding ErrorDetails'
        $ErrorRecord.ErrorDetails = $Message
        $ErrorRecord.ErrorDetails.RecommendedAction = $RecommendedAction
        $ErrorRecord.CategoryInfo.TargetName = $CategoryTargetName
        $ErrorRecord.CategoryInfo.Activity = $MyInvocation.MyCommand.Name
        throw $ErrorRecord
    }
    'PSCmdlet' {
        $ErrorRecord.ErrorDetails = $Message
        $ErrorRecord.ErrorDetails.RecommendedAction = $RecommendedAction
        $ErrorRecord.CategoryInfo.TargetName = $CategoryTargetName
        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    }
}
