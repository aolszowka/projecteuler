[System.Numerics.BigInteger[]]$bigNumbers = Get-Content $PSScriptRoot\Input.txt | ForEach-Object { [System.Numerics.BigInteger]::Parse($_) }

[System.Numerics.BigInteger]$Sum = 0
foreach ($bigInt in $bigNumbers) {
    $Sum = [System.Numerics.BigInteger]::Add($Sum, $bigInt)
}

$first10Digits = $Sum.ToString().GetEnumerator() | Select-Object -First 10
[string]::new($first10Digits)
