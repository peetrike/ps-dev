#Requires -Modules AdatumTools

#region Crete choices
$ChoiceList = @{
    '&Disk' = 'Display disk information'
    '&OS'   = 'Display OS information'
    '&Lock' = 'Lock a computer'
    'e&Xit' = 'Exit the menu'
}
#endregion

do {
    $choice = Read-Choice -Message 'Please make your choice' -Choices $ChoiceList -Default 'Exit'
    $choice
} until ($choice -eq 'Exit')
