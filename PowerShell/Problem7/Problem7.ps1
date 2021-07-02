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

Get-Prime | Select-Object -First 10001 | Sort-Object -Descending | Select-Object -First 1