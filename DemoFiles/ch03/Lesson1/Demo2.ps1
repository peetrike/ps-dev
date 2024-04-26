# Now that the module is saved in the correct location,
# we can run the command as if it were a native shell command.

Import-Module .\DemoTools.psm1

Set-ComputerState -State Lock
