local utils = require("utils")

local has_hdmi = utils.is_monitor_connected("HDMI-A-1")

if has_hdmi then
	for ws = 1, 7 do
		hl.workspace_rule({
			workspace = tostring(ws),
			monitor = "HDMI-A-1",
			persistent = true,
		})
	end

	for ws = 8, 10 do
		hl.workspace_rule({
			workspace = tostring(ws),
			monitor = "eDP-1",
			persistent = true,
		})
	end
else
	for ws = 1, 10 do
		hl.workspace_rule({
			workspace = tostring(ws),
			monitor = "eDP-1",
			persistent = true,
		})
	end
end
