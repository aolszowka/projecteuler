function Get-TriangleNumbers {
    [CmdletBinding()]
    param (
        [int]$Limit = [int]::MaxValue
    )
    process {
        [long]$CurrentSumationResult = 0
        for ($i = 1; $i -le $Limit; $i++) {
            $CurrentSumationResult = $CurrentSumationResult + $i
            $CurrentSumationResult
        }
    }
}

# Brute Force
function Get-Divisors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [long]$Target
    )
    process {
        for ($i = 1; $i -le $Target; $i++) {
            if ($Target % $i -eq 0) {
                $i
            }
        }
    }
}

# Via Prime Factorization
function Get-NumberOfDivisors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [long]$Target
    )
    process {
        <#
        If you have the prime factorization of the number n, then to calculate
        how many divisors it has, you take all the exponents in the
        factorization, add 1 to each, and then multiply these "exponents + 1"s
        together.
        https://www2.math.upenn.edu/~deturck/m170/wk2/numdivisors.html
        #>
        $numberOfDivisors = 1
        $expontentForm = Get-PrimeFactorizationInExpontentForm -Target $Target
        foreach ($primeFactorization in $expontentForm.GetEnumerator()) {
            $numberOfDivisors = $numberOfDivisors * ($primeFactorization.Value + 1)
        }
        $numberOfDivisors
    }
}

function Get-PrimeFactorizationInExpontentForm {
    [CmdletBinding()]
    param (
        [long]$Target
    )

    process {
        $primeFactorization = Get-PrimeFactorization -Target $Target

        [System.Collections.Generic.Dictionary[long, long]]$factorsAndExpontents = [System.Collections.Generic.Dictionary[long, long]]::new()
        foreach ($prime in $primeFactorization) {
            if (-Not($factorsAndExpontents.ContainsKey($prime))) {
                $factorsAndExpontents.Add($prime, 0) | Out-Null
            }
            $factorsAndExpontents[$prime]++
        }

        $factorsAndExpontents
    }
}

function Get-PrimeFactorization {
    [CmdletBinding()]
    param (
        [long]$Target
    )
    begin {
        function Update-PrimeSieve {
            [CmdletBinding()]
            param (
                [long]$Target
            )
            
            begin {
                if (-Not(Test-Path Variable:\primeSieve)) {
                    [System.Collections.Generic.LinkedList[long]]$global:primeSieve = [System.Collections.Generic.LinkedList[long]]::new()
                    $global:primeSieve.Add(2)
                }
            }
            process {
                if ($Target -gt $global:primeSieve.Last.Value) {
                    $sqrt = [Math]::Ceiling($([Math]::Sqrt($Target)))
                    $isPrime = $true
                    foreach ($prime in $global:primeSieve) {
                        if ($prime -gt $sqrt) {
                            break
                        }

                        if ($Target % $prime -eq 0) {
                            $isPrime = $false
                            break
                        }
                    }

                    if ($isPrime) {
                        $global:primeSieve.Add($Target) | Out-Null
                    }
                }
            }
        }
    }

    process {
        if ($Target -eq 1) {
            $Target
        }
        else {
            Update-PrimeSieve -Target $Target
            $firstPrimeDivisibleBy = $global:primeSieve | Where-Object { $Target % $_ -eq 0 } | Select-Object -First 1
            if ($null -eq $firstPrimeDivisibleBy -or $firstPrimeDivisibleBy -eq 0) {
                throw "This is bad!"
            }
            $remainder = $Target / $firstPrimeDivisibleBy
            if ($remainder -eq 1) {
                $firstPrimeDivisibleBy
            }
            else {
                $firstPrimeDivisibleBy
                Get-PrimeFactorization -Target $remainder
            }
        }
    }
}

#Get-PrimeFactorization 28
Get-TriangleNumbers | ForEach-Object {
    $numberOfDivisors = Get-NumberOfDivisors -Target $_
    if ($numberOfDivisors -gt 500) {
        $_
        break
    }
}