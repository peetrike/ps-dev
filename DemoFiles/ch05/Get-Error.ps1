function Get-Error {
    [CmdletBinding()]
    param (
            [Parameter(
                ValueFromPipeline
            )]
        $InputObject = $Error,
            [int]
        $Newest = 1
    )

    begin {
        function Show-ErrorRecord {
            param ($obj, [int]$indent = 0, [int]$depth = 1)

            $newline = [Environment]::Newline
            $output = [Text.StringBuilder]::new()
            $prefix = ' ' * $indent

            $expandTypes = @(
                'Microsoft.Rest.HttpRequestMessageWrapper'
                'Microsoft.Rest.HttpResponseMessageWrapper'
                'System.Management.Automation.InvocationInfo'
            )

            # if object is an Exception, add an ExceptionType property
            if ($obj -is [Exception]) {
                $typeName = $obj.GetType().FullName
                $obj | Add-Member -NotePropertyName Type -NotePropertyValue $typeName -ErrorAction Ignore
            }

            # first find the longest property so we can indent properly
            $propLength = 0
            foreach ($prop in $obj.PSObject.Properties) {
                if (
                    $prop.Value -ne $null -and
                    $prop.Value -ne [string]::Empty -and
                    $prop.Name.Length -gt $propLength
                ) {
                    $propLength = $prop.Name.Length
                }
            }

            $addedProperty = $false
            foreach ($prop in $obj.PSObject.Properties) {

                # don't show empty properties or our added property for $error[index]
                if (
                    $null -ne $prop.Value -and
                    $prop.Value -ne [string]::Empty -and
                    $prop.Value.count -gt 0 -and
                    $prop.Name -ne 'PSErrorIndex'
                ) {
                    $addedProperty = $true
                    $null = $output.Append($prefix)
                    $null = $output.Append($accentColor)
                    $null = $output.Append($prop.Name)
                    $propNameIndent = ' ' * ($propLength - $prop.Name.Length)
                    $null = $output.Append($propNameIndent)
                    $null = $output.Append(' : ')
                    $null = $output.Append($resetColor)

                    $newIndent = $indent + 4

                    # only show nested objects that are Exceptions, ErrorRecords, or types defined in $expandTypes and types not in $ignoreTypes
                    if (
                        $prop.Value -is [Exception] -or
                        $prop.Value -is [System.Management.Automation.ErrorRecord] -or
                        $expandTypes -contains $prop.TypeNameOfValue -or
                        ($prop.TypeNames -ne $null -and $expandTypes -contains $prop.TypeNames[0])
                    ) {
                        if ($depth -ge $maxDepth) {
                            $null = $output.Append($ellipsis)
                        } else {
                            $null = $output.Append($newline)
                            $null = $output.Append((Show-ErrorRecord $prop.Value $newIndent ($depth + 1)))
                        }
                    } elseif (
                        $prop.Name -eq 'TargetSite' -and
                        $prop.Value.GetType().Name -eq 'RuntimeMethodInfo'
                    ) {
                        # `TargetSite` has many members that are not useful visually, so we have a reduced view of the relevant members
                        if ($depth -ge $maxDepth) {
                            $null = $output.Append($ellipsis)
                        } else {
                            $targetSite = [PSCustomObject]@{
                                Name = $prop.Value.Name
                                DeclaringType = $prop.Value.DeclaringType
                                MemberType = $prop.Value.MemberType
                                Module = $prop.Value.Module
                            }

                            $null = $output.Append($newline)
                            $null = $output.Append((Show-ErrorRecord $targetSite $newIndent ($depth + 1)))
                        }
                    } elseif ($prop.Name -eq 'StackTrace') {
                        # `StackTrace` is handled specifically because the lines are typically long but necessary so they are left justified without additional indentation
                        # for a stacktrace which is usually quite wide with info, we left justify it
                        $null = $output.Append($newline)
                        $null = $output.Append($prop.Value)
                    } elseif (
                        $prop.Value.GetType().Name.StartsWith('Dictionary') -or
                        $prop.Value.GetType().Name -eq 'Hashtable'
                    ) {
                        # Dictionary and Hashtable we want to show as Key/Value pairs, we don't do the extra whitespace alignment here
                        $isFirstElement = $true
                        foreach ($key in $prop.Value.Keys) {
                            if ($isFirstElement) {
                                $null = $output.Append($newline)
                            }

                            if ($key -eq 'Authorization') {
                                $null = $output.Append("${prefix}    ${accentColor}${key} : ${resetColor}${ellipsis}${newline}")
                            } else {
                                $null = $output.Append("${prefix}    ${accentColor}${key} : ${resetColor}$($prop.Value[$key])${newline}")
                            }

                            $isFirstElement = $false
                        }
                    } elseif (
                        -not ($prop.Value -is [System.String]) -and
                        $prop.Value.GetType().GetInterface('IEnumerable') -ne $null -and
                        $prop.Name -ne 'Data'
                    ) {
                        # if the object implements IEnumerable and not a string, we try to show each object
                        # We ignore the `Data` property as it can contain lots of type information by the interpreter that isn't useful here

                        if ($depth -ge $maxDepth) {
                            $null = $output.Append($ellipsis)
                        } else {
                            $isFirstElement = $true
                            foreach ($value in $prop.Value) {
                                $null = $output.Append($newline)
                                $valueIndent = ' ' * ($newIndent + 2)

                                if ($value -is [Type]) {
                                    # Just show the typename instead of it as an object
                                    $null = $output.Append("${prefix}${valueIndent}[$($value.ToString())]")
                                } elseif ($value -is [string] -or $value.GetType().IsPrimitive) {
                                    $null = $output.Append("${prefix}${valueIndent}${value}")
                                } else {
                                    if (-not $isFirstElement) {
                                        $null = $output.Append($newline)
                                    }
                                    $null = $output.Append((Show-ErrorRecord $value $newIndent ($depth + 1)))
                                }
                                $isFirstElement = $false
                            }
                        }
                    } elseif ($prop.Value -is [Type]) {
                        # Just show the typename instead of it as an object
                        $null = $output.Append("[$($prop.Value.ToString())]")
                    } else {
                        # Anything else, we convert to string.
                        # ToString() can throw so we use LanguagePrimitives.TryConvertTo() to hide a convert error
                        $value = $null
                        if (
                            [Management.Automation.LanguagePrimitives]::TryConvertTo(
                                $prop.Value, [string], [ref]$value
                            ) -and
                            $value -ne $null
                        ) {
                            if ($prop.Name -eq 'PositionMessage') {
                                $value = $value.Insert($value.IndexOf('~'), $errorColor)
                            } elseif ($prop.Name -eq 'Message') {
                                $value = $errorColor + $value
                            }

                            $isFirstLine = $true
                            if ($value.Contains($newline)) {
                                # the 3 is to account for ' : '
                                $valueIndent = ' ' * ($propLength + 3)
                                # need to trim any extra whitespace already in the text
                                foreach ($line in $value.Split($newline)) {
                                    if (-not $isFirstLine) {
                                        $null = $output.Append("${newline}${prefix}${valueIndent}")
                                    }
                                    $null = $output.Append($line.Trim())
                                    $isFirstLine = $false
                                }
                            } else {
                                $null = $output.Append($value)
                            }
                        }
                    }

                    $null = $output.Append($newline)
                }
            }

            # if we had added nested properties, we need to remove the last newline
            if ($addedProperty) {
                $null = $output.Remove($output.Length - $newline.Length, $newline.Length)
            }

            $output.ToString()
        }
        Set-StrictMode -Off
        $maxDepth = 10
        $ellipsis = "`u{2026}"
        $resetColor = ''
        $errorColor = ''
        $accentColor = ''

        if ($Host.UI.SupportsVirtualTerminal -and ([string]::IsNullOrEmpty($env:__SuppressAnsiEscapeSequences))) {
            if ($null -eq $PSStyle) {
                Import-Module PSStyle -ErrorAction Ignore
            }
            $resetColor = $PSStyle.Reset
            $errorColor = $psstyle.Formatting.Error
            $accentColor = $PSStyle.Formatting.FormatAccent
        }
        $Count = 0
    }

    process {
        foreach ($record in $InputObject) {
            $count++
            Show-ErrorRecord $record
            if ($count -ge $Newest) {
                return
            }
        }
    }
}
