hl.on("hyprland.start", function()
	hl.exec_cmd("albert &")
	hl.exec_cmd("kdeconnect-indicator &")
	hl.exec_cmd([[
    sleep 0.7; swww img "$(cat ~/.local/state/quickshell/user/generated/wallpaper/path.txt)" \
    --transition-type fade \
    --transition-fps 120 \
    --transition-duration 1 \
    --transition-step 60
    ]])
	hl.exec_cmd("hyprctl setcursor Adwaita 24")

	hl.exec_cmd("google-calendar-nativefier-dark")
	hl.exec_cmd("flatpak run com.sindresorhus.Caprine")
	hl.exec_cmd("discord")
end)
