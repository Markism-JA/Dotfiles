local function workspace_in_group(i)
	return tostring(i)
end

local function move_to_corner(corner, margin)
	margin = margin or 24
	local win = hl.get_active_window()
	if not win or not win.floating then
		return
	end

	local mon = hl.get_active_monitor()
	if not mon then
		return
	end

	local mon_x = mon.x or 0
	local mon_y = mon.y or 0
	local mon_w = mon.width or 1920
	local mon_h = mon.height or 1080

	local win_w = win.size and win.size.x or 800
	local win_h = win.size and win.size.y or 500

	local target_x, target_y

	if corner == "top_left" then
		target_x = mon_x + margin
		target_y = mon_y + margin
	elseif corner == "top_right" then
		target_x = mon_x + mon_w - win_w - margin
		target_y = mon_y + margin
	elseif corner == "bottom_left" then
		target_x = mon_x + margin
		target_y = mon_y + mon_h - win_h - margin
	elseif corner == "bottom_right" then
		target_x = mon_x + mon_w - win_w - margin
		target_y = mon_y + mon_h - win_h - margin
	end

	hl.dispatch(hl.dsp.window.move({
		x = tostring(math.floor(target_x)),
		y = tostring(math.floor(target_y)),
		relative = false,
	}))
end

local function zoomfunction(value)
	local zoomvalue = hl.get_config("cursor:zoom_factor") or 1.0
	local new_zoom = math.max(1.0, math.min(3.0, zoomvalue + value))
	hl.config({ cursor = { zoom_factor = new_zoom } })
end

-- =============================================================================
-- Configuration & Environment Variables
-- =============================================================================

local settings = require("settings")
local mod = settings.mainMod or "SUPER"
local noctalia_ipc = "noctalia msg "
local hyprScripts = "$HOME/.config/hypr/scripts"
local terminal = settings.terminal or "kitty"
local fileManager = settings.fileManager or "nautilus"
local browser = settings.browser or "microsoft-edge-stable"
local officeSoftware = "libreoffice"

-- =============================================================================
-- 1. Applications & Launchers
-- =============================================================================

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "Launch Tmux Terminal" })
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty"), { description = "Launch Terminal" })
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(terminal), { description = "Launch Fallback Terminal" })
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "Launch File Manager" })
hl.bind(mod .. " + W", hl.dsp.exec_cmd(browser), { description = "Launch Web Browser" })
hl.bind(mod .. " + Z", hl.dsp.exec_cmd("zen-browser"), { description = "Launch Zen Browser" })
hl.bind(mod .. " + X", hl.dsp.exec_cmd("nvim"), { description = "Launch Neovim Editor" })
hl.bind(
	"CTRL + " .. mod .. " + SHIFT + ALT + W",
	hl.dsp.exec_cmd(officeSoftware),
	{ description = "Launch Office Suite" }
)
hl.bind(mod .. " + I", hl.dsp.exec_cmd(noctalia_ipc .. "settings-toggle"), { description = "Launch Noctalia Settings" })

-- =============================================================================
-- 2. Shell & Desktop Controls
-- =============================================================================

hl.bind(
	"ALT + Space",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle launcher"),
	{ description = "Toggle Application Launcher" }
)
hl.bind(
	mod .. " + A",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle control-center"),
	{ description = "Toggle Control Center" }
)
hl.bind(mod .. " + B", hl.dsp.exec_cmd(noctalia_ipc .. "bar-toggle"), { description = "Toggle Noctalia Bar" })
hl.bind(
	mod .. " + V",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle clipboard"),
	{ description = "Toggle Clipboard History" }
)
hl.bind(
	mod .. " + SHIFT + W",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle wallpaper"),
	{ description = "Toggle Wallpaper Selector" }
)
hl.bind(
	"CTRL + " .. mod .. " + SHIFT + D",
	hl.dsp.exec_cmd(noctalia_ipc .. "theme-mode-toggle"),
	{ description = "Toggle Light / Dark Theme" }
)
hl.bind(
	"CTRL + ALT + Delete",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle session"),
	{ description = "Toggle Session / Power Menu" }
)
hl.bind(
	mod .. " + K",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle kenn/keybind-cheatsheet:cheatsheet"),
	{ description = "Toggle Keybind Cheatsheet" }
)

-- =============================================================================
-- 3. Window Management & Placement
-- =============================================================================

-- Mouse Manipulation
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move Window with Mouse" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize Window with Mouse" })

