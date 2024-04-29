
# TECHNIQUE 1: $Error built-in collection
# Will contain terminating and non-terminating errors
# $error[0] is the most recent
# $error.clear() clears it out - not always a good practice

$problem = 'C:\Windows\Temp'
try {
    Get-ChildItem -Path $problem -ErrorAction Stop
} catch {
    $MyError = $Error[0]
    Write-Warning -Message "CAUGHT ERROR ON $problem"
    Write-Warning -Message $MyError.Exception.Message
    $MyError | Get-Member * -Force
}
