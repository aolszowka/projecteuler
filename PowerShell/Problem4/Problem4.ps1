function Test-Palindrome {
    [CmdletBinding()]
    param (
        [string]$PossiblePalindrome
    )
    
    process {
        # Need a String.Reverse
        [System.Collections.Generic.Stack[char]]$stack = @()
        foreach ($char in $PossiblePalindrome.GetEnumerator()) {
            $stack.Push($char)
        }
        [System.Text.StringBuilder]$reversed = [System.Text.StringBuilder]::new()
        while ($stack.Count -ne 0) {
            $reversed.Append($stack.Pop()) | Out-Null
        }

        # See if the reversed is equal to the input
        $PossiblePalindrome -eq $($reversed.ToString())
    }
}

function Problem4-Solution {
    [System.Collections.Generic.LinkedList[int]]$palindromes = @()

    # Brute Force the Entire Space
    for ($i = 999; $i -gt 0; $i--) {
        for ($j = 999; $j -gt 0; $j--) {
            $product = $i * $j
            if (Test-Palindrome -PossiblePalindrome $product.ToString()) {
                $palindromes.Add($product) | Out-Null
                break
            }
        }
    }

    $palindromes | Measure-Object -Maximum
}

Problem4-Solution