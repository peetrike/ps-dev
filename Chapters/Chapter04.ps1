<#
    .SYNOPSIS
        Chapter 04 samples
    .DESCRIPTION
        This file contains sample commands from course PS-Dev for
        Chapter 04 - Extending PowerShell with .NET and REST API
    .LINK
        https://github.com/peetrike/ps-dev
    .LINK
        https://diigo.com/profile/peetrike/?query=%23PS-Dev+%23M4
#>

#region Safety to prevent the entire script from being run instead of a selection
throw "You're not supposed to run the entire script"
#endregion


#region Lesson 1 - Using .NET Class Library in PowerShell

#region .NET classes, properties, and methods

Find-Module ClassExplorer -Repository PSGallery

Find-Type Dns
Find-Type Dns | Find-Member

Find-Type StringBuilder
Find-Type StringBuilder | Find-Member

Find-Type WebRequest
Find-Type WebRequest | Find-Member

Find-Member MessageBox

#endregion

#region .NET documentation

# https://github.com/peetrike/PWAddins/blob/master/src/Public/Get-TypeUrl.ps1
Find-Type WebRequest | Get-TypeUrl -Invoke
Find-Type Dns | Get-TypeUrl -Invoke
(Get-Process -id $PID).GetType() | Get-TypeUrl

#endregion

#region Using static .NET class members

[System.Math]::PI

[guid]::NewGuid()
[System.Console]::WriteLine('Hello World')

[Math].GetMembers()
Find-Member PI

[System.Guid] | Get-Member -Static

#endregion

#region Comparing the .NET syntax to command syntax

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_methods

#endregion

#region Instantiating classes and using instance members

# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_object_creation

$Service = Get-Service -Name BITS
$Service.GetType()
$Service | Find-Type

Get-Process -Id $PID | Get-Member -MemberType Methods
(Get-Process -Id $PID).WaitForExit

$encoding = New-Object -TypeName System.Text.UTF8Encoding
    #Requires -Version 5
$encoding = [Text.UTF8Encoding]::new()
[datetime]::new

'2024.12.20' -as [datetime]
[datetime] '2024.12.20'
'2024.12.20' | Get-Member -MemberType Method -Name *datetime

'3:15' -as [timespan]

#endregion

#region Understanding enumerations

# https://learn.microsoft.com/dotnet/fundamentals/runtime-libraries/system-enum

[System.DayOfWeek]

# https://github.com/peetrike/PWAddins/blob/master/src/Public/Get-EnumValue.ps1
Get-EnumValue DayOfWeek
[DayOfWeek] | Get-EnumValue

[DayOfWeek]::Monday
[DayOfWeek]::Monday.value__
[DayOfWeek] 1
[DayOfWeek] 'Monday'

# https://learn.microsoft.com/dotnet/fundamentals/runtime-libraries/system-flagsattribute

#endregion

#endregion


#region Lab A - Using .NET in PowerShell

#endregion


#region Lesson 2 - Adding custom .NET code to PowerShell scripts

#region Modules with custom classes

Get-Module -ListAvailable |
    Where-Object RequiredAssemblies |
    Select-Object -Property Name, RequiredAssemblies

#endregion

#region Loading available .NET components

Get-Help Add-Type -Parameter AssemblyName

#endregion

#region Loading .NET components from file

Get-Help Add-Type -Parameter *Path

#endregion

#region Using the NuGet repositories

Get-Help Register-PackageSource

Get-PackageSource Nuget
Find-Package terminal.gui -Source Nuget

Get-Command -Noun Package

Get-Command Register-PSResourceRepository

Get-PSResourceRepository Nuget
Find-PSResource -Name epplus -Repository Nuget

Get-Command -Noun PSResource

#endregion

#region Writing an inline C# code

Add-Type -TypeDefinition @'
    using System;
    using System.Runtime.InteropServices;

    public class User32 {
        [DllImport("user32.dll")]
        public static extern int MessageBox(
            IntPtr WindowHandle,
            string Message,
            string Caption,
            int Type);
    }
'@

$IconInformation = 0x40
[User32]::MessageBox(0, 'A short message', 'Title', $IconInformation)

#endregion

#region Using PowerShell Classes

Get-Help classes
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_classes
# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_enum

#endregion

#endregion


#region Lesson 3 - Using REST API in PowerShell

#region What is REST API

# https://en.wikipedia.org/wiki/REST
# https://restfulapi.net/

#endregion

#region The REST API documentation

# https://spec.openapis.org/oas/latest.html

# https://reqres.in/api-docs/

#endregion

#region REST API Syntax

# https://restfulapi.net/resource-naming/
# https://restful-api.dev/

#endregion

#region Invoking REST API methods by using PowerShell

Get-Help Invoke-RestMethod -ShowWindow
Get-Help Invoke-WebRequest -ShowWindow

# https://ipinfo.io/developers
Invoke-RestMethod -Uri https://ipinfo.io/json

Invoke-RestMethod -Uri https://official-joke-api.appspot.com/jokes/random
Invoke-RestMethod -Uri https://official-joke-api.appspot.com/jokes/ten

#endregion

#endregion


#region Lab B - Using REST API in PowerShell

#endregion


#region Lesson 4 - Reading, manipulating, and writing data in XML

#region Why use XML?

Get-WinEvent -LogName Application -MaxEvents 1 | ForEach-Object ToXml

#endregion

#region Understanding XML

# http://www.w3.org/TR/xml

#endregion

#region Reading XML data into memory

Find-Type XmlDocument
Find-Type XmlDocument | Find-Member Load*
Find-Type XmlDocument | Get-TypeUrl -Invoke

$document = [xml] ""
$document.Load("Demo1.xml")

# don't do this
$document = [xml] (Get-Content Demo1.xml)

#endregion

#region Searching for XML elements

# http://www.w3.org/TR/xpath

Find-Type XmlDocument | Find-Member SelectNodes
Find-Type XmlDocument | Find-Member SelectSingleNode

#endregion

#region Manipulating XML nodes

Find-Type XmlDocument | Find-Member CreateElement
Find-Type XmlElement | Find-Member AppendChild

Find-Type XmlNode | Find-Member RemoveChild

#endregion

#region Manipulating XML attributes

Find-Type XmlDocument | Find-Member CreateAttribute
Find-Type XmlElement | Find-Member SetAttributeNode

# saving results
$document.Save("Demo1.xml")
$document.OuterXml | Set-Content -Path demo3.xml -Encoding utf8

#endregion

#endregion


#region Lab C - Processing XML-formatted data

#endregion


#region Lesson 5 - Reading and manipulating custom-formatted data

#region Introduction to regular expressions

Get-Help about_Regular_Expressions -ShowWindow
Get-Help Select-String -ShowWindow
Find-Type Regex | Find-Member

#endregion

#region Basic delimited parsing with ConvertFrom-String

# Windows PowerShell 5.x
Get-Help ConvertFrom-String -ShowWindow

#endregion

#region Example-driven parsing with ConvertFrom-String

Get-Help ConvertFrom-String -Parameter TemplateContent
Get-Help ConvertFrom-String -Parameter TemplateFile
Get-Help ConvertFrom-String -Parameter UpdateTemplate

#endregion

#region Manipulating strings with Convert-String

# Windows PowerShell 5.x
Get-Help Convert-String -ShowWindow

#endregion

#endregion
