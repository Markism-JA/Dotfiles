local HOME = os.getenv("HOME")

-- Ozone / Wayland Hints
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Qt Theming & Wayland backend
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XDG_MENU_PREFIX", "plasma-")

local function is_file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	else
		return false
	end
end

if is_file_exists(HOME .. "/.config/hypr/execs.lua") then
	require("execs")
end

if is_file_exists(HOME .. "/.config/hypr/rules.lua") then
	require("general")
end

if is_file_exists(HOME .. "/.config/hypr/rules.lua") then
	require("rules")
end

if is_file_exists(HOME .. "/.config/hypr/keybinds.lua") then
	require("keybinds")
end

if is_file_exists(HOME .. "/.config/hypr/monitors.lua") then
	require("monitors")
end

if is_file_exists(HOME .. "/.config/hypr/workspaces.lua") then
	require("workspaces")
end
