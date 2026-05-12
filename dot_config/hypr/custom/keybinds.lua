local settings = require("custom.settings")
local mod = settings.mainMod

local customScripts = "$HOME/.config/hypr/custom/scripts"

--##! Apps
hl.unbind(mod .. " + W")
hl.bind(mod .. " + W", hl.dsp.exec_cmd(settings.browser))

hl.unbind(mod .. " + Return")
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(settings.terminal))

hl.unbind(mod .. " + ALT + Space")
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

hl.unbind(mod .. " + E")
hl.bind(mod .. " + E", hl.dsp.exec_cmd(settings.fileManager))

hl.unbind("CTRL + SHIFT + Escape")

--##! Shell
hl.bind("ALT + Space", hl.dsp.exec_cmd("albert toggle"))

--##! Scroll & Workspaces
hl.unbind(mod .. " + mouse_up")
hl.unbind(mod .. " + mouse_down")
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))

hl.unbind(mod .. " + Page_Down")
hl.unbind(mod .. " + Page_Up")
hl.bind(mod .. " + Page_Down", hl.dsp.exec_cmd(customScripts .. "/switch_workspace.sh -n"))
hl.bind(mod .. " + Page_Up", hl.dsp.exec_cmd(customScripts .. "/switch_workspace.sh -p"))

hl.unbind("CTRL + " .. mod .. " + T")
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("quickshell -c ii ipc call wallpaperSelector toggle"))

hl.bind(mod .. " + Space", hl.dsp.exec_cmd(customScripts .. "/toggle_floating.sh"))

hl.unbind(mod .. " + SHIFT + ALT + Q")
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))

hl.unbind(mod .. " + S")
hl.unbind(mod .. " + B")
-- Added description flag as shown in documentation: { description = "your description here"}
hl.bind(mod .. " + B", hl.dsp.global("quickshell:barToggle"), { description = "Toggle bar" })

--##! Session & System
hl.unbind(mod .. " + SHIFT + L")
hl.unbind(mod .. " + L")
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("loginctl lock-session"), { description = "Lock" })

hl.unbind(mod .. " + K")
hl.bind(mod .. " + SHIFT + K", hl.dsp.global("quickshell:oskToggle"), { description = "Toggle on-screen keyboard" })

--##! Window Movement & Focus

hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
end)

hl.bind("ALT + SHIFT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next("prev"))
end)

-- Vim keys
hl.unbind(mod .. " + J")
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))

--##! Specialized Apps & Tasks
-- Task
hl.unbind(mod .. " + T")
hl.bind(mod .. " + T", hl.dsp.exec_cmd("~/Scripts/bin/task-manager/launch_dashboard.sh"))

-- Calendar
hl.bind("CTRL + " .. mod .. " + C", hl.dsp.workspace.toggle_special("gcal"))

-- Messenger
hl.bind("CTRL + " .. mod .. " + M", hl.dsp.workspace.toggle_special("cap"))

-- Browser fallback
hl.bind(mod .. " + Z", hl.dsp.exec_cmd("zen-browser"))
