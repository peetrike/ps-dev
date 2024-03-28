#Requires -Version 7
#Requires -Module Microsoft.PowerShell.ConsoleGuiTools

## Load the required assemblies
try {
    $null = [Terminal.Gui.Window]
} catch {
    $guiTools = (
        Get-Module Microsoft.PowerShell.ConsoleGuiTools -ListAvailable
    )[0].ModuleBase
    Add-Type -Path (Join-Path $guiTools Terminal.Gui.dll)
}

## Initialize our application
[Terminal.Gui.Application]::Init()

$Answer = 'Yes', 'No'
$Result = [Terminal.Gui.MessageBox]::Query(
    'Question',
    'Do you like console apps?',
    $Answer
)
[Terminal.Gui.Application]::Shutdown()
$Answer[$Result]
