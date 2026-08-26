local function workspace_in_group(i)
	return tostring(i)
end

local settings = require("settings")
local mod = settings.mainMod or "SUPER"
local ipc = "noctalia msg "
local hyprScripts = "$HOME/.config/hypr/scripts"
local terminal = settings.terminal
local fileManager = settings.fileManager
local browser = settings.browser
local officeSoftware = "libreoffice"

--##! Apps
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal), { description = "App: Terminal" })
hl.bind(mod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "App: File manager" })
hl.bind(mod .. " + W", hl.dsp.exec_cmd(browser), { description = "App: Browser" })
hl.bind(mod .. " + Z", hl.dsp.exec_cmd("zen-browser"), { description = "App: Zen Browser" })
hl.bind(mod .. " + C", hl.dsp.exec_cmd("code"), { description = "App: Code editor" })
hl.bind(mod .. " + X", hl.dsp.exec_cmd("nvim"), { description = "App: Text editor" })
hl.bind(
	"CTRL + " .. mod .. " + SHIFT + ALT + W",
	hl.dsp.exec_cmd(officeSoftware),
	{ description = "App: Office software" }
)
hl.bind(mod .. " + I", hl.dsp.exec_cmd(ipc .. "settings-toggle"), { description = "App: Settings app" })

-- Specialized Workspaces
hl.bind(
	"CTRL + " .. mod .. " + C",
	hl.dsp.workspace.toggle_special("gcal"),
	{ description = "App: Calendar Scratchpad" }
)
hl.bind(
	"CTRL + " .. mod .. " + M",
	hl.dsp.workspace.toggle_special("cap"),
	{ description = "App: Messenger Scratchpad" }
)
hl.bind(
	"CTRL + " .. mod .. " + I",
	hl.dsp.workspace.toggle_special("insta"),
	{ description = "App: Instagram Scratchpad" }
)
hl.bind("CTRL + " .. mod .. " + D", hl.dsp.workspace.toggle_special("dc"), { description = "App: Discord Scratchpad" })

hl.bind(
	"CTRL + " .. mod .. " + G",
	hl.dsp.workspace.toggle_special("todo"),
	{ description = "App: Todoist Scratchpad" }
)

hl.bind(
	"CTRL + " .. mod .. " + T",
	hl.dsp.workspace.toggle_special("task"),
	{ description = "App: Task Manager Scratchpad" }
)

hl.bind(
	"CTRL + " .. mod .. " + T",
	hl.dsp.exec_cmd("/home/marky/Scripts/bin/task-manager/launch_dashboard.sh"),
	{ description = "App: Task Manager Scratchpad" }
)

