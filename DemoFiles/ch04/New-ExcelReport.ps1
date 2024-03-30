Get-ChildItem *.ps1 |
    Select-Object Name, Length, LastWriteTime |
    Export-Excel -Path files.xlsx
