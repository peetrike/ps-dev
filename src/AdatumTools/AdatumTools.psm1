function Get-AdatumDiskInfo {
    <#
        .SYNOPSIS
            Retrieves disk information.
        .DESCRIPTION
            This function retrieves disk information from the local computer.
        .EXAMPLE
            Get-AdatumDiskInfo
    #>
    [CmdletBinding()]
    param ()

    Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object {
        [PSCustomObject] @{
            ComputerName = $Env:COMPUTERNAME
            DriveLetter  = $_.DeviceID
            FreeSpace    = $_.FreeSpace
            Size         = $_.Size
        }
    }
}

function Get-AdatumNetAdapterInfo {
    <#
        .SYNOPSIS
            Retrieves network adapter information.
        .DESCRIPTION
            This function retrieves network adapter information from the local computer.
        .EXAMPLE
            Get-AdatumNetAdapterInfo
    #>
    [CmdletBinding()]
    param ()

    foreach ($adapter in Get-NetAdapter) {
        $AdapterName = $adapter.Name
        $InterfaceIndex = $adapter.InterfaceIndex

        Get-NetIPAddress -InterfaceIndex $InterfaceIndex -ErrorAction SilentlyContinue | ForEach-Object {
            [PSCustomObject] @{
                ComputerName   = $Env:COMPUTERNAME
                AdapterName    = $AdapterName
                InterfaceIndex = $InterfaceIndex
                IPAddress      = $_.IPAddress
                AddressFamily  = $_.AddressFamily
            }
        }
    }
}

function Get-AdatumOSInfo {
    <#
        .SYNOPSIS
            Retrieves operating system, BIOS, and computer information.
        .DESCRIPTION
            This command retrieves specific information from each computer. The
            command uses CIM, so it will only work with computers where Windows
            Remote Management (WinRM) has been enabled and Windows Management
            Framework (WMF) 3.0 or later is installed.
        .EXAMPLE
            Get-AdatumOSInfo

            This example assumes that names.txt includes one computer name per
            line, and will retrieve information from each computer listed.
    #>
    [OutputType('OSInfo')]
    [CmdletBinding()]
    param ()

    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $compsys = Get-CimInstance -ClassName Win32_ComputerSystem
    $bios = Get-CimInstance -ClassName Win32_BIOS

    [PSCustomObject] @{
        PSTypeName   = 'OSInfo'
        ComputerName = [Net.Dns]::GetHostEntry('').HostName
        OSVersion    = $os.Caption
        SPVersion    = $os.ServicePackMajorVersion
        BIOSSerial   = $bios.SerialNumber
        Manufacturer = $compsys.Manufacturer
        Model        = $compsys.Model
    }
}

