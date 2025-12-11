Set-PSReadLineKeyHandler -Key Escape -Function ViEditVisually

# Function bindings

Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { fzf-search-history }
Set-PSReadLineKeyHandler -Key Alt+g -ScriptBlock { fzf-search-git-log }
Set-PSReadLineKeyHandler -Key Alt+s -ScriptBlock { fzf-search-git-status }
