# Run this entire script to see the differences
$VerbosePreference = 'Continue'
$PathList = 'C:\DoesNotExist', 'C:\Windows\Temp', '.'

Write-Verbose 'PASS 1: Attempt to trap a non-terminating error'
try {
    Get-ChildItem -Path $PathList
} catch {
    Write-Warning 'The command on this line never runs because the error is never trapped'
}

Write-Verbose 'PASS 2: Attempt to trap a terminating error'
try {
    Get-ChildItem -Path $PathList -ErrorAction Stop
} catch {
    $Message = 'The command on this line runs,' +
        ' but no paths are checked because the command terminates on first error:'
    Write-Warning -Message $Message
    Write-Warning -Message $_.Exception.Message
}

Write-Verbose 'PASS 3: That is why we enumerate - so we only try one folder at a time'
foreach ($folder in $PathList) {
    try {
        Get-ChildItem -Path $folder -ErrorAction Stop
    } catch {
        Write-Warning "Trapped error on $folder"
    }
}
