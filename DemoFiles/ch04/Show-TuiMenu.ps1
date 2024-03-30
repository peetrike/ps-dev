# .link https://github.com/jdhitsolutions/PSConfEU2023/blob/main/TUI-Tools/demos/menus.ps1
#Requires -Version 7
#Requires -Module Microsoft.PowerShell.ConsoleGuiTools
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

# Initialize our application
[Application]::Init()

# Create a window with a label and a button
$window = [Window] @{
    Title  = 'Hello Menu!'
    Height = 10
    Width  = 50
}

#this is what will be on the menu bar
$MenuBarItem = [MenuBarItem] @{
    Title    = '_Quit'
    Children = [MenuItem]::new('_Close', 'Close the application', { [Application]::RequestStop() })
}

$about = @'
Menu Demo
PSVersion {0}
'@ -f $PSVersionTable.PSVersion

$MenuItem2 = [MenuItem]::new('A_bout', '', { [MessageBox]::Query('About', $About) })
$MenuItem3 = [MenuItem]::new(
    '_Documentation',
    '',
    { Start-Process 'https://gui-cs.github.io/Terminal.Gui/api/Terminal.Gui' }
)
$MenuBarItem2 = [MenuBarItem] @{
    Title = '_Help'
    Children = $MenuItem2, $MenuItem3
}

#define the main menu bar
$MenuBar = [MenuBar] @{
    Menus = $MenuBarItem, $MenuBarItem2
}
$window.Add($MenuBar)

$Text = [TextField] @{
    X     = [Pos]::Center()
    Y     = [Pos]::Center()
    Width = 30
    Text  = 'You can enter text here'
}
$window.Add($Text)

$MsgButton = [Button] @{
    X    = [Pos]::At(17)
    Y    = [Pos]::At(6)
    Text = '_Message'
}
$MsgButton.add_Clicked({
    $answer = 'Yes', 'No', 'Cancel'
    $r = [MessageBox]::Query('Look at me!', 'What do you want to do?', $answer)
    $Text.text = 'Your response is: {0}' -f $answer[$r]
})
$window.Add($MsgButton)

[Application]::Top.Add($window)
[Application]::Run()
[Application]::Shutdown()
