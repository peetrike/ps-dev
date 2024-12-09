#Requires -Version 7
#Requires -Modules AdatumTools
#Requires -Modules Microsoft.PowerShell.ConsoleGuiTools
using namespace Terminal.Gui

## Load the required assemblies
try {
    $null = [Terminal.Gui.Application]
} catch {
    $guiTools = (
        Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable
    )[0].ModuleBase
    Add-Type -Path (Join-Path $guiTools Terminal.Gui.dll)
}

## Initialize our application
[Application]::Init()

## create UI window
$window = [Window] @{
    Title  = 'Choice Menu!'
    Height = 10
    Width  = 80
}

## Create results text box
$Text = [TextView]::new(
    [rect]::new(
        11, 0, 64, 8
    )
)
$Text.CanFocus = $false
$window.Add($Text)

## Create radio group
$RadioGroup = [RadioGroup] @{
    DisplayMode = [DisplayModeLayout]::Vertical
    RadioLabels = 'Disk', 'OS', 'Lock'
}
$RadioGroup.add_SelectedItemChanged({
    switch ($RadioGroup.selectedItem) {
        0 {
            $Result = Get-AdatumDiskInfo | Out-String
            $Text.Text = $Result
        }
        1 {
            $Result = Get-AdatumOSInfo | Out-String
            $Text.Text = $Result
        }
        2 {
            Set-AdatumComputerState -State Lock -Force
        }
    }
})
$window.Add($RadioGroup)

## create exit button
$MsgButton = [Button] @{
    X    = [Pos]::At(1)
    Y    = [Pos]::At(4)
    Text = 'E_xit'
}
$MsgButton.add_Clicked({
    [Application]::RequestStop()
})
$window.Add($MsgButton)

# Display the window
[application]::Top.Add($window)
[Application]::Run()
[Application]::Shutdown()
