#Requires -Modules PSWritePDF
[CmdletBinding()]
param ()

$DataTable = Get-Process p* | Select-Object -Property ProcessName, Id, StartTime
$ReportFile = Join-Path -Path $PWD -ChildPath report.pdf

New-PDF {
    New-PDFText -Text 'PowerShell Process Report' -FontBold $true
    New-PDFText -Text ('Created on: {0}' -f [datetime]::Now)
    New-PDFTable -DataTable $DataTable
} -FilePath $ReportFile -Show
