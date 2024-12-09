# Highlight and run each section below to understand
# the error handling options.

# let's start with a clean state
$Error.Clear()

# The default: Continue
# Displays error and keeps going
Get-ChildItem C:\doesnotexist, C:\Windows\Temp, .
$Error.Count

# Hide the error, keep going
# Errors are still added to the $Error variable
$OldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
Get-ChildItem C:\doesnotexist, C:\Windows\Temp, .
$Error.Count

# Hide the error, keep going
# Errors are not added to the $Error variable
$ErrorActionPreference = 'Ignore'
Get-ChildItem C:\doesnotexist, C:\Windows\Temp, .
$Error.Count

# Ask what to do, selecting "Yes" or "Yes to All" will display the error and keep going
# Selecting "Halt Command" will stop the command and not display the original error.
# Selecting "Suspend" will suspend the command which is indicated in the console window by ">>"
$ErrorActionPreference = 'Inquire'
Get-ChildItem C:\doesnotexist, C:\Windows\Temp, .

# Enter the debugger when error occurs
$ErrorActionPreference = 'Break'
Get-ChildItem C:\doesnotexist

# Generate terminating EXCEPTION and stop
$ErrorActionPreference = 'Stop'
Get-ChildItem C:\doesnotexist, C:\Windows\Temp, .

# Only terminating exceptions can be trapped

# Set default back
$ErrorActionPreference = $OldErrorActionPreference
