if ($IsWindows) {
    $extraConfig = Join-Path $HOME "Documents\PowerShell\modules"
} else {
    $extraConfig = Join-Path $HOME ".config/powershell/modules"
}

# Load all .ps1 files
if (Test-Path $extraConfig) {
    Get-ChildItem $extraConfig -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}