-- State Toggles
hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Close Active Window" })
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Force Zap Window" })
hl.bind(mod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Float / Tile" })
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Window Float" })
hl.bind(
	mod .. " + D",
	hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
	{ description = "Toggle Maximize" }
)
hl.bind(
	mod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Toggle Fullscreen" }
)

-- Pin & Floating Geometry
hl.bind(mod .. " + P", function()
	local win = hl.get_active_window()
	if not win then
		return
	end

	if win.pinned then
		hl.dispatch(hl.dsp.window.pin({ action = "disable" }))
		hl.dispatch(hl.dsp.window.float({ action = "disable" }))
	else
		hl.dispatch(hl.dsp.window.float({ action = "enable" }))
		hl.dispatch(hl.dsp.window.resize({ x = "800", y = "500", relative = false }))
		hl.dispatch(hl.dsp.window.center())
		hl.dispatch(hl.dsp.window.pin({ action = "enable" }))
	end
end, { description = "Toggle PiP Floating Pin" })

local SIZES = {
	{ x = 700, y = 450 },
	{ x = 1100, y = 700 },
	{ x = 1500, y = 920 },
}

hl.bind(mod .. " + R", function()
	local win = hl.get_active_window()
	if not win or not win.floating then
		return
	end

	local cur_w = win.size and win.size.x or 0
	local next_size = SIZES[1]

	for _, size in ipairs(SIZES) do
		if cur_w < size.x - 30 then
			next_size = size
			break
		end
	end

	hl.dispatch(hl.dsp.window.resize({ x = tostring(next_size.x), y = tostring(next_size.y), relative = false }))
	hl.dispatch(hl.dsp.window.center())
end, { description = "Cycle Floating Window Size" })

hl.bind(mod .. " + C", function()
	hl.dispatch(hl.dsp.window.center())
end, { description = "Center Floating Window" })

-- Corner Snapping
hl.bind(mod .. " + ALT + H", function()
	move_to_corner("top_left", 24)
end, { description = "Align Window Top-Left" })
hl.bind(mod .. " + ALT + L", function()
	move_to_corner("top_right", 24)
end, { description = "Align Window Top-Right" })
hl.bind(mod .. " + ALT + J", function()
	move_to_corner("bottom_left", 24)
end, { description = "Align Window Bottom-Left" })
hl.bind(mod .. " + ALT + K", function()
	move_to_corner("bottom_right", 24)
end, { description = "Align Window Bottom-Right" })

-- Split Scaling
hl.bind(
	mod .. " + Semicolon",
	hl.dsp.layout("splitratio -0.1"),
	{ repeating = true, description = "Decrease Split Ratio" }
)
hl.bind(
	mod .. " + Apostrophe",
	hl.dsp.layout("splitratio +0.1"),
	{ repeating = true, description = "Increase Split Ratio" }
)

-- =============================================================================
-- 4. Focus & Navigation
-- =============================================================================

-- Directional Focus & Window Moving
local dirs = { Left = "l", Right = "r", Up = "u", Down = "d", H = "l", L = "r", K = "u", J = "d" }
for key, dir in pairs(dirs) do
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }), { description = "Focus Window " .. key })
	hl.bind(
		mod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ direction = dir }),
		{ description = "Move Window " .. key }
	)
end

-- Workspace Local Cycling
hl.bind(
	"ALT + Tab",
	hl.dsp.window.cycle_next({ tiled = false, floating = false }),
	{ description = "Cycle Next Window" }
)
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }), { description = "Cycle Previous Window" })

-- Multi-Monitor Focus
hl.bind(mod .. " + Period", hl.dsp.focus({ monitor = "+1" }), { description = "Focus Next Monitor" })
hl.bind(mod .. " + Comma", hl.dsp.focus({ monitor = "-1" }), { description = "Focus Previous Monitor" })

-- =============================================================================
-- 5. Workspaces & Scratchpads
-- =============================================================================

-- Numeric & Numpad Workspaces (1 - 10)
for i = 1, 10 do
	local bind_key = i % 10
	hl.bind(mod .. " + " .. bind_key, function()
		hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
	end, { description = "Focus Workspace " .. i })

	hl.bind(mod .. " + ALT + " .. bind_key, function()
		hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = false }))
	end, { description = "Move Window to Workspace " .. i })

	local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
	hl.bind(mod .. " + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
	end, { description = "Focus Workspace (Numpad " .. i .. ")" })

	hl.bind(mod .. " + ALT + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = false }))
	end, { description = "Move Window to Workspace (Numpad " .. i .. ")" })
end

