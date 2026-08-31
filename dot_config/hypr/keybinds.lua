local ws_aliases = require("modules.ws_aliases")
local window_tags = require("modules.window_tags")

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
local terminal = settings.terminal or "kitty"
local fileManager = settings.fileManager or "nautilus"
local browser = settings.browser or "google-chrome-stable"

-- = Applications & Launchers

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "Launch Tmux Terminal" })
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty"), { description = "Launch Terminal" })
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "Launch File Manager" })
hl.bind(mod .. " + W", hl.dsp.exec_cmd(browser), { description = "Launch Web Browser" })
hl.bind(mod .. " + I", hl.dsp.exec_cmd(noctalia_ipc .. "settings-toggle"), { description = "Launch Noctalia Settings" })
hl.bind(mod .. " + Space", hl.dsp.exec_cmd("fsearch"), { description = "Launch File Search" })

hl.bind(
	"CTRL + " .. mod .. " + T",
	hl.dsp.exec_cmd("/home/marky/Scripts/bin/task-manager/launch_dashboard.sh"),
	{ description = "App: Task Manager Scratchpad" }
)

-- = Shell & Desktop Controls

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
	mod .. " + Slash",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle kenn/keybind-cheatsheet:cheatsheet"),
	{ description = "Toggle Keybind Cheatsheet" }
)

-- = Window Management & Placement

-- == Mouse Manipulation
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move Window with Mouse" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize Window with Mouse" })

-- == State Toggles
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

-- == Pin & Floating Geometry
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

-- == Corner Snapping
hl.bind(mod .. " + ALT + U", function()
	move_to_corner("top_left", 24)
end, { description = "Align Window Top-Left" })
hl.bind(mod .. " + ALT + I", function()
	move_to_corner("top_right", 24)
end, { description = "Align Window Top-Right" })
hl.bind(mod .. " + ALT + J", function()
	move_to_corner("bottom_left", 24)
end, { description = "Align Window Bottom-Left" })
hl.bind(mod .. " + ALT + K", function()
	move_to_corner("bottom_right", 24)
end, { description = "Align Window Bottom-Right" })

-- == Split Scaling
local function get_active_layout()
	local ws = hl.get_active_workspace()

	if ws and ws.tiled_layout and ws.tiled_layout ~= "" then
		return ws.tiled_layout
	end

	local global_layout = hl.get_config("general.layout")
	if type(global_layout) == "string" and global_layout ~= "" then
		return global_layout
	end

	return "dwindle"
end

local function resize_layout(delta)
	local layout = get_active_layout()

	if layout == "master" then
		local sign = delta > 0 and "+" or ""
		hl.dispatch(hl.dsp.layout("mfact " .. sign .. delta))
	elseif layout == "dwindle" then
		local sign = delta > 0 and "+" or ""
		hl.dispatch(hl.dsp.layout("splitratio " .. sign .. delta))
	elseif layout == "scrolling" then
		hl.dispatch(hl.dsp.layout("colresize +conf"))
	end
end

hl.bind(mod .. " + Semicolon", function()
	resize_layout(-0.05)
end, { repeating = true, description = "Decrease Split / mfact" })

hl.bind(mod .. " + Apostrophe", function()
	resize_layout(0.05)
end, { repeating = true, description = "Increase Split / mfact" })

-- = Focus & Navigation

-- == Directional Focus & Window Moving
local dirs = { Left = "l", Right = "r", Up = "u", Down = "d", H = "l", L = "r", K = "u", J = "d" }
for key, dir in pairs(dirs) do
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }), { description = "Focus Window " .. key })
	hl.bind(
		mod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ direction = dir }),
		{ description = "Move Window " .. key }
	)
end

-- == Window Cycling
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ tiled = true }), { description = "Cycle Next Window" })
hl.bind(
	"ALT + SHIFT + Tab",
	hl.dsp.window.cycle_next({ tiled = true, next = false }),
	{ description = "Cycle Previous Window" }
)

