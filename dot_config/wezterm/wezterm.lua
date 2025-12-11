local wezterm = require("wezterm")
local act = wezterm.action

-- =========================================================
-- CUSTOM PLUGIN LOADER (Manual Install)
-- =========================================================
local function load_plugin(name)
	-- 1. Define the path to the specific plugin
	--    (Using forward slashes is safer in Lua, even on Windows)
	local path = "C:/Users/windows/.config/wezterm/plugins/" .. name

	-- 2. Check for the standard entry point: /plugin/init.lua
	local location1 = path .. "/plugin/init.lua"
	local f = io.open(location1, "r")
	if f then
		f:close()
		return dofile(location1)
	end

	-- 3. Check for the alternative entry point: /init.lua
	local location2 = path .. "/init.lua"
	f = io.open(location2, "r")
	if f then
		f:close()
		return dofile(location2)
	end

	-- 4. If not found, print a clear error to the debug window
	wezterm.log_error("CRITICAL: Could not find init.lua for plugin '" .. name .. "' at path: " .. path)
	return { apply_to_config = function() end } -- Return dummy to prevent crash
end

-- Load the plugins manually
local bar = load_plugin("bar.wezterm")
local session_manager = load_plugin("wezterm-session-manager")

-- Initialize configuration
local config = wezterm.config_builder()

-- =========================================================
-- 1. GENERAL SETTINGS
-- =========================================================
config.default_prog = { "pwsh" }
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.show_tab_index_in_tab_bar = false

-- Visuals
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 13
config.color_scheme = "Material Dark"
config.window_background_opacity = 0.70
config.win32_system_backdrop = "Mica"
config.front_end = "WebGpu"

-- Server / Persistence (Unix Domain)
config.unix_domains = {
	{
		name = "unix",
	},
}

-- =========================================================
-- 2. SMART SPLITS HELPERS (Neovim Integration)
-- =========================================================
local function is_vim(pane)
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(window, pane)
			if is_vim(pane) then
				window:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					window:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					window:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

-- =========================================================
-- 3. KEYBINDINGS
-- =========================================================
config.keys = {
	-- --- SMART SPLITS (CTRL + h/j/k/l) ---
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),

	-- --- SESSION MANAGER ---
	{
		mods = "LEADER",
		key = "S",
		action = wezterm.action_callback(function(win, pane)
			session_manager.save_state(win, pane)
		end),
	},
	{
		mods = "LEADER",
		key = "L",
		action = wezterm.action_callback(function(win, pane)
			session_manager.load_state(win, pane)
		end),
	},

	-- --- WORKSPACE / SERVER ---
	{ mods = "LEADER", key = "d", action = act.DetachDomain({ DomainName = "unix" }) },
	{ mods = "LEADER", key = "s", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES|DOMAINS" }) },

	-- --- SPLITS (Tmux Style) ---
	{ mods = "LEADER|SHIFT", key = "|", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "-", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "LEADER", key = "x", action = act.CloseCurrentPane({ confirm = true }) },

	-- --- TABS ---
	{ mods = "LEADER", key = "c", action = act.SpawnTab("CurrentPaneDomain") },
	{
		mods = "LEADER",
		key = ",",
		action = act.PromptInputLine({
			description = "Enter new tab name:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Navigate Tabs
	{ mods = "LEADER|CTRL", key = "h", action = act.ActivateTabRelative(-1) },
	{ mods = "LEADER|CTRL", key = "l", action = act.ActivateTabRelative(1) },

	-- Base 1 Indexing
	{ mods = "LEADER", key = "1", action = act.ActivateTab(0) },
	{ mods = "LEADER", key = "2", action = act.ActivateTab(1) },
	{ mods = "LEADER", key = "3", action = act.ActivateTab(2) },
	{ mods = "LEADER", key = "4", action = act.ActivateTab(3) },
	{ mods = "LEADER", key = "5", action = act.ActivateTab(4) },
	{ mods = "LEADER", key = "6", action = act.ActivateTab(5) },
	{ mods = "LEADER", key = "7", action = act.ActivateTab(6) },
	{ mods = "LEADER", key = "8", action = act.ActivateTab(7) },
	{ mods = "LEADER", key = "9", action = act.ActivateTab(8) },

	-- --- COPY MODE ---
	{ mods = "LEADER", key = "[", action = act.ActivateCopyMode },

	-- --- MISC ---
	{ mods = "LEADER|SHIFT", key = "R", action = act.ReloadConfiguration },
}

-- =========================================================
-- 4. KEY TABLES (Copy Mode)
-- =========================================================
config.key_tables = {
	copy_mode = {
		-- Selection Modes
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },

		-- Movement
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },

		-- Scrolling
		{ key = "u", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "d", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
		{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },

		-- Copy & Exit
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				act.CopyTo("ClipboardAndPrimarySelection"),
				act.CopyMode("Close"),
			}),
		},
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
	},
}

-- =========================================================
-- 5. PLUGIN VISUAL CONFIGURATION
-- =========================================================
-- This replaces your manual status bar code
bar.apply_to_config(config, {
	position = "bottom",
	max_width = 32,
	dividers = "slant_right",
	indicator_style = "cool",
	clock_format = "%H:%M",
})

return config
