Set-PSReadLineKeyHandler -Key Escape -Function ViEditVisually

# Function bindings

Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { Search-History }
Set-PSReadLineKeyHandler -Key Alt+g -ScriptBlock { Search-GitLog }
Set-PSReadLineKeyHandler -Key Alt+s -ScriptBlock { Search-GitStatus }