-- == Multi-Monitor Navigation
hl.bind(mod .. " + Period", hl.dsp.focus({ monitor = "+1" }), { description = "Focus Next Monitor" })
hl.bind(mod .. " + Comma", hl.dsp.focus({ monitor = "-1" }), { description = "Focus Previous Monitor" })

hl.bind(
	mod .. " + SHIFT + Period",
	hl.dsp.window.move({ monitor = "+1", follow = true }),
	{ description = "Move Window to Next Monitor" }
)
hl.bind(
	mod .. " + SHIFT + Comma",
	hl.dsp.window.move({ monitor = "-1", follow = true }),
	{ description = "Move Window to Previous Monitor" }
)

-- = Workspaces & Scratchpads

-- == Workspaces 1-10
for i = 1, 10 do
	local bind_key = i % 10
	local target_ws = workspace_in_group(i)

	-- Focus Workspace
	hl.bind(mod .. " + " .. bind_key, function()
		hl.dispatch(hl.dsp.focus({ workspace = target_ws }))
	end, { description = "Focus Workspace " .. i })

	-- Move Window to Workspace (Silent / No Follow)
	hl.bind(mod .. " + ALT + " .. bind_key, function()
		hl.dispatch(hl.dsp.window.move({ workspace = target_ws, follow = false }))
	end, { description = "Move Window to Workspace " .. i .. " (Silent)" })

	-- Move Window to Workspace and Follow
	hl.bind(mod .. " + SHIFT + " .. bind_key, function()
		hl.dispatch(hl.dsp.window.move({ workspace = target_ws, follow = true }))
	end, { description = "Move Window to Workspace " .. i .. " (Follow)" })

	-- Numpad Bindings
	local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }

	hl.bind(mod .. " + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.focus({ workspace = target_ws }))
	end, { description = "Focus Workspace (Numpad " .. i .. ")" })

	hl.bind(mod .. " + ALT + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.window.move({ workspace = target_ws, follow = false }))
	end, { description = "Move Window to Workspace (Numpad " .. i .. " Silent)" })

	hl.bind(mod .. " + SHIFT + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.window.move({ workspace = target_ws, follow = true }))
	end, { description = "Move Window to Workspace (Numpad " .. i .. " Follow)" })
end

-- == Workspace Traversal
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

-- == App & Special Scratchpads
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("special"), { description = "Toggle General Scratchpad" })
hl.bind(
	mod .. " + CTRL + S",
	hl.dsp.window.move({ workspace = "special:special", follow = false }),
	{ description = "Send Window to Scratchpad" }
)
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

-- = Workspace Layouts

local function set_active_layout(layout)
	local w = hl.get_active_special_workspace() or hl.get_active_workspace()
	if not w then
		return
	end

	local target_ws = w.special and tostring(w.name) or tostring(w.id)

	hl.workspace_rule({
		workspace = target_ws,
		layout = layout,
	})

	hl.notification.create({
		text = "Workspace " .. target_ws .. " -> " .. layout:upper(),
		timeout = 1500,
		icon = "ok",
	})
end

-- == Direct Layout Selectors
hl.bind(
	mod .. " + grave",
	hl.dsp.exec_cmd(noctalia_ipc .. "panel-toggle maddingo/hypr-layout-switcher:layouts"),
	{ description = "Toggle Workspace Layout Panel" }
)
hl.bind(mod .. " + ALT + D", function()
	set_active_layout("dwindle")
end, { description = "Set Layout: Dwindle" })

hl.bind(mod .. " + ALT + T", function()
	set_active_layout("master")
end, { description = "Set Layout: Master (Tile/Stack)" })

hl.bind(mod .. " + ALT + S", function()
	set_active_layout("scrolling")
end, { description = "Set Layout: Scrolling" })

hl.bind(mod .. " + ALT + O", function()
	set_active_layout("monocle")
end, { description = "Set Layout: Monocle (One/Deck)" })

