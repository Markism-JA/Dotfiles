source ~/.config/fish/appearance.fish
source ~/.config/fish/keybinds.fish
source ~/.config/fish/alias.fish
source ~/.config/fish/functions.fish

#settings
fish_vi_key_bindings

#init, only works if its in config.fish
zoxide init fish | source

if test -z "$DISPLAY" -a (tty) = /dev/tty1
    set -x XDG_SESSION_TYPE wayland
    set -x XDG_CURRENT_DESKTOP Hyprland
    set -x WLR_NO_HARDWARE_CURSORS 1
    exec dbus-run-session Hyprland
end
