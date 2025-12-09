function fzf-search-history {
    $historyPath = (Get-PSReadLineOption).HistorySavePath

    if (-not $historyPath -or -not (Test-Path $historyPath)) { return }

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    $currentQuery = $line

    # 2. Read and Deduplicate
    $rawHistory = @(Get-Content $historyPath -ErrorAction SilentlyContinue)
    [System.Collections.ArrayList]$uniqueHistory = $rawHistory[($rawHistory.Count - 1)..0] | Select-Object -Unique

    $totalCount = $uniqueHistory.Count
    if ($totalCount -eq 0) { return }

    # 3. Format lines
    $historyForFzf = 0..($totalCount - 1) | ForEach-Object {
        $index = $_
        $displayNumber = $totalCount - $index
        "{0:D5} │ {1}" -f $displayNumber, $uniqueHistory[$index]
    }

    # 4. Define fzf arguments
    $fzfArgs = @(
        "--ansi",
        "--multi",
        "--prompt=History> ",
        "--border=rounded",
        "--layout=reverse",
        "--preview-window=hidden",
        "--query=$currentQuery"
    )

    $selectedLines = $historyForFzf | fzf $fzfArgs
    if ($selectedLines) {
        $commands = $selectedLines -split "`n" | ForEach-Object {
            ($_ -split ' │ ', 2)[1]
        }

        $commandToInsert = $commands -join '; '
        # Sanitize text
        $commandToInsert = $commandToInsert -replace "[\r\n]+", ""
        $commandToInsert = $commandToInsert.Trim()

        # Clean Replace
        [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($commandToInsert)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(0)
    }

    # 6. Force Cursor Shape Reset (Linux/Terminal safe method)
    Write-Host -NoNewline "$([char]27)[6 q"
}
