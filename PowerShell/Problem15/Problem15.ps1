class GridPoint {
    [string]$Name
    [string]$UUID
    [System.Collections.Generic.LinkedList[GridPoint]]$Connections = [System.Collections.Generic.LinkedList[GridPoint]]::new()

    GridPoint([string]$Name, [GridPoint[]]$Connections) {
        $this.UUID = [System.Guid]::NewGuid()
        $this.Name = $Name
        foreach ($connection in $Connections) {
            $this.Connections.Add($connection)
        }
    }

    [Void] AddConnection([GridPoint]$Connection) {
        $this.Connections.Add($Connection)
    }

    [int] GetHashCode() {
        return $this.UUID.GetHashCode()
    }

    [bool] Equals([System.Object] $obj) {
        if ($null -ne [GridPoint]$obj) {
            return $this.UUID.Equals(([GridPoint]$obj).UUID)
        }
        else {
            return $false
        }
    }

    [String] ToString() {
        [System.Text.StringBuilder]$sb = [System.Text.StringBuilder]::new()
        $sb.Append("$($this.Name);")
        foreach ($connection in $this.Connections) {
            $sb.Append("$($this.Name) -> $($this.connection.Name);") | Out-Null
        }

        return $sb.ToString()
    }
}

$gp = [GridPoint]::new("Ace", $null)
$gp.ToString()
