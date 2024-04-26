$continue = $true
while ($continue) {
    Write-Host '1. Display disk information'
    Write-Host '2. Display OS information'
    Write-Host '3. Lock a computer'
    Write-Host 'X. Exit the menu'

    $choice = Read-Host 'Enter your choice'

    switch ($choice) {
        1 { Get-AdatumDiskInfo | Out-Default }
        2 { Get-AdatumOSInfo | Out-Default }
        3 { Set-AdatumComputerState -State Lock }
        'X' { $continue = $false }
        default {
            Write-Host 'Unknown choice' -ForegroundColor red
        }
    }
}
