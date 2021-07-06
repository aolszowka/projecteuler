function Get-PrimeParallel {
    [CmdletBinding()]
    param (
        $Limit = [long]::MaxValue
    )
    begin {
        [System.Collections.Generic.List[long]]$sleve = @(2)
    }

    process {
        # Make sure that 2 is printed out as a prime
        2

        $current = 3
        while ($current -le $Limit) {
            $wasDivisibleByPrime = $sleve | ForEach-Object -Parallel {
                    if ($using:current % $_ -eq 0) {
                        $true
                        break
                    }
            }

            $isPrime = $null -eq $wasDivisibleByPrime

            if ($isPrime) {
                $sleve.Add($current) | Out-Null
                $current
            }

            $current = $current + 2
        }
    }
}

function Get-PrimeSequential {
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

            $current = $current + 2
        }
    }
}

Start-Transcript -Path 2MillionPrime.txt
$primesLessThan2Million = Get-PrimeSequential | ForEach-Object { if($_ -gt 2000000) { break } $_ }
$primesLessThan2Million | Measure-Object -Sum
Stop-Transcript