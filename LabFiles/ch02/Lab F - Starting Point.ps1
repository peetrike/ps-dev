function Clear-TempFolder {
    <#
        .SYNOPSIS
            Empties temp folders provided
        .DESCRIPTION
            This script empties temp folders provided
    #>
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory,
                ValueFromPipeline,
                ValueFromPipelineByPropertyName
            )]
            [ValidateScript({
                Test-Path -Path $_ -PathType Container
            })]
            [Alias('FullName')]
            [string[]]
            # Specifies path to search for temp folder
        $Path,
            [switch]
            # Specifies, that temp folders from environment variables should be also processed
        $IncludeEnvironment
    )

    begin {
        if ($IncludeEnvironment.IsPresent) {
            $Path += $env:TEMP, $env:TMP
        }
        $Path = $Path | Sort-Object -Unique
    }

    process {
        foreach ($item in $Path) {
            Get-ChildItem -Path $item | Remove-Item -Recurse
        }
    }
}
