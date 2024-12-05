<#
You can highlight each line and press F8 to run only
the highlighted line
#>

# 1. Run Windows Notepad.
notepad.exe

# 2. Retrieve a reference to the instance of System.Diagnostics.Process that represents
# the running copy of Windows Notepad.
$note = Get-Process -Name Notepad

# 3. Terminate the Windows Notepad process.
$note.Kill()

# 4. Create a new instance of the System.Data.SqlClient.SqlConnection class. Store it in $conn.
$conn = New-Object -TypeName System.Data.SqlClient.SqlConnection

# 5. Display the members of the instance.
$conn | Get-Member

# 6. Set the connection string to:
# Server=myServerAddress;Database=myDataBase;Trusted_Connection=True;
# Notice that there is no server at this address; you will not actually connect to a Microsoft SQL Server computer.
$conn.ConnectionString = 'Server=myServerAddress;Database=myDataBase;Trusted_Connection=True;'

# 7. Display a list of the connection’s properties and their values.
$conn | Format-List -Property *
