
# TECHNIQUE 3: $_
# In most contexts will include last error
# Can be lost if $_ is used for something else
# Best to capture and save to a private variable

$problem = 'C:\Windows\Temp'
try {
    Get-ChildItem -Path $problem -ErrorAction Stop
} catch {
    $myError = $_
    Write-Warning "CAUGHT ERROR ON $problem"
    Write-Warning $myError.Exception.Message
    $myError | Get-Member * -Force
}