function Get-AdatumUserLogonInfo {
    <#
        .SYNOPSIS
            Retrieves user logon information form AD.
        .DESCRIPTION
            This function retrieves logon information for Active Directory users.
        .EXAMPLE
            Get-UserLogonInfo -Filter 'samAccountName -like "admin*"'

            This example retrieves all users with names starting with "admin"
        .LINK
            https://learn.microsoft.com/powershell/module/activedirectory/get-aduser
    #>
    [OutputType([Microsoft.ActiveDirectory.Management.ADUser])]
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                HelpMessage = "A filter, such as 'samAccountName -like `"admin*`"', which is used to search for users."
            )]
            [Alias('SearchFilter', 'Query')]
            [ValidateNotNullOrEmpty()]
            [string]
            # Specifies filter to search for users
        $Filter,
            [Parameter(
                ValueFromPipeline
            )]
            [Alias('OU')]
            [Microsoft.ActiveDirectory.Management.ADOrganizationalUnit]
            # Search users from the specified organizational unit
        $OrganizationalUnit
    )

    process {
        $UserParams = @{
            Filter = $Filter
        }
        if ($OrganizationalUnit) {
            $UserParams['SearchBase'] = $OrganizationalUnit.DistinguishedName
        }
        Get-ADUser @UserParams -Properties LastLogonDate, PasswordLastSet
    }
}

function Get-AdatumFailedUpdateEvent {
    <#
        .SYNOPSIS
            Retrieves failed Windows Update events.
        .DESCRIPTION
            This function retrieves Windows Update events that indicate that
            Windows Update failed to install an update.
        .EXAMPLE
            Get-AdatumFailedUpdateEvent -Count 10

            This example retrieves the last 10 failed Windows Update events.
    #>
    [OutputType('FailedUpdateEvent')]
    [CmdletBinding()]
    param (
            [int]
            # The number of events to retrieve.
        $Count,
            [datetime]
            # The date from which to retrieve events.
        $StartDate
    )

    $EventFilter = @{
        ProviderName = 'Microsoft-Windows-WindowsUpdateClient'
        ID           = 20
    }
    if ($StartDate) {
        $EventFilter.StartTime = $StartDate
    }

    $EventParams = @{}
    if ($Count) {
        $EventParams.MaxEvents = $Count
    }

    foreach ($CurrentEvent in Get-WinEvent -FilterHashtable $EventFilter @EventParams) {
        [PSCustomObject] @{
            PSTypeName   = 'FailedUpdateEvent'
            TimeCreated  = $currentEvent.TimeCreated
            Level        = [Diagnostics.Eventing.Reader.StandardEventLevel] $currentEvent.Level
            ComputerName = $currentEvent.MachineName
            ErrorCode    = $CurrentEvent.Properties[0].Value
            UpdateTitle  = $CurrentEvent.Properties[1].Value
        }
    }
}

function Set-AdatumComputerState {
    <#
        .SYNOPSIS
            Sets the computer state - logged off, powered off, etc.
        .DESCRIPTION
            This function will set the state of the computer.
            Applications running on the target computer are able to cancel the action
            unless you also specify -Force.
        .EXAMPLE
            Set-AdatumComputerState -State Shutdown

            This example shuts down the computer.
        .LINK
            https://learn.microsoft.com/powershell/scripting/samples/changing-computer-state
    #>
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
            [Parameter(Mandatory)]
            [ValidateSet('Lock', 'Logoff', 'Restart', 'Shutdown', 'Sleep')]
            [string]
            # The state to set the computer.
        $State,

            [switch]
            # Use this parameter to override application cancellations and force the
            # desired state.
        $Force
    )

    switch ($State) {
        'Lock' {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, $State)) {
                tsdiscon.exe
            }
        }
        'LogOff' {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, $State)) {
                logoff.exe
            }
        }
        'Restart' { Restart-Computer -Force:$Force }
        'Shutdown' { Stop-Computer -Force:$Force }
        'Sleep' {
            if ($PSCmdlet.ShouldProcess($env:COMPUTERNAME, $State)) {
                Add-Type -AssemblyName System.Windows.Forms
                [Windows.Forms.Application]::SetSuspendState(
                    [Windows.Forms.PowerState]::Suspend,
                    $Force,
                    $false
                )
            }
        }
    }
}

function Get-AdatumStyleSheet {
    [OutputType([string])]
    [CmdletBinding()]
    param()

    @'
        <style>
            body {
                font-family:Segoe,Tahoma,Arial,Helvetica;
                font-size:10pt;
                color:#333;
                background-color:#eee;
                margin:10px;
            }
            th {
                font-weight:bold;
                color:white;
                background-color:#333;
            }
        </style>
'@
}

function Read-Choice {
    <#
        .SYNOPSIS
            Uses PromptForChoice host function to ask for choices
        .DESCRIPTION
            This helper function uses interactive choice menu to let user choose the value
        .NOTES
            Choices dictionary will become the choices to choose between.
            Each element's Key is used as Label and Value is used as HelpMessage.
            Label can contain character '&' to identify the next character in the label as a "hot key".
        .LINK
            https://learn.microsoft.com/dotnet/api/system.management.automation.host.pshostuserinterface.promptforchoice
        .EXAMPLE
            $Choice = @{
                '&one' = 'choice one'
                't&wo' = 'second choice'
            }
            Read-Choice -Message 'please make your choice' -Choices $Choice -default 'two'

            This example lets user to choose between 2 choices.
        .EXAMPLE
            $Choice = [ordered] @{
                '&one' = 'choice one'
                't&wo' = 'second choice'
            }
            Read-Choice -Message 'please make your choice' -Choices $Choice -default 'two'

            This example uses OrderedDictionary to maintain choices order.
    #>

    [OutputType([string])]
    [CmdletBinding()]
    param (
            [Alias('Caption')]
            [string]
            # Caption to precede or title the prompt
        $Title = 'Choices',
            [string]
            # A message that describes what the choice is for
        $Message = 'Make a choice',
            [Parameter(Mandatory)]
            [Collections.IDictionary]
            # Choices in the form of hashtable or OrderedDictionary.
        $Choices,
            [string]
            # The label of the default value (without hotkey)
        $Default
    )

    $OptionList = foreach ($hash in $Choices.GetEnumerator()) {
        New-Object -TypeName Management.Automation.Host.ChoiceDescription -ArgumentList @(
            $hash.Key   # Label
            $hash.Value # HelpMessage
        )
    }

    $DefaultNumber = -1
    if ($Default) {
        foreach ($item in $OptionList) {
            $DefaultNumber++
            if ($item.Label.Replace('&', '') -eq $Default) { break }
        }
    }

    $result = $host.ui.PromptForChoice(
        $Title,
        $Message,
        $OptionList,
        $DefaultNumber
    )

    $OptionList[$result].Label.Replace('&', '')
}
