hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("hyprctl setcursor Adwaita 24")
	hl.exec_cmd("kdeconnect-indicator &")

	hl.exec_cmd("google-calendar-nativefier-dark")
	hl.exec_cmd("flatpak run com.sindresorhus.Caprine")
	hl.exec_cmd("discord")
end)
