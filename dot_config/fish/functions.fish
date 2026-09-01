function chezmtree
    tree -L 2 (chezmoi source-path)
end

function task --description "Manage and prioritize academic tasks"
    ~/Scripts/bin/task-manager/check_tasks.py $argv
end

function hl
    if test -z "$WAYLAND_DISPLAY"
        set -x XDG_SESSION_TYPE wayland
        set -x XDG_CURRENT_DESKTOP Hyprland
        set -x WLR_NO_HARDWARE_CURSORS 1
        exec dbus-run-session Hyprland
    else
        echo "A Wayland session is already active."
    end
end
