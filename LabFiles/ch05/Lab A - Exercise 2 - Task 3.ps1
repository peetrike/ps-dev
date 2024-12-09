#Requires -Modules AdatumTools

$ChoiceList = [ordered] @{
    '&Disk' = 'Display disk information'
    '&OS'   = 'Display OS information'
    '&Lock' = 'Lock a computer'
    'e&Xit' = 'Exit the menu'
}

do {
    $choice = Read-Choice -Message 'Make your choice' -Choices $ChoiceList -Default 'Exit'
    switch ($choice) {
        'Disk' { Get-AdatumDiskInfo | Out-Default }
        'OS' { Get-AdatumOSInfo | Out-Default }
        'Lock' { Set-AdatumComputerState -State Lock }
    }
} until ($choice -eq 'Exit')
