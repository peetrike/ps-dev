<#
    .SYNOPSIS
        Chapter 03 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 03 - Creating Modules
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M3
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Creating a Script Module

#region Understanding Script Modules

# https://learn.microsoft.com/powershell/scripting/lang-spec/chapter-11
# https://learn.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-script-module

New-Module -Name SayHello -ScriptBlock {
    function get-hello {
        'Hello'
    }
} | Import-Module
Get-Module SayHello
get-hello
Remove-Module SayHello

#endregion

#region Converting a Script into a Script Module

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_automatic_variables#myinvocation
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_automatic_variables#pscommandpath
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_automatic_variables#psscriptroot

# https://github.com/peetrike/Examples/blob/main/src/Functions/test-autovars.ps1
# https://github.com/peetrike/Examples/blob/main/src/Functions/test-modulevars.psm1

Get-Help Export-ModuleMember

#endregion

#region Testing a Script Module

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_modules#manually-import-a-module

Get-Help Import-Module -Parameter Name

Get-Help Import-Module -Parameter Function
Get-Help Import-Module -Parameter Alias

#endregion

#endregion


#region Lesson 2 - Creating a Module Manifest

#region Understanding Module Manifest

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_module_manifests

#endregion

#region Creating Module Manifest

Get-Command -Noun ModuleManifest -Module Microsoft.PowerShell.Core

New-ModuleManifest -Path .\myModule.psd1 -ModuleVersion 2.0 -Author $env:USERNAME

Get-Command -Verb update -Noun *ModuleManifest

# https://learn.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest#sample-module-manifest

#endregion

#region Manifest fields that affect module loading

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_module_manifests#manifest-settings

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_module_manifests#requiredmodules

#endregion

#region Metadata fields in Manifest

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_module_manifests#moduleversion

#endregion

#endregion


#region Lesson 3 - Installing Modules

#region Module Autoloading

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_modules#module-autoloading

# https://learn.microsoft.com/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands

#endregion

#region Module folder structure

#endregion

#region Module search paths

Get-Help about_PSModulePath -ShowWindow

$env:PSModulePath -split [IO.Path]::PathSeparator

#Requires -Version 7.4
Get-ExperimentalFeature -Name PSModuleAutoLoadSkipOfflineFiles


#endregion

#region Installing Modules

# https://learn.microsoft.com/powershell/gallery/how-to/working-with-local-psrepositories

# https://github.com/peetrike/scripts/blob/master/src/ComputerManagement/PowerShell/Update-PowerShellGet.ps1

Get-Command Install-Module
Get-Command Install-PSResource

Get-Command Update-Module
Get-Command Update-PSResource

#endregion

#endregion


#region Lesson 4 - Publishing Modules

#region Module Requirements for Publishing

# https://learn.microsoft.com/powershell/gallery/how-to/publishing-packages/publishing-a-package#required-metadata-for-items-published-to-the-powershell-gallery

#endregion

#region Publishing Module using PowerShellGet

Get-Help Publish-Module -ShowWindow

# https://learn.microsoft.com/powershell/utility-modules/secretmanagement/overview

#endregion

#region Publishing Module using PSResourceGet

# https://devblogs.microsoft.com/powershell/psresourceget-is-generally-available/

Get-Help Publish-PSResource -ShowWindow

# https://learn.microsoft.com/powershell/gallery/powershellget/supported-repositories

#endregion

#endregion


#region Lab - Creating a Script Module

#endregion
