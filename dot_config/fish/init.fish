#tab completion for dotnet tool
complete -f -c dotnet -a "(dotnet complete (commandline -cp))"

# init zoxide
if type -q zoxide
    source (zoxide init fish)
end