-- Workspace Traversal
hl.bind(
	"CTRL + " .. mod .. " + Left",
	hl.dsp.focus({ workspace = "r-1" }),
	{ description = "Focus Relative Workspace Left" }
)
hl.bind(
	"CTRL + " .. mod .. " + Right",
	hl.dsp.focus({ workspace = "r+1" }),
	{ description = "Focus Relative Workspace Right" }
)
hl.bind(mod .. " + Page_Down", hl.dsp.focus({ workspace = "r+1" }), { description = "Focus Next Workspace" })
hl.bind(mod .. " + Page_Up", hl.dsp.focus({ workspace = "r-1" }), { description = "Focus Previous Workspace" })
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }), { description = "Scroll Workspace Left" })
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }), { description = "Scroll Workspace Right" })

-- General Scratchpad
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("special"), { description = "Toggle General Scratchpad" })
hl.bind(
	mod .. " + CTRL + S",
	hl.dsp.window.move({ workspace = "special:special", follow = false }),
	{ description = "Send Window to Scratchpad" }
)

-- Specialized App Scratchpads
hl.bind(
	"CTRL + " .. mod .. " + C",
	hl.dsp.workspace.toggle_special("gcal"),
	{ description = "Toggle Google Calendar Scratchpad" }
)
hl.bind(
	"CTRL + " .. mod .. " + M",
	hl.dsp.workspace.toggle_special("cap"),
	{ description = "Toggle Caprine Messenger Scratchpad" }
)
hl.bind(
	"CTRL + " .. mod .. " + I",
	hl.dsp.workspace.toggle_special("insta"),
	{ description = "Toggle Instagram Scratchpad" }
)
hl.bind(
	"CTRL + " .. mod .. " + D",
	hl.dsp.workspace.toggle_special("dc"),
	{ description = "Toggle Discord Scratchpad" }
)
hl.bind(
	"CTRL + " .. mod .. " + G",
	hl.dsp.workspace.toggle_special("todo"),
	{ description = "Toggle Todoist Scratchpad" }
)
hl.bind(
	"CTRL + " .. mod .. " + T",
	hl.dsp.workspace.toggle_special("task"),
	{ description = "Toggle Task Dashboard Scratchpad" }
)

-- =============================================================================
-- 6. Workspace Layouts
-- =============================================================================

-- hl.bind(mod .. " + ALT + D", hl.dsp.layout("dwindle"), { description = "Set Workspace Layout to Dwindle" })
-- hl.bind(mod .. " + ALT + M", hl.dsp.layout("master"), { description = "Set Workspace Layout to Master" })
-- hl.bind(mod .. " + ALT + S", hl.dsp.layout("scrolling"), { description = "Set Workspace Layout to Scrolling" })

-- =============================================================================
-- 7. Media & Hardware
-- =============================================================================

-- Brightness Controls
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(noctalia_ipc .. "brightness-up"),
	{ locked = true, repeating = true, description = "Increase Screen Brightness" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(noctalia_ipc .. "brightness-down"),
	{ locked = true, repeating = true, description = "Decrease Screen Brightness" }
)