--##! Shell (Noctalia)
hl.bind(" ALT + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))

hl.bind(
	mod .. " + A",
	hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"),
	{ description = "Shell: Toggle control center" }
)
hl.bind(mod .. " + B", hl.dsp.exec_cmd(ipc .. "bar-toggle"), { description = "Shell: Toggle bar (Alt)" })

-- Theme & Appearance
hl.bind(
	"CTRL + " .. mod .. " + SHIFT + D",
	hl.dsp.exec_cmd(ipc .. "theme-mode-toggle"),
	{ description = "Shell: Toggle light/dark mode" }
)
hl.bind(
	mod .. " + SHIFT + W",
	hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper"),
	{ description = "Shell: Random wallpaper" }
)

-- Session Management
hl.bind(
	"CTRL + ALT + Delete",
	hl.dsp.exec_cmd(ipc .. "panel-toggle session"),
	{ description = "Shell: Toggle session menu" }
)
-- hl.bind(
-- 	mod .. " + SHIFT + L",
-- 	hl.dsp.exec_cmd("systemctl suspend || loginctl suspend"),
-- 	{ locked = true, description = "Session: Sleep" }
-- )

--##! Utilities
-- Clipboard & Emoji
hl.bind(
	mod .. " + V",
	hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"),
	{ description = "Utilities: Toggle clipboard panel" }
)
hl.bind(
	mod .. " + Period",
	hl.dsp.exec_cmd(hyprScripts .. "/fuzzel-emoji.sh copy"),
	{ description = "Utilities: Emoji picker" }
)

-- =========================================================
-- SCREENSHOTS & ANNOTATION
-- =========================================================

-- Noctalia Native (Quick & Lightweight pill-toolbar annotations)
hl.bind(
	mod .. " + SHIFT + S",
	hl.dsp.exec_cmd("noctalia msg screenshot-region"),
	{ description = "Utilities: Noctalia Region Screenshot" }
)
hl.bind(
	mod .. " + ALT + P",
	hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"),
	{ locked = true, description = "Utilities: Noctalia Fullscreen" }
)

-- Satty (Advanced GUI / Complex edits)
hl.bind(
	mod .. " + ALT + SHIFT + S",
	hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty --filename -'),
	{ description = "Utilities: Satty Advanced GUI Region" }
)
hl.bind(
	mod .. " + ALT + SHIFT + P",
	hl.dsp.exec_cmd("grim - | satty --filename -"),
	{ locked = true, description = "Utilities: Satty Advanced GUI Fullscreen" }
)

-- Direct Low-Level Captures (Straight to file/clipboard via grim)
local grimhyprctl = "grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\""
hl.bind(
	"Print",
	hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"),
	{ locked = true, description = "Utilities: Quick raw screenshot >> clipboard" }
)
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd(
		"mkdir -p $(xdg-user-dir PICTURES)/Screenshots && "
			.. grimhyprctl
			.. " $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"
	),
	{ locked = true, description = "Utilities: Quick raw screenshot >> file" }
)

-- =========================================================
-- SCREEN & AUDIO RECORDING
-- =========================================================

-- Toggle the main ShadowPlay-style interface overlay screen
hl.bind(
	mod .. " + SHIFT + R",
	hl.dsp.exec_cmd("gsr-ui"),
	{ description = "Utilities: Open recording overlay dashboard" }
)

-- Direct Keybinds hooking straight into the gsr-ui manager backend
hl.bind(
	mod .. " + ALT + SHIFT + R",
	hl.dsp.exec_cmd("gsr-ui-cli toggle-record"),
	{ locked = true, description = "Utilities: Instantly start/stop recording" }
)
hl.bind(
	mod .. " + ALT + P",
	hl.dsp.exec_cmd("gsr-ui-cli toggle-pause"),
	{ locked = true, description = "Utilities: Pause/Resume active capture" }
)

-- =========================================================
-- INTELLIGENCE & UTILS
-- =========================================================
hl.bind(
	mod .. " + SHIFT + X",
	hl.dsp.exec_cmd(
		'grim -g "$(slurp)" "/tmp/ocr.png" && tesseract "/tmp/ocr.png" stdout | wl-copy && rm "/tmp/ocr.png"'
	),
	{ description = "Utilities: OCR >> clipboard" }
)
hl.bind(
	mod .. " + SHIFT + A",
	hl.dsp.exec_cmd("pidof slurp || " .. hyprScripts .. "/snip_to_search.sh"),
	{ description = "Utilities: Google Lens" }
)
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Utilities: Pick color >> clipboard" })
--##! Hardware & Media Controls (Noctalia)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"), { locked = true, repeating = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true })
hl.bind(
	mod .. " + SHIFT + M",
	hl.dsp.exec_cmd(ipc .. "volume-mute"),
	{ locked = true, description = "Media: Toggle mute" }
)

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. "mic-mute"), { locked = true })
hl.bind(mod .. " + ALT + M", hl.dsp.exec_cmd(ipc .. "mic-mute"), { locked = true, description = "Media: Toggle mic" })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "media previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true })

hl.bind(
	mod .. " + SHIFT + N",
	hl.dsp.exec_cmd(ipc .. "media next"),
	{ locked = true, description = "Media: Next track" }
)
hl.bind(
	mod .. " + SHIFT + B",
	hl.dsp.exec_cmd(ipc .. "media previous"),
	{ locked = true, description = "Media: Previous track" }
)
hl.bind(
	mod .. " + SHIFT + P",
	hl.dsp.exec_cmd(ipc .. "media toggle"),
	{ locked = true, description = "Media: Play/pause" }
)

