#Requires -Modules PSWriteHTML
[CmdletBinding()]
param (
        [string]
    $ProcessName = 'p*',
        [int]
    $WorkingSet = 200MB
)

$Memory = 'PagedMemorySize', 'PrivateMemorySize', 'VirtualMemorySize'
$Properties = @(
    'Name'
    'Id'
    'PriorityClass'
    'FileVersion'
    'HandleCount'
    'WorkingSet'
    $Memory
    'TotalProcessorTime'
)

$data = Get-Process $ProcessName | Select-Object -Property $Properties

New-HTML -TitleText 'Process List' -Online -FilePath $PWD\Processes.html -ShowHTML {
    New-HTMLPanel {
        New-HTMLTable -DataTable $data -HideFooter -ScrollCollapse {
            New-TableHeader -Names 'Name', 'ID' -Title 'Process Information' -Color DarkBlue -FontWeight lighter -Alignment left -BackGroundColor LightBlue
            New-TableHeader -Names $Memory -Title 'Memory' -Color White -BackGroundColor Blue
            New-TableHeader -Names 'Name' -BackGroundColor Red -Color WhiteSmoke
            New-TableHeader -Names 'Id' -BackGroundColor Blue -Color White
            New-TableHeader -Names 'PriorityClass', 'FileVersion', 'HandleCount' -BackGroundColor Gold -Color Blue
            New-TableHeader -BackGroundColor Green -Color White -Title ([datetime]::Now)
            New-TableCondition -Name 'WorkingSet' -ComparisonType number -Operator gt -Value $WorkingSet -Row -BackgroundColor Gray -Color White
        }
    }
}
