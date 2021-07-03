function Test-Pythagorean {
    <#
    Defined as A < B < C where A^2 + B^2 = C^2
    #>
    [CmdletBinding()]
    param (
        [long]$A,
        [long]$B,
        [long]$C
    )
    process {
        $aSquared = [Math]::Pow($A, 2)
        $bSquared = [Math]::Pow($B, 2)
        $cSquared = [Math]::Pow($C, 2)

        $isPythagorean = (($aSquared + $bSquared) -eq $cSquared)
        $isPythagorean
    }
}

function Get-Pythagorean {
    <#
    Defined as A < B < C where A^2 + B^2 = C^2
    #>
    [CmdletBinding()]
    param (
        [long]$Limit = [long]::MaxValue
    )
    process {
        for ($a = 1; $a -le $Limit; $a++) {
            for ($b = $a + 1; $b -le $Limit; $b++) {
                $c = [Math]::Sqrt($([Math]::Pow($a, 2)) + $([Math]::Pow($b, 2)))
                if ($c % 1 -eq 0) {
                    # Could be short circuted here just to return the object
                    # but people seem to claim that `Math.Sqrt % 1 -eq 0` trick
                    # above breaks for large values.
                    if (Test-Pythagorean -A $a -B $b -C $c) {
                        $([PSCustomObject]@{
                                A = $a
                                B = $b
                                C = $c
                            })
                    }
                }
            }
        }
    }
}

$Target = 1000
$pythagorean = Get-Pythagorean -Limit $Target | ForEach-Object {
    if($_.A + $_.B + $_.C -eq $Target) {
        $_
        break
    }
}

Write-Output "This is the First Matching Pythagorean"
$pythagorean

Write-Output "`nThis is the Product of A * B * C"
$pythagorean.A * $pythagorean.B * $pythagorean.C