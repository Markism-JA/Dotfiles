-- ##! Window Rules

--# Media / Viewers
--
hl.config({
	windowrules = {
		"float, class:^(gpu-screen-recorder-ui)$",
		"center, class:^(gpu-screen-recorder-ui)$",
		"suppressevent fullscreen, class:^(gpu-screen-recorder-ui)$",
		"size 100% 100%, class:^(gpu-screen-recorder-ui)$",
		"monitor 0, class:^(gpu-screen-recorder-ui)$",
	},
})

hl.window_rule({
	match = { class = "^(imv)$" },
	float = true, -- Floats a window [cite: 420]
	size = "40% 40%", -- Resizes a floating window [cite: 420]
	move = "100%-41% 5%",
	no_initial_focus = true, -- Disables the initial focus to the window [cite: 425]
})

hl.window_rule({
	match = { class = "^(org.pwmt.zathura)$" },
	no_initial_focus = true,
})

--# System Tools
hl.window_rule({
	match = { class = "^(org\\.gnome\\.SystemMonitor|gnome-system-monitor)$" },
	float = true,
})

--# System Tools
hl.window_rule({
	match = { class = "^(org.kde.plasma-systemmonitor)$" },
	float = true,
	center = true,
	size = "930 650",
})

hl.window_rule({
	match = { class = "jetbrains-toolbox" },
	float = true,
})

--# Productivity Apps
hl.window_rule({
	match = { title = "^(Task Dashboard Pro)$" },
	float = true,
	center = true, -- Centers floating window on the monitor [cite: 420]
})

hl.window_rule({
	match = { title = "^(ScholarFlow)$" },
	float = true,
	center = true,
})

-- Note: Multiple match properties are combined into the same match table
hl.window_rule({
	match = { class = "([Tt]hunar)", title = "(File Operation Progress)" },
	center = true,
})

--# Overlays & Popups
hl.window_rule({ match = { title = "^(ROG Control)$" }, center = true })
hl.window_rule({ match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, move = "72% 7%" })

--# Special Workspaces (Calendar & Messengers)
hl.window_rule({
	match = { class = "googlecalendardark-nativefier-e22938" },
	float = true,
	center = true,
	workspace = "special:gcal silent", -- Sets workspace, supports silent suffix [cite: 420]
	size = "1300 950",
})

hl.window_rule({
	match = { class = "^(Caprine)$" },
	float = true,
	center = true,
	workspace = "special:cap silent",
})

hl.window_rule({
	match = { class = "^(com.gabm.satty)$" },
	float = true,
	center = true,
})

hl.window_rule({
	match = { class = "^(discord)$" },
	float = true,
	center = true,
	workspace = "special:dc silent",
})

--# Electron / Discord
hl.window_rule({
	match = { class = "^(electron)$", title = "^$" },
	workspace = "special:garbage silent",
})

hl.window_rule({
	match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" },
})

--# Workspace 10 (Communication / Email)
hl.window_rule({ match = { class = "^(org.gnome.Calendar)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^([Tt]hunderbird)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(eu.betterbird.Betterbird)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(org.gnome.Geary)" }, workspace = "10" })
hl.window_rule({ match = { class = "^(org.gnome.Evolution)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(Prospect Mail)$" }, workspace = "10" })

hl.window_rule({
	match = { class = "^(messenger-nativefier-a7a11f)$" },
	workspace = "10",
	opacity = "0.90 0.90",
})

--# Workspace 2 (Browsers)
hl.window_rule({ match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^([Tt]horium-browser)$" }, workspace = "2" })

--# Workspace 3 (Files & Terminals)
hl.window_rule({
	match = { class = "^(org.gnome.Nautilus)$" },
	opacity = "0.90 0.90",
})
hl.window_rule({ match = { class = "^([Tt]hunar)$" }, workspace = "3" })
hl.window_rule({ match = { class = "^(foot)$" }, workspace = "3" })

--# Workspace 4 & 6 (Office / Design)
hl.window_rule({ match = { class = "^(org.gnome.Evince)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(canva-nativefier-7d52bb)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(draw.io)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(org.inkscape.Inkscape)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(libreoffice-writer)$" }, workspace = "6" })

--# Workspace 7 (Entertainment)
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, workspace = "7" })
hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux)$" }, workspace = "7" })
hl.window_rule({ match = { class = "^(org.gnome.Lollypop)$" }, workspace = "7" })
hl.window_rule({ match = { class = "^(vlc)" }, workspace = "7" })
hl.window_rule({ match = { class = "^(com.github.th_ch.youtube_music)$" }, workspace = "7" })

hl.window_rule({
	match = { class = "^([Ss]potify)$" },
	workspace = "7",
})

--# Workspace 8 (Games / Launchers)
hl.window_rule({ match = { class = "^([Ss]team)$" }, workspace = "8" })
-- hl.window_rule({ match = { title = "^(SKlauncher 3.2.10 build.473)$" }, workspace = "8" })
-- hl.window_rule({ match = { class = "^Minecraft.*" }, workspace = "8" })
-- hl.window_rule({ match = { title = "^SKlauncher.*" }, workspace = "8" })
hl.window_rule({ match = { class = "^(org.vinegarhq.Sober)$" }, workspace = "8" })
hl.window_rule({ match = { class = "^(heroic)$" }, workspace = "8" })

--# Workspace 9 (Virtual Machines)
hl.window_rule({ match = { class = "^(virt-manager)$" }, workspace = "9" })

--# Special / Android Emulation
hl.window_rule({ match = { class = "(Waydroid)$" }, workspace = "8" })

hl.window_rule({
	match = { class = "(com.jaoushingan.WaydroidHelper)$" },
	workspace = "8",
	float = true,
	size = "515 400",
})
