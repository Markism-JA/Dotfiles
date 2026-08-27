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

hl.workspace_rule({
	workspace = "1",
	layout = "master",
})

hl.workspace_rule({
	workspace = "2",
	layout = "monocle",
})

hl.workspace_rule({
	workspace = "3",
	layout = "dwindle",
})

hl.workspace_rule({
	workspace = "4",
	layout = "dwindle",
})

hl.workspace_rule({
	workspace = "5",
	layout = "dwindle",
})

hl.workspace_rule({
	workspace = "6",
	layout = "scrolling",
})

hl.workspace_rule({
	workspace = "7",
	layout = "monocle",
})

hl.workspace_rule({
	workspace = "8",
	layout = "scrolling",
})

hl.workspace_rule({
	workspace = "9",
	layout = "master",
})

hl.workspace_rule({
	workspace = "10",
	layout = "dwindle",
})
