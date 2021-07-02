function Get-SumOfSquares {
    [CmdletBinding()]
    param (
        [long]$Range
    )
    process {
        [long]$result = 0
        for ($i = $Range; $i -gt 0; $i--) {
            $result = $result + $([Math]::Pow($i, 2))
        }
        $result
    }
}

function Get-SquareOfSum {
    [CmdletBinding()]
    param (
        [long]$Range
    )
    process {
        $summation = 0
        for ($i = $Range; $i -gt 0; $i--) {
            $summation = $summation + $i
        }
        $result = $([Math]::Pow($summation, 2))
        $result
    }
}

$(Get-SquareOfSum -Range 100) - $(Get-SumOfSquares -Range 100)