-- Volume Controls
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(noctalia_ipc .. "volume-up"),
	{ locked = true, repeating = true, description = "Increase Audio Volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(noctalia_ipc .. "volume-down"),
	{ locked = true, repeating = true, description = "Decrease Audio Volume" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(noctalia_ipc .. "volume-mute"),
	{ locked = true, description = "Toggle Audio Mute" }
)
hl.bind(
	mod .. " + SHIFT + M",
	hl.dsp.exec_cmd(noctalia_ipc .. "volume-mute"),
	{ locked = true, description = "Toggle Audio Mute" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd(noctalia_ipc .. "mic-mute"),
	{ locked = true, description = "Toggle Microphone Mute" }
)
hl.bind(
	mod .. " + ALT + M",
	hl.dsp.exec_cmd(noctalia_ipc .. "mic-mute"),
	{ locked = true, description = "Toggle Microphone Mute" }
)

-- Playback Controls
hl.bind(
	"XF86AudioNext",
	hl.dsp.exec_cmd(noctalia_ipc .. "media next"),
	{ locked = true, description = "Play Next Media Track" }
)
hl.bind(
	"XF86AudioPrev",
	hl.dsp.exec_cmd(noctalia_ipc .. "media previous"),
	{ locked = true, description = "Play Previous Media Track" }
)
hl.bind(
	"XF86AudioPlay",
	hl.dsp.exec_cmd(noctalia_ipc .. "media toggle"),
	{ locked = true, description = "Toggle Media Play / Pause" }
)
hl.bind(
	"XF86AudioPause",
	hl.dsp.exec_cmd(noctalia_ipc .. "media toggle"),
	{ locked = true, description = "Toggle Media Play / Pause" }
)
hl.bind(
	mod .. " + SHIFT + N",
	hl.dsp.exec_cmd(noctalia_ipc .. "media next"),
	{ locked = true, description = "Play Next Track" }
)
hl.bind(
	mod .. " + SHIFT + B",
	hl.dsp.exec_cmd(noctalia_ipc .. "media previous"),
	{ locked = true, description = "Play Previous Track" }
)
hl.bind(
	mod .. " + SHIFT + P",
	hl.dsp.exec_cmd(noctalia_ipc .. "media toggle"),
	{ locked = true, description = "Play / Pause Media" }
)

-- Screen Zoom
hl.bind(mod .. " + Minus", function()
	zoomfunction(-0.3)
end, { repeating = true, description = "Zoom Out Desktop" })
hl.bind(mod .. " + Equal", function()
	zoomfunction(0.3)
end, { repeating = true, description = "Zoom In Desktop" })

-- =============================================================================
-- 8. Screenshots & Capture Utilities
-- =============================================================================

local grimhyprctl = "grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\""

-- Noctalia Screenshot
hl.bind(
	mod .. " + SHIFT + S",
	hl.dsp.exec_cmd("noctalia msg screenshot-region"),
	{ description = "Capture Screen Region (Noctalia)" }
)
hl.bind(
	mod .. " + SHIFT + Print",
	hl.dsp.exec_cmd("noctalia msg screenshot-region"),
	{ description = "Capture Screen Region (Noctalia)" }
)
hl.bind(
	mod .. " + ALT + Print",
	hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"),
	{ locked = true, description = "Capture Fullscreen (Noctalia)" }
)

-- Satty Annotation GUI
hl.bind(
	mod .. " + ALT + SHIFT + S",
	hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty --filename -'),
	{ description = "Capture & Annotate Region (Satty)" }
)
hl.bind(
	mod .. " + ALT + SHIFT + P",
	hl.dsp.exec_cmd("grim - | satty --filename -"),
	{ locked = true, description = "Capture & Annotate Fullscreen (Satty)" }
)

-- Quick Raw Captures
hl.bind(
	"Print",
	hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"),
	{ locked = true, description = "Copy Active Screen to Clipboard" }
)
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd(
		"mkdir -p $(xdg-user-dir PICTURES)/Screenshots && "
			.. grimhyprctl
			.. " $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"
	),
	{ locked = true, description = "Save Active Screen to Screenshots File" }
)

-- Screen & Audio Recording (GPU Screen Recorder)
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("gsr-ui"), { description = "Open Recording Dashboard Overlay" })
hl.bind(
	mod .. " + ALT + SHIFT + R",
	hl.dsp.exec_cmd("gsr-ui-cli toggle-record"),
	{ locked = true, description = "Start / Stop Recording" }
)
hl.bind(
	mod .. " + ALT + SHIFT + Space",
	hl.dsp.exec_cmd("gsr-ui-cli toggle-pause"),
	{ locked = true, description = "Pause / Resume Recording" }
)

-- Productivity & Screen Inspection
hl.bind(
	mod .. " + SHIFT + X",
	hl.dsp.exec_cmd(
		'grim -g "$(slurp)" "/tmp/ocr.png" && tesseract "/tmp/ocr.png" stdout | wl-copy && rm "/tmp/ocr.png"'
	),
	{ description = "Extract Text via OCR to Clipboard" }
)
hl.bind(
	mod .. " + SHIFT + A",
	hl.dsp.exec_cmd("pidof slurp || " .. hyprScripts .. "/snip_to_search.sh"),
	{ description = "Search Screen Snippet (Google Lens)" }
)
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Pick Screen Color to Clipboard" })

-- =============================================================================
-- 9. Submaps & Modes
-- =============================================================================

hl.define_submap("virtual-machine", function()
	hl.bind(mod .. " + ALT + F1", function()
		local currentsubmap = hl.get_current_submap()
		if currentsubmap == "virtual-machine" then
			hl.dispatch(
				hl.dsp.exec_cmd("notify-send 'Exited Virtual Machine Submap' 'Keybinds re-enabled' -a 'Hyprland'")
			)
			hl.dispatch(hl.dsp.submap("reset"))
		elseif currentsubmap == "" then
			hl.dispatch(
				hl.dsp.exec_cmd(
					"notify-send 'Entered Virtual Machine Submap' 'Keybinds disabled. Press SUPER+ALT+F1 to exit' -a 'Hyprland'"
				)
			)
			hl.dispatch(hl.dsp.submap("virtual-machine"))
		end
	end, { submap_universal = true, description = "Toggle Virtual Machine Input Passthrough Mode" })
end)
