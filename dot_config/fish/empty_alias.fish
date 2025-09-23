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
