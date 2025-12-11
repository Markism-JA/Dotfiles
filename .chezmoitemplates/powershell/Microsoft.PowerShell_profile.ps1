# env
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"

if ($IsWindows)
{
    $extraConfig = Join-Path $HOME "Documents\PowerShell\modules"
} else
{
    $extraConfig = Join-Path $HOME ".config/powershell/modules"
}

# Load all .ps1 files
if (Test-Path $extraConfig)
{
    Get-ChildItem $extraConfig -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}

Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Invoke-Expression (& { (zoxide init powershell | Out-String) })
