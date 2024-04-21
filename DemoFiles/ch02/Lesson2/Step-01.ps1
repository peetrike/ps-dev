# Test and debug commands one at a time in the console

Get-WinEvent -FilterHashtable @{
    ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
    ID           = 20
    #StartTime    = '2024.04.16'
} -MaxEvents 1