-- == Master Layout Controls
hl.bind(
	mod .. " + SHIFT + Return",
	hl.dsp.layout("swapwithmaster master"),
	{ description = "Promote Window to Master" }
)
hl.bind(mod .. " + M", hl.dsp.layout("focusmaster auto"), { description = "Toggle Focus Master/Stack" })
hl.bind(mod .. " + CTRL + bracketright", hl.dsp.layout("rollnext"), { description = "Roll Next Slave to Master" })
hl.bind(mod .. " + CTRL + bracketleft", hl.dsp.layout("rollprev"), { description = "Roll Prev Slave to Master" })
hl.bind(
	mod .. " + Backslash",
	hl.dsp.layout("orientationcycle left center top"),
	{ description = "Cycle Workspace Master Orientation" }
)

-- == Scrolling Layout Controls
hl.bind(mod .. " + SHIFT + mouse_up", hl.dsp.layout("focus l"), { description = "Scroll Ribbon Left / Prev Window" })
hl.bind(mod .. " + SHIFT + mouse_down", hl.dsp.layout("focus r"), { description = "Scroll Ribbon Right / Next Window" })

-- = Semantic Navigation & Staging

-- == Semantic Workspace Offloading
hl.bind(mod .. " + ALT + B", function()
	ws_aliases.focus_to("backend")
end, { description = "Focus Workspace 5 (Backend/DB)" })

hl.bind(mod .. " + ALT + R", function()
	ws_aliases.focus_to("research")
end, { description = "Focus Workspace 6 (Research/Tabs)" })

hl.bind(mod .. " + ALT + V", function()
	ws_aliases.focus_to("media")
end, { description = "Focus Workspace 7 (Media/Video)" })

hl.bind(mod .. " + ALT + W", function()
	ws_aliases.focus_to("aux")
end, { description = "Focus Workspace 8 (Laptop Strip)" })

hl.bind(mod .. " + ALT + Y", function()
	ws_aliases.focus_to("monitor")
end, { description = "Focus Workspace 9 (Observability/Logs)" })

hl.bind(mod .. " + ALT + BackSpace", function()
	ws_aliases.focus_to("staging")
end, { description = "Focus Workspace 10 (Staging/Dump)" })

hl.bind(mod .. " + CTRL + B", function()
	ws_aliases.send_to("backend", false)
end, { description = "Send Window to Workspace 5 (Backend/DB)" })

hl.bind(mod .. " + CTRL + R", function()
	ws_aliases.send_to("research", false)
end, { description = "Send Window to Workspace 6 (Research)" })

hl.bind(mod .. " + CTRL + V", function()
	ws_aliases.send_to("media", false)
end, { description = "Send Window to Workspace 7 (Media)" })

hl.bind(mod .. " + CTRL + W", function()
	ws_aliases.send_to("aux", false)
end, { description = "Send Window to Workspace 8 (Laptop Strip)" })

hl.bind(mod .. " + CTRL + Y", function()
	ws_aliases.send_to("monitor", false)
end, { description = "Send Window to Workspace 9 (Logs/Metrics)" })

hl.bind(mod .. " + CTRL + BackSpace", function()
	ws_aliases.send_to("staging", false)
end, { description = "Dump Window to Workspace 10 (Staging)" })

-- == Window Tagging Pipelines
hl.bind("CTRL + " .. mod .. " + U", function()
	window_tags.toggle_tag("reference")
end, { description = "Toggle 'reference' Tag on Window" })

hl.bind("CTRL + " .. mod .. " + Y", function()
	window_tags.toggle_tag("monitor")
end, { description = "Toggle 'monitor' Tag on Window" })

hl.bind("CTRL + " .. mod .. " + BackSpace", function()
	window_tags.clear_tags()
end, { description = "Clear Tags on Active Window" })

hl.bind("CTRL + " .. mod .. " + SHIFT + U", function()
	window_tags.gather_tagged("reference", ws_aliases.resolve("aux"))
end, { description = "Gather Reference Windows to Laptop Screen (WS 8)" })

