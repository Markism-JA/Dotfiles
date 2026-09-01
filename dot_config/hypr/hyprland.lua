local HOME = os.getenv("HOME")

-- Ozone / Wayland Hints (Electron & Chromium apps)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Force GTK / Electron to use KDE/xdg desktop portals for file pickers
hl.env("GTK_USE_PORTAL", "1")

-- Qt Theming & Wayland backend (KDE-focused)
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("XDG_MENU_PREFIX", "plasma-")

-- Hyprland Plugin Manager Permissions
hl.permission({
	binary = "/usr/(bin|local/bin)/hyprpm",
	type = "plugin",
	mode = "allow",
})

local function is_file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

-- Modular Imports
local modules = {
	{ path = "/.config/hypr/execs.lua", name = "execs" },
	{ path = "/.config/hypr/general.lua", name = "general" },
	{ path = "/.config/hypr/rules.lua", name = "rules" },
	{ path = "/.config/hypr/keybinds.lua", name = "keybinds" },
	{ path = "/.config/hypr/gestures.lua", name = "gestures" },
	{ path = "/.config/hypr/monitors.lua", name = "monitors" },
	{ path = "/.config/hypr/workspaces.lua", name = "workspaces" },
	{ path = "/.config/hypr/plugins/gloview.lua", name = "plugins/gloview" },
}

for _, mod in ipairs(modules) do
	if is_file_exists(HOME .. mod.path) then
		require(mod.name)
	end
end
