hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("hyprctl setcursor Adwaita 24")
	hl.exec_cmd("kdeconnect-indicator")

	hl.exec_cmd("google-calendar-nativefier-dark")
	hl.exec_cmd("flatpak run com.sindresorhus.Caprine")
	hl.exec_cmd(
		"/home/marky/Application/AppImage/todoist.appimage --enable-features=UseOzonePlatform --ozone-platform=wayland"
	)
	hl.exec_cmd(
		"env XDG_CURRENT_DESKTOP=Unity ELECTRON_USE_UBUNTU_INDICATOR=1 discord --enable-features=UseOzonePlatform,AppIndicator3 --ozone-platform=wayland --enable-gpu-rasterization"
	)
end)
