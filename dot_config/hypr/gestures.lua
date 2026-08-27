-- =============================================================================
-- Native 1:1 Trackpad Gestures Configuration
-- =============================================================================

local noctalia_ipc = "noctalia msg "

-- -----------------------------------------------------------------------------
-- 1. Three-Finger Navigation & UI Overlays
-- -----------------------------------------------------------------------------

-- 3-Finger Horizontal: 1:1 Fluid Workspace Traversal
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- 3-Finger Up: Toggle GloView Workspace Overview
hl.gesture({
	fingers = 3,
	direction = "up",
	action = function()
		hl.plugin.gloview.toggle()
	end,
})

-- 3-Finger Down: Toggle General Scratchpad (SUPER + S)
hl.gesture({
	fingers = 3,
	direction = "down",
	action = "special",
	workspace_name = "special",
})

-- 3-Finger Horizontal (Holding ALT): Continuous Tape Scroll on Scrolling Layouts
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	mods = "ALT",
	action = "scroll_move",
})

-- -----------------------------------------------------------------------------
-- 2. Pinch & Multi-Finger Viewport Gestures
-- -----------------------------------------------------------------------------

-- 2-Finger Pinch: Live Smooth Desktop Cursor Zoom (SUPER + Minus/Equal equivalent)
hl.gesture({
	fingers = 2,
	direction = "pinch",
	action = "cursorZoom",
	zoom_level = 1.0,
	mode = "live",
})

-- 4-Finger Pinch In: Toggle GloView Overview
hl.gesture({
	fingers = 4,
	direction = "pinchin",
	action = function()
		hl.plugin.gloview.toggle()
	end,
})

-- 4-Finger Pinch Out: Toggle GloView All-Workspaces Expo View
hl.gesture({
	fingers = 4,
	direction = "pinchout",
	action = function()
		hl.plugin.gloview.allworkspaces()
	end,
})

-- -----------------------------------------------------------------------------
-- 3. Four-Finger Window Management
-- -----------------------------------------------------------------------------

-- 4-Finger Up: Toggle Fullscreen (SUPER + F)
hl.gesture({
	fingers = 4,
	direction = "up",
	action = "fullscreen",
})

-- 4-Finger Down: Close Active Window (SUPER + Q)
hl.gesture({
	fingers = 4,
	direction = "down",
	action = "close",
})

-- 4-Finger Horizontal: Toggle Window Floating / Tiling (SUPER + SHIFT + F)
hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "float",
})

-- -----------------------------------------------------------------------------
-- 4. Three-Finger Modified Overlays (SUPER & ALT Channels)
-- -----------------------------------------------------------------------------

-- 3-Finger Up (Holding SUPER): Toggle Control Center (SUPER + A)
hl.gesture({
	fingers = 3,
	direction = "up",
	mods = "SUPER",
	action = function()
		hl.exec_cmd(noctalia_ipc .. "panel-toggle control-center")
	end,
})

-- 3-Finger Down (Holding SUPER): Toggle Application Launcher (ALT + Space)
hl.gesture({
	fingers = 3,
	direction = "down",
	mods = "SUPER",
	action = function()
		hl.exec_cmd(noctalia_ipc .. "panel-toggle launcher")
	end,
})

-- 3-Finger Up (Holding ALT): Volume Up
hl.gesture({
	fingers = 3,
	direction = "up",
	mods = "ALT",
	action = function()
		hl.exec_cmd(noctalia_ipc .. "volume-up")
	end,
})

-- 3-Finger Down (Holding ALT): Volume Down
hl.gesture({
	fingers = 3,
	direction = "down",
	mods = "ALT",
	action = function()
		hl.exec_cmd(noctalia_ipc .. "volume-down")
	end,
})
