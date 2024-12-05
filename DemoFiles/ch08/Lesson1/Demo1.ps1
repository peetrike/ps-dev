<#
You can highlight each line and press F8 to run only
the highlighted line
#>

# 1. Display the absolute value of -50.
[Math]::Abs(-50)

# 2. Using the System.Environment class, display the current computer name.
[System.Environment]::MachineName

# 3. Using the PowerShell $env variable, display the current computer name.
# This shows that .NET Framework classes often overlap shell functionality.
$env:COMPUTERNAME

# 4. Display the value of the mathematical constant e.
[Math]::e
