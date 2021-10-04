function Get-CollatzSequence {
    param(
        [Parameter(Mandatory = $true)]
        [long]$InputObject,
        [Parameter(Mandatory = $false)]
        [System.Collections.Generic.Dictionary[long, [System.Collections.Generic.LinkedList[long]]]]$LookupTable = [System.Collections.Generic.Dictionary[long, [System.Collections.Generic.LinkedList[long]]]]::new()
    )
    process {
        if ($LookupTable.ContainsKey($InputObject)) {
            $LookupTable[$InputObject]
        }
        else {
            [System.Collections.Generic.LinkedList[long]]$collatzSequence = [System.Collections.Generic.LinkedList[long]]::new()
            [long]$currentInput = $InputObject
            $continueLooping = $true
            do {
                if ($LookupTable.ContainsKey($currentInput)) {
                    $continueLooping = $false
                    foreach ($remainingSequence in $LookupTable[$currentInput]) {
                        $collatzSequence.Add($remainingSequence)
                    }
                    $LookupTable.Add($InputObject, $collatzSequence) | Out-Null
                    $currentNode = $collatzSequence.First
                    do {
                        if (-Not($LookupTable.ContainsKey($currentNode.Value))) {
                            $remainderOfEnumeration = $currentNode
                            [System.Collections.Generic.LinkedList[long]]$subCollatzSequence = [System.Collections.Generic.LinkedList[long]]::new()
                            do {
                                $subCollatzSequence.Add($remainderOfEnumeration.Value)
                                $remainderOfEnumeration = $remainderOfEnumeration.Next
                            } while ($remainderOfEnumeration -ne $null)
                            $LookupTable.Add($currentNode.Value, $subCollatzSequence)
                        }
                        $currentNode = $currentNode.Next
                    } while ($null -ne $currentNode)
                    $collatzSequence
                }
                else {
                    $collatzSequence.Add($currentInput)
                    if ($currentInput -eq 1) {
                        $continueLooping = $false
                        $LookupTable.Add($InputObject, $collatzSequence) | Out-Null
                        $currentNode = $collatzSequence.First
                        do {
                            if (-Not($LookupTable.ContainsKey($currentNode.Value))) {
                                $remainderOfEnumeration = $currentNode
                                [System.Collections.Generic.LinkedList[long]]$subCollatzSequence = [System.Collections.Generic.LinkedList[long]]::new()
                                do {
                                    $subCollatzSequence.Add($remainderOfEnumeration.Value)
                                    $remainderOfEnumeration = $remainderOfEnumeration.Next
                                } while ($remainderOfEnumeration -ne $null)
                                $LookupTable.Add($currentNode.Value, $subCollatzSequence)
                            }
                            $currentNode = $currentNode.Next
                        } while ($null -ne $currentNode)
                        $collatzSequence
                    }
                    elseif ($currentInput % 2 -eq 0) {
                        $currentInput = $currentInput / 2
                    }
                    else {
                        $currentInput = $currentInput * 3 + 1
                    }
                }
            } while ($continueLooping)
        }
    }
}

$longestChainStartingNumber = 0
$longestChain = 0
[System.Collections.Generic.Dictionary[long, [System.Collections.Generic.LinkedList[long]]]]$LookupTable = [System.Collections.Generic.Dictionary[long, [System.Collections.Generic.LinkedList[long]]]]::new()
$limit = 1000000
for ($i = 1; $i -le $limit; $i++) {
    # if ($i % 10000 -eq 0) {
    #     Write-Progress -Activity "Calculating CollatzSequence" -Status $i -PercentComplete ($i / $limit * 100)
    # }
    $collatzSequence = Get-CollatzSequence -InputObject $i -LookupTable $LookupTable
    $chainCount = ($collatzSequence | Measure-Object).Count
    if ($chainCount -gt $longestChain) {
        $longestChainStartingNumber = $i
        $longestChain = $chainCount
    }
}

$longestChainStartingNumber
