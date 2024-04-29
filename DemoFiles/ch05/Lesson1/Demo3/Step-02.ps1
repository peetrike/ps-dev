# TECHNIQUE 2: ErrorVariable
# Variables names don't include the $
# Prefix with + to append errors
# Only includes errors from that command

$problem = 'C:\Windows\Temp'
Get-ChildItem -Path $problem -ErrorAction SilentlyContinue -ErrorVariable MyError
Write-Warning -Message "CAUGHT ERROR ON $problem"
Write-Warning -Message $MyError.Exception.Message
$MyError | Get-Member
