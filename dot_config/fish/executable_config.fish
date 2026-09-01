source ~/.config/fish/appearance.fish
source ~/.config/fish/keybinds.fish
source ~/.config/fish/alias.fish
source ~/.config/fish/functions.fish

#settings
fish_vi_key_bindings

#init, only works if its in config.fish
zoxide init fish | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

function fish_title
    # If a command is running, show it; otherwise show current directory
    set -l cmd (status current-command)
    if test -n "$cmd" -a "$cmd" != fish
        echo "$cmd: "(prompt_pwd)
    else
        echo (prompt_pwd)
    end
end