-- = Media & Hardware

-- == Brightness Controls
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

-- == Volume & Mute Controls
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

-- == Playback Controls
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

-- == Desktop Zoom
hl.bind(mod .. " + Minus", function()
	zoomfunction(-0.3)
end, { repeating = true, description = "Zoom Out Desktop" })
hl.bind(mod .. " + Equal", function()
	zoomfunction(0.3)
end, { repeating = true, description = "Zoom In Desktop" })

-- = Screen Toolkit & Capture Utilities

local stk_ipc = "noctalia msg plugin alexander/screen-toolkit:service all "

-- == Annotations & Region Capture
hl.bind(mod .. " + ALT + P", hl.dsp.exec_cmd(stk_ipc .. "toggle"), {
	description = "Toggle Screen Toolkit Panel",
})
hl.bind(
	mod .. " + SHIFT + S",
	hl.dsp.exec_cmd("noctalia msg screenshot-region"),
	{ description = "Capture Screen Region (Noctalia)" }
)
hl.bind(mod .. " + ALT + Print", hl.dsp.exec_cmd(stk_ipc .. "annotateFullscreen"), {
	locked = true,
	description = "Capture & Annotate Fullscreen",
})
hl.bind(mod .. " + ALT + SHIFT + S", hl.dsp.exec_cmd(stk_ipc .. "annotateWindow"), {
	description = "Annotate Focused Window",
})

-- == Productivity & OCR
hl.bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd(stk_ipc .. "ocr"), {
	description = "Extract Text via OCR (Screen Toolkit)",
})
hl.bind(mod .. " + SHIFT + A", hl.dsp.exec_cmd(stk_ipc .. "lens"), {
	description = "Search Screen Snippet (Google Lens)",
})
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd(stk_ipc .. "colorPicker"), {
	description = "Pick Color to Clipboard (Screen Toolkit)",
})
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd(stk_ipc .. "measure"), {
	description = "Measure Region Dimensions",
})

-- == Raw Screen Captures
local grimhyprctl = "grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\""

hl.bind("Print", hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"), {
	locked = true,
	description = "Copy Active Screen to Clipboard",
})
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd(
		"mkdir -p $(xdg-user-dir PICTURES)/Screenshots && "
			.. grimhyprctl
			.. " $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"
	),
	{
		locked = true,
		description = "Save Active Screen to File",
	}
)

-- == GPU Screen Recorder
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("gsr-ui"), {
	description = "Open GPU Screen Recorder Overlay",
})
hl.bind(mod .. " + ALT + SHIFT + R", hl.dsp.exec_cmd("gsr-ui-cli toggle-record"), {
	locked = true,
	description = "GSR: Start / Stop Recording",
})
hl.bind(mod .. " + ALT + SHIFT + Space", hl.dsp.exec_cmd("gsr-ui-cli toggle-pause"), {
	locked = true,
	description = "GSR: Pause / Resume Recording",
})

-- = Submaps & Modes

local function toggle_vm_passthrough()
	local current_submap = hl.get_current_submap()

	if current_submap == "virtual-machine" then
		hl.dispatch(hl.dsp.submap("reset"))
		hl.notification.create({
			text = "󰌌 VM Passthrough Disabled (Host Keys Active)",
			timeout = 2000,
			icon = "ok",
		})
	else
		hl.dispatch(hl.dsp.submap("virtual-machine"))
		hl.notification.create({
			text = "󰨇 VM Passthrough Active (SUPER+CTRL+\\ to exit)",
			timeout = 3000,
			icon = "warning",
		})
	end
end

hl.define_submap("virtual-machine", function()
	hl.bind(
		mod .. " + CTRL + Backslash",
		toggle_vm_passthrough,
		{ submap_universal = true, description = "Exit VM Input Passthrough" }
	)
end)

hl.bind(mod .. " + CTRL + Backslash", toggle_vm_passthrough, { description = "Toggle VM Input Passthrough" })
