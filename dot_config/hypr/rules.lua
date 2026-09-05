-- ##! Window Rules
-- Push electron message to silent
hl.window_rule({
	match = { class = "^(electron)$", title = "^$" },
	no_initial_focus = true,
	float = true,
	size = "1 1",
	move = "-100 -100",
})

--# Media / Viewers

hl.window_rule({
	match = { class = "^(imv)$" },
	float = true, -- Floats a window
	size = "40% 40%", -- Resizes a floating window
	move = "100%-41% 5%",
	no_initial_focus = true, -- Disables the initial focus to the window
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
	match = {
		initial_class = "jetbrains-toolbox",
		initial_title = "Toolbox",
	},
	float = true,
	size = "386 600",
	move = "1425 40",
})

--# Productivity Apps

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

-- Task Dashboard Pro (switched to class matcher + size + suppress_event)
hl.window_rule({
	match = { class = "^(task-dashboard-pro)$" },
	float = true,
	center = true,
	size = "1250 750",
	workspace = "special:task silent",
	no_initial_focus = true,
	suppress_event = "activate",
})

-- Todoist
hl.window_rule({
	match = { class = "^([Tt]odoist)$" },
	float = true,
	center = true,
	size = "1200 750",
	workspace = "special:todo silent",
	no_initial_focus = true,
	suppress_event = "activate",
})

-- Google Calendar
hl.window_rule({
	match = { class = "^(google-calendar|chrome-calendar\\.google\\.com__-Default)$" },
	float = true,
	center = true,
	size = "1300 950",
	workspace = "special:gcal silent",
	no_initial_focus = true,
	suppress_event = "activate",
})

-- Caprine
hl.window_rule({
	match = { class = "^(Caprine|com\\.sindresorhus\\.Caprine)$" },
	float = true,
	center = true,
	size = "1100 800",
	workspace = "special:cap silent",
	no_initial_focus = true,
	suppress_event = "activate",
})

-- Discord
hl.window_rule({
	match = { class = "^(discord)$" },
	float = true,
	center = true,
	size = "1300 950",
	workspace = "special:dc silent",
	no_initial_focus = true,
	suppress_event = "activate",
})

-- Instagram Web App
hl.window_rule({
	match = { class = "chrome-www\\.instagram\\.com__-Default" },
	float = true,
	center = true,
	workspace = "special:insta silent",
	no_initial_focus = true,
	suppress_event = "activate",
})

--# Workspace 10 (Communication / Email)
hl.window_rule({ match = { class = "^(org.gnome.Calendar)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^([Tt]hunderbird)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(eu.betterbird.Betterbird)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(org.gnome.Geary)" }, workspace = "10" })
hl.window_rule({ match = { class = "^(org.gnome.Evolution)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(org.telegram.desktop)$" }, workspace = "10" })
hl.window_rule({ match = { class = "^(Prospect Mail)$" }, workspace = "10" })

--# Workspace 2 (Browsers)
hl.window_rule({ match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^([Tt]horium-browser)$" }, workspace = "3" })

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

hl.window_rule({ match = { class = "^(org.vinegarhq.Sober)$" }, workspace = "8" })
hl.window_rule({ match = { class = "^(heroic)$" }, workspace = "8" })

--# Special / Android Emulation
hl.window_rule({ match = { class = "(Waydroid)$" }, workspace = "8" })

hl.window_rule({
	match = { class = "(com.jaoushingan.WaydroidHelper)$" },
	workspace = "8",
	float = true,
	size = "515 400",
})

--# FSearch (Main Search HUD)
hl.window_rule({
	match = {
		class = "^(io\\.github\\.cboxdoerfer\\.FSearch)$",
		title = "^(FSearch)$",
	},
	float = true,
	center = true,
	size = "1050 620",
})

--# FSearch (Preferences Dialog)
hl.window_rule({
	match = {
		class = "^(io\\.github\\.cboxdoerfer\\.FSearch)$",
		title = "^(Preferences)$",
	},
	float = true,
	center = true,
})
