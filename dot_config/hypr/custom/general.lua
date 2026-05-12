hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@100",
	position = "0x0",
	scale = "1",
})
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "1920x0",
	scale = "1.2",
})

hl.workspace_rule({
	workspace = "1",
	monitor = "HDMI-A-1",
})

hl.workspace_rule({
	workspace = "2",
	monitor = "HDMI-A-1",
})

hl.workspace_rule({
	workspace = "3",
	monitor = "HDMI-A-1",
})

hl.workspace_rule({
	workspace = "4",
	monitor = "HDMI-A-1",
})

hl.workspace_rule({
	workspace = "5",
	monitor = "HDMI-A-1",
})

hl.workspace_rule({
	workspace = "6",
	monitor = "HDMI-A-1",
})

hl.workspace_rule({
	workspace = "7",
	monitor = "HDMI-A-1",
})

hl.workspace_rule({
	workspace = "8",
	monitor = "eDP-1",
})

hl.workspace_rule({
	workspace = "9",
	monitor = "eDP-1",
})

hl.workspace_rule({
	workspace = "10",
	monitor = "eDP-1",
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

hl.config({
	input = {
		natural_scroll = false,
	},
})

hl.device({
	name = "elan0522:01-04f3:31c3-touchpad",
	sensitivity = 0.5,
})
