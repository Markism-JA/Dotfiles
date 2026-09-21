# Cache the fzf path once at module/profile load time (Arch Linux & Windows compatible)
function Get-FzfPath {
    if (-not $script:FzfPath) {$cmd = Get-Command fzf -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($cmd) {
            $script:FzfPath =$cmd.Source
        }
    }
    return $script:FzfPath
}

$script:FzfPath = Get-FzfPath

<#
.SYNOPSIS
    Parses and deduplicates PSReadLine persistent history newest-first.
#>
function Get-UniqueHistory {
    [CmdletBinding()]
    param(
        [string]$Path = (Get-PSReadLineOption).HistorySavePath
    )

    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    # 1. Parse multiline entries based on PSReadLine backtick continuation
    $rawEntries = [System.Collections.Generic.List[string]]::new()
    $buffer = [System.Text.StringBuilder]::new()

    foreach ($line in [System.IO.File]::ReadLines($Path)) {
        if ($line.EndsWith('`')) {
            # Strip trailing backtick and accumulate
            [void]$buffer.AppendLine($line.Substring(0, $line.Length - 1))
        } else {
            [void]$buffer.Append($line)
            $rawEntries.Add($buffer.ToString())
            [void]$buffer.Clear()
        }
    }

    if ($buffer.Length -gt 0) {
        $rawEntries.Add($buffer.ToString())
    }

    # 2. Deduplicate in reverse order (newest-first) using an OrdinalIgnoreCase set
    $seen = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase
    )
    $unique = [System.Collections.Generic.List[string]]::new()

    for ($i = $rawEntries.Count - 1; $i -ge 0; $i--) {
        # Normalize boundary whitespace only; internal newlines and indentation remain intact
        $entry = $rawEntries[$i].Trim()
        if (-not [string]::IsNullOrEmpty($entry) -and $seen.Add($entry)) {
            $unique.Add($entry)
        }
    }

    return $unique
}

<#
.SYNOPSIS
    Interactive history search for PSReadLine powered by fzf.
#>
function Search-History {
    [CmdletBinding()]
    param()

    $fzf = Get-FzfPath
    if (-not $fzf) { return }

    $history = Get-UniqueHistory
    if ($history.Count -eq 0) { return }

    # 1. Capture current buffer state
    $currentLine = $null
    $cursorPos = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$currentLine, [ref]$cursorPos)

    # 2. Build indexed payload: "<index>\t<display_rank> │ <display_command>"
    $fzfInput = for ($i = 0; $i -lt $history.Count; $i++) {
        $rank = "{0:D5}" -f ($i + 1)
        $displayCmd = ($history[$i] -replace '\r?\n', ' ↵ ')
        "{0}`t{1} │ {2}" -f $i, $rank,$displayCmd
    }

    # 3. Configure fzf with history-oriented heuristics
    $fzfArgs = @(
        "--delimiter=`t",
        "--with-nth=2..",
        "--scheme=history",
        "--prompt=History> ",
        "--border=rounded",
        "--layout=reverse",
        "--height=60%",
        "--preview-window=hidden"
    )

    if (-not [string]::IsNullOrWhiteSpace($currentLine)) {
        $fzfArgs += "--query=$currentLine"
    }

    # 4. Invoke native fzf with isolated array index
    $selected = $fzfInput | & $fzf $fzfArgs

    if ($selected) {
        # Extract the hidden index from field 1
        $rawIndex = ($selected -split "`t", 2)[0].Trim()
        $commandToInsert = $history[[int]$rawIndex]

        # 5. Atomically replace buffer using the valid static method
        $lengthToReplace = if ($currentLine) {$currentLine.Length } else { 0 }
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $lengthToReplace,$commandToInsert)
    }
}
