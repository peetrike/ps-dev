function TestScope {
    Write-Host ('  In function at the start, $var is "{0}"' -f $var)
    Pause

    $var = 'function var'
    Write-Host ('  In function after definition, $var is "{0}"' -f $var)
    Pause

    Write-Host ('  The script scope can still be accessed: "{0}"' -f $script:var)
    $var
}

$var = 'script var'
'In script, $var is "{0}"' -f $var
Pause

$functionVar = TestScope
'In script after running function, $var is "{0}"' -f $var
Pause

'The $functionVar, passed back: "{0}"' -f $functionVar
'The global $var: "{0}"' -f $global:var
