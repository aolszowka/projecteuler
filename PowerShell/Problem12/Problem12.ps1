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
                [long]$UpperBound
            )
            
            begin {
                if (-Not(Test-Path Variable:\primeSieve)) {
                    [System.Collections.Generic.LinkedList[long]]$global:primeSieve = [System.Collections.Generic.LinkedList[long]]::new()
                    $global:primeSieve.Add(2)
                }
            }
            process {
                if ($global:primeSieve.Last.Value -lt $UpperBound) {
                    for ($i = $global:primeSieve.Last.Value + 1; $i -le $UpperBound; $i++) {
                        $isPrime = $true
                        foreach ($prime in $global:primeSieve) {
                            if ($i % $prime -eq 0) {
                                $isPrime = $false
                                break
                            }
                        }

                        if ($isPrime) {
                            $global:primeSieve.Add($i) | Out-Null
                        }
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
            Update-PrimeSieve -UpperBound $Target
            $firstPrimeDivisibleBy = $global:primeSieve | Where-Object { $Target % $_ -eq 0 } | Select-Object -First 1
            if ($firstPrimeDivisibleBy -eq 0) {
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

# Get-TriangleNumbers | ForEach-Object {
#    $numberOfDivisors = Get-NumberOfDivisors -Target $_
#    if ($numberOfDivisors -gt 500) {
#        $_
#        break
#    }
# }


function Get-NumberOfDivisors2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [long]$Target
    )
    process {
        $nod = 0
        $sqrt = [int]$([Math]::Sqrt($Target))

        for($i=1;$i -le $sqrt; $i++) {
            if($Target % $i -eq 0) {
                $nod += 2
            }
        }

        if($sqrt * $sqrt -eq $Target) {
            $nod--
        }

        $nod
    }
}

Get-NumberOfDivisors2 28
Get-PrimeFactorization 28