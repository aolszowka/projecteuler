function Get-Prime {
    [CmdletBinding()]
    param (
        $Limit = [long]::MaxValue
    )
    begin {
        [System.Collections.Generic.LinkedList[long]]$sleve = @(2)
    }

    process {
        
        # Make sure that 2 is printed out as a prime
        2

        $current = 3
        while ($current -le $Limit) {
            $isPrime = $true
            foreach ($knownPrime in $sleve) {
                if ($current % $knownPrime -eq 0) {
                    $isPrime = $false
                    break
                }
            }

            if ($isPrime) {
                $sleve.Add($current) | Out-Null
                $current
            }

            $current++
        }
    }
}

function Factor-Primes {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $FactorThis
    )
    process {
        $firstPrimeDivisibleBy = Get-Prime -Limit $FactorThis | ForEach-Object {
            if($FactorThis % $_ -eq 0) {
                $_
                break
            }
        }

        $remainder = $FactorThis / $firstPrimeDivisibleBy
        if($remainder -eq 1) {
            $firstPrimeDivisibleBy
        }
        else {
            $firstPrimeDivisibleBy
            Factor-Primes -FactorThis $remainder
        }
    }
}

function Problem3-Solution {
    Factor-Primes -FactorThis 600851475143 | Sort-Object -Descending | Select-Object -First 1
}

Problem3-Solution