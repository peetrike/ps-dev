#Requires -Modules ImportExcel

$TabName = 'Processes'

$ExportProps = @{
    WorksheetName = $TabName
    TableName     = $TabName
    TableStyle    = 'Light12'
    BoldTopRow    = $true
    FreezeTopRow  = $true
    AutoSize      = $true
    ClearSheet    = $true
}

$document = Get-Process p* |
    Select-Object -Property Name, WS, CPU, Description, StartTime |
    Export-Excel -Path "${TabName}.xlsx" @ExportProps -PassThru
$Sheet = $document.Workbook.Worksheets[$TabName]

Set-ExcelRange -Worksheet $Sheet -Range 'B:B' -NumberFormat '#,###' -AutoFit
Set-ExcelRange -Worksheet $Sheet -Range 'C:C' -NumberFormat '#,##0.00' -AutoFit
Set-ExcelRange -Worksheet $Sheet -Range 'E:E' -NumberFormat 'dd MMMM HH:mm:ss' -AutoFit
Add-ConditionalFormatting -Worksheet $Sheet -Range 'c2:c1000' -DataBarColor Blue

Close-ExcelPackage -ExcelPackage $document -Show
