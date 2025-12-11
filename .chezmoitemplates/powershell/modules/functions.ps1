function Search-History
{
    $historyPath = (Get-PSReadLineOption).HistorySavePath

    if (-not $historyPath -or -not (Test-Path $historyPath))
    { return 
    }

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    $currentQuery = $line

    # 2. Read and Deduplicate
    $rawHistory = @(Get-Content $historyPath -ErrorAction SilentlyContinue)
    [System.Collections.ArrayList]$uniqueHistory = $rawHistory[($rawHistory.Count - 1)..0] | Select-Object -Unique

    $totalCount = $uniqueHistory.Count
    if ($totalCount -eq 0)
    { return 
    }

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
    if ($selectedLines)
    {
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

function Search-GitLog
{
    # Check if in a git repo
    if (-not (git rev-parse --git-dir 2 Out-File $null))
    { 
        Write-Error "Not in a git repository."
        return 
    }

    # 1. Get Log Data
    $format = '%C(bold blue)%h%C(reset) - %C(cyan)%ad%C(reset) %C(yellow)%d%C(reset) %s [%an]'
    $logs = @(git log --no-show-signature --color=always --format=format:$format --date=short)
    
    if ($logs.Count -eq 0)
    { return 
    }

    # 2. Define fzf arguments (Blank Query)
    $fzfArgs = @(
        "--ansi",
        "--multi",
        "--prompt=Git Log> ",
        "--border=rounded",
        "--layout=reverse",
        "--preview=git show --color=always {1}",
        "--preview-window=right:60%"
    )

    # 3. Run FZF
    $selectedLines = $logs | fzf $fzfArgs

    if ($selectedLines)
    {
        $hashes = $selectedLines -split "`n" | ForEach-Object {
            # Extract hash safely
            if ($_ -match '\b([a-f0-9]{7,})\b')
            { 
                $matches[1] 
            }
        }

        $textToInsert = $hashes -join ' '

        # 4. Insert at Cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($textToInsert)
    }
}

function Search-GitStatus
{
    if (-not (git rev-parse --git-dir 2 Out-File $null))
    { 
        Write-Error "Not in a git repository."
        return 
    }

    # 1. Get Status Data
    $status = @(git -c color.status=always status --short)
    if ($status.Count -eq 0)
    { return 
    }

    # 2. Define fzf arguments (Blank Query)
    $fzfArgs = @(
        "--ansi",
        "--multi",
        "--prompt=Git Status> ",
        "--border=rounded",
        "--layout=reverse",
        "--nth=2..", 
        "--preview=git diff --color=always {2}",
        "--preview-window=right:60%"
    )

    # 3. Run FZF
    $selectedLines = $status | fzf $fzfArgs

    if ($selectedLines)
    {
        $paths = $selectedLines -split "`n" | ForEach-Object {
            if ($_ -match '^R\s+.* -> (.+)$')
            { 
                $matches[1] 
            } else
            { 
                $_.Substring(3) 
            }
        }

        $textToInsert = $paths -join ' '

        # 4. Insert at Cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($textToInsert)
    }
}
