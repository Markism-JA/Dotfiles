# Function bindings

Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { fzf-search-history }
Set-PSReadLineKeyHandler -Key alt+l -ScriptBlock { fzf-search-git-log }
Set-PSReadLineKeyHandler -Key alt+s -ScriptBlock { fzf-search-git-status }
