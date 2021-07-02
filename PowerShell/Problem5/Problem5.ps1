function Test-EvenlyDivisible {
    [CmdletBinding()]
    param (
        [long]$Test,
        [long]$Range
    )
    process {
        $isEvenlyDivisibleThoughRange = $true
        for ($i = $Range; $i -gt 0; $i--) {
            if ($Test % $i -ne 0) {
                $isEvenlyDivisibleThoughRange = $false
                break;
            }
        }

        $isEvenlyDivisibleThoughRange
    }

}

function Get-UpperBoundOfEvenlyDivisible {
    [CmdletBinding()]
    param (
        [long]$Range
    )
    process {
        $UpperBound = 1
        for ($i = $Range; $i -gt 0; $i--) {
            $UpperBound = $UpperBound * $i
        }

        $UpperBound
    }
}

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
        if ($FactorThis -eq 1) {
            $FactorThis
        }
        else {
            $firstPrimeDivisibleBy = Get-Prime -Limit $FactorThis | ForEach-Object {
                if ($FactorThis % $_ -eq 0) {
                    $_
                }
            } | Select-Object -First 1

            $remainder = $FactorThis / $firstPrimeDivisibleBy
            if ($remainder -eq 1) {
                $firstPrimeDivisibleBy
            }
            else {
                $firstPrimeDivisibleBy
                Factor-Primes -FactorThis $remainder
            }
        }
    }
}

function Get-LowerBoundOfEvenlyDivisible {
    [CmdletBinding()]
    param (
        [long]$Range
    )
    process {
        # PowerShell Implementation of https://en.wikipedia.org/wiki/Least_common_multiple#Using_prime_factorization

        # Get the Prime Factorization for the Range
        [System.Collections.Generic.Dictionary[int, System.Collections.Generic.Dictionary[int,int]]]$factorization = [System.Collections.Generic.Dictionary[int, System.Collections.Generic.Dictionary[int,int]]]::new()
        for ($i = 1; $i -le $Range; $i++) {
            $factorizationForSpecificNumber = Factor-Primes -FactorThis $i
            [System.Collections.Generic.Dictionary[int,int]]$factorizationForSpecificNumberPowers = [System.Collections.Generic.Dictionary[int,int]]::new()
            foreach($factor in $factorizationForSpecificNumber) {
                if(-Not($factorizationForSpecificNumberPowers.ContainsKey($factor))) {
                    $factorizationForSpecificNumberPowers[$factor] = 0
                }
                $factorizationForSpecificNumberPowers[$factor]++
            }
            $factorization[$i] = $factorizationForSpecificNumberPowers
        }

        # Find the Highest Power of Each Prime
        [System.Collections.Generic.Dictionary[int,int]]$primeHighestPower = [System.Collections.Generic.Dictionary[int,int]]::new()
        foreach($factorValue in $factorization.Values.GetEnumerator()) {
            foreach($factor in $factorValue.GetEnumerator()) {
                if(-Not($primeHighestPower.ContainsKey($factor.Key))) {
                    $primeHighestPower[$factor.Key] = $factor.Value
                }

                if($primeHighestPower[$factor.Key] -lt $factor.Value) {
                    $primeHighestPower[$factor.Key] = $factor.Value
                }
            }
        }

        # Now Multiply these out
        $lowerBound = 1
        foreach($primePower in $primeHighestPower.GetEnumerator()) {
            $lowerBound = $lowerBound * $([Math]::Pow($primePower.Key, $primePower.Value))
        }

        $lowerBound
    }
}

Get-LowerBoundOfEvenlyDivisible -Range 20