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

hl.cfg.debug.enable_stdout_logs = 0
hl.cfg.decoration.blur.enabled = false
hl.cfg.animations.enabled = true
hl.cfg.decoration.blur.xray = false

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

hl.animation("fade", false)
hl.animation("fadeDim", false)
hl.animation("workspaces", false)

hl.cfg.input.touchpad.natural_scroll = false

hl.cfg.general.gaps_in = 4
hl.cfg.general.gaps_out = 5

hl.device({
	name = "elan0522:01-04f3:31c3-touchpad",
	sensitivity = 0.5,
})

hl.cfg.decoration = {
	rounding = 12,
	blur = {
		enabled = true,
		size = 10,
		passes = 4,
		brightness = 1.1,
		contrast = 0.9,
		vibrancy = 0.15,
		new_optimizations = true,
	},
}

hl.cfg.misc.on_focus_under_fullscreen = 1
hl.cfg.misc.middle_click_paste = false
