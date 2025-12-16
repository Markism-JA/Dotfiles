-- BUG: smartsplit nav with nvim is not working properly.

local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

local act = wezterm.action

local config = wezterm.config_builder()

bar.apply_to_config(config)
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	direction_keys = {
		move = { "h", "j", "k", "l" },
		resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	},
	modifiers = {
		move = "CTRL",
		resize = "META",
	},
	log_level = "info",
})

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
	local raw_process_name = pane:get_foreground_process_name()

	if not raw_process_name then
		return false
	end

	local process_name = string.gsub(raw_process_name, "(.*[/\\])(.*)", "%2")

	return process_name == "nvim" or process_name == "vim" or process_name == "nvim.exe" or process_name == "vim.exe"
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

	-- --- PANE MANAGEMENT ---
	{ mods = "LEADER", key = "z", action = act.TogglePaneZoomState },
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

bar.apply_to_config(config, {
	modules = {
		tabs = {
			active_tab_fg = 4,
			inactive_tab_fg = 6,
			new_tab_fg = 2,
		},

		zoom = { enabled = true },

		-- Modules to DISABLE for minimalism:
		workspace = { enabled = false },
		leader = { enabled = false },
		pane = { enabled = false },
		username = { enabled = false },
		hostname = { enabled = false },
		spotify = { enabled = false },

		-- Modules to KEEP (Clock and CWD are often essential)
		cwd = { enabled = false },
		clock = {
			enabled = true,
			icon = wezterm.nerdfonts.md_calendar_clock,
			format = "%I:%M", -- Use 24-hour format (or "%I:%M %p" for 12-hour)
			color = 5,
		},
	},
})

return config
