source ~/.config/fish/keubinds.fish
source ~/.config/fish/alias.fish
source ~/.config/fish/functions.fish
fish_default_key_bindings

function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Use starship
    starship init fish | source
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
    alias q 'qs -c ii'

end

# disable fish default greeting
if status is-interactive
    set fish_greeting
end

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"
# alias q 'qs -c ii'
alias l 'ls -la'
alias nvgui='foot -c ~/.config/foot/foot-nvim.ini nvim'
alias nvim-test 'NVIM_APPNAME=custom_nvim nvim'
alias sync='python3 ~/Scripts/bin/Sync-Remote-test.py'
alias onedrive='test -d ~/rclone-mounts/onedrivesti; or mkdir -p ~/rclone-mounts/onedrivesti && rclone mount OneDriveSTI: ~/rclone-mounts/onedrivesti/ --vfs-cache-mode writes --daemon'
alias dotnet-install='~/Scripts/bin/dotnet-install.sh --install-dir ~/dotnet/'

set -Ux ssd /mnt/marky-ssd/
set -Ux share /mnt/shared/

#init
zoxide init fish | source

#tab completion for dotnet tool
complete -f -c dotnet -a "(dotnet complete (commandline -cp))"
