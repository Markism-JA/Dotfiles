Set-PSReadLineKeyHandler -Key Escape -Function ViEditVisually

# Function bindings

Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { fzf-search-history }
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,l' -ScriptBlock { fzf-search-git-log }
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,s' -ScriptBlock { fzf-search-git-status }
