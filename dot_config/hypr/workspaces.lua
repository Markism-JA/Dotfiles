-- Workspaces 1 to 7 on HDMI-A-1 (External Monitor)
for ws = 1, 7 do
	hl.workspace_rule({
		workspace = tostring(ws),
		monitor = "HDMI-A-1",
		persistent = true,
	})
end

-- Workspaces 8 to 10 on eDP-1 (Laptop / Built-in Display)
for ws = 8, 10 do
	hl.workspace_rule({
		workspace = tostring(ws),
		monitor = "eDP-1",
		persistent = true,
	})
end