-- Screen Zoom (Definition localized here)
local function zoomfunction(value)
	local zoomvalue = hl.get_config("cursor:zoom_factor")
	local new_zoom = math.max(1.0, math.min(3.0, zoomvalue + value))
	hl.config({ cursor = { zoom_factor = new_zoom } })
end
hl.bind(mod .. " + Minus", function()
	zoomfunction(-0.3)
end, { repeating = true, description = "Screen: Zoom out" })
hl.bind(mod .. " + Equal", function()
	zoomfunction(0.3)
end, { repeating = true, description = "Screen: Zoom in" })

--##! Window Management
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })

-- Window State & Layout
hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Window: Force Zap" })
hl.bind(mod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Float/Tile" })
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(
	mod .. " + D",
	hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
	{ description = "Window: Maximize" }
)
hl.bind(
	mod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Window: Fullscreen" }
)
hl.bind(mod .. " + P", hl.dsp.window.pin(), { description = "Window: Pin" })
hl.bind(mod .. " + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(mod .. " + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- =============================================================================
-- Workspace-Local Alt-Tab (Respects Fullscreen / Maximize)
-- =============================================================================

-- Alt + Tab -> Cycle forward within current workspace
hl.bind(
	"ALT + Tab",
	hl.dsp.window.cycle_next({ tiled = false, floating = false }),
	{ description = "Cycle next window on workspace" }
)

-- Alt + Shift + Tab -> Cycle backward within current workspace
hl.bind(
	"ALT + SHIFT + Tab",
	hl.dsp.window.cycle_next({ next = false }),
	{ description = "Cycle previous window on workspace" }
)

-- Focus Movement (Vim & Arrows)

local dirs = { Left = "l", Right = "r", Up = "u", Down = "d", H = "l", L = "r", K = "u", J = "d" }
for key, dir in pairs(dirs) do
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }), { description = "Window: Focus " .. key })
	hl.bind(
		mod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ direction = dir }),
		{ description = "Window: Move " .. key }
	)
end

--##! Workspaces
-- Focus Workspaces (Numbers & Keypad)
for i = 1, 10 do
	local bind_key = i % 10
	hl.bind(mod .. " + " .. bind_key, function()
		hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
	end, { description = "Workspace: Focus " .. i })
	hl.bind(mod .. " + ALT + " .. bind_key, function()
		hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = false }))
	end, { description = "Window: Send to workspace " .. i })

	local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
	hl.bind(mod .. " + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.focus({ workspace = workspace_in_group(i) }))
	end)
	hl.bind(mod .. " + ALT + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(i), follow = false }))
	end)
end

-- Focus left/right via Keyboard & Mouse
hl.bind("CTRL + " .. mod .. " + Left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("CTRL + " .. mod .. " + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mod .. " + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mod .. " + Page_Up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))

-- Scratchpad
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("special"), { description = "Workspace: Toggle scratchpad" })
hl.bind("CTRL + " .. mod .. " + S", hl.dsp.workspace.toggle_special("special"))
hl.bind(
	mod .. " + ALT + S",
	hl.dsp.window.move({ workspace = "special:special", follow = false }),
	{ description = "Window: Send to scratchpad" }
)

--##! Virtual Machines Submap
hl.define_submap("virtual-machine", function()
	hl.bind(mod .. " + ALT + F1", function()
		local currentsubmap = hl.get_current_submap()
		if currentsubmap == "virtual-machine" then
			hl.dispatch(
				hl.dsp.exec_cmd("notify-send 'Exited Virtual Machine submap' 'Keybinds re-enabled' -a 'Hyprland'")
			)
			hl.dispatch(hl.dsp.submap("reset"))
		elseif currentsubmap == "" then
			hl.dispatch(
				hl.dsp.exec_cmd(
					"notify-send 'Entered Virtual Machine submap' 'Keybinds disabled. hit SUPER+ALT+F1 to escape' -a 'Hyprland'"
				)
			)
			hl.dispatch(hl.dsp.submap("virtual-machine"))
		end
	end, { submap_universal = true })
end)
