local M = {}

--- Toggle a specific tag on the focused window
---@param tag_name string
function M.toggle_tag(tag_name)
	local win = hl.get_active_window()
	if not win then
		return
	end

	hl.dispatch(hl.dsp.window.tag({ tag = tag_name }))
	hl.notification.create({
		text = "Tagged Window: " .. tag_name,
		timeout = 1500,
		icon = "ok",
	})
end

--- Clear all tags on the focused window
function M.clear_tags()
	local win = hl.get_active_window()
	if not win then
		return
	end

	hl.dispatch(hl.dsp.window.clear_tags())
	hl.notification.create({
		text = "Cleared Window Tags",
		timeout = 1500,
		icon = "ok",
	})
end

--- Gather all windows matching a tag to a target workspace
---@param tag_name string
---@param target_ws string
function M.gather_tagged(tag_name, target_ws)
	local wins = hl.get_windows({ tag = tag_name })
	for _, w in ipairs(wins) do
		hl.dispatch(hl.dsp.window.move({
			window = w.address,
			workspace = target_ws,
			follow = false,
		}))
	end
	hl.notification.create({
		text = "Gathered " .. #wins .. " [" .. tag_name .. "] windows to WS " .. target_ws,
		timeout = 1800,
		icon = "ok",
	})
end

return M
