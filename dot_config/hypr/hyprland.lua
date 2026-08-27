local HOME = os.getenv("HOME")

-- Ozone / Wayland Hints
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Qt Theming & Wayland backend
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XDG_MENU_PREFIX", "plasma-")

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
	{ path = "/.config/hypr/monitors.lua", name = "monitors" },
	{ path = "/.config/hypr/workspaces.lua", name = "workspaces" },
}

for _, mod in ipairs(modules) do
	if is_file_exists(HOME .. mod.path) then
		require(mod.name)
	end
end
