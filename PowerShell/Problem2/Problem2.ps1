function Generate-Fibonacci {
    [CmdletBinding()]
    param($Limit = [long]::MaxValue)
    process {
        [long]$current = 0
        [long]$previousMinus1 = 0
        [long]$previous = 1
        while($current -lt $Limit) {
            # Get the Next Fib Sequence
            [long]$current = $previous + $previousMinus1

            # Return it
            $current

            # Setup for the next fib sequence
            $previousMinus1 = $previous
            $previous = $current
        }
    }
}

function Problem2-Solution {
    $evenFib = Generate-Fibonacci -Limit 4000000 | Where-Object { $_ % 2 -eq 0 }
    $total = 0
    foreach($i in $evenFib) {
        $total = $total + $i
    }
    $total
}

Problem2-Solution