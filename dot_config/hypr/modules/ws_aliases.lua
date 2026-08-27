local M = {}

M.WS_ALIASES = {
	term = "1",
	web = "2",
	code = "3",
	subcode = "4",

	api = "5",
	backend = "5",
	database = "5",

	research = "6",
	tabs = "6",

	media = "7",
	stream = "7",

	aux = "8",
	laptop = "8",
	reading = "8",

	monitor = "9",
	obs = "9",
	logs = "9",

	staging = "10",
	dump = "10",
}

--- Resolves an alias string to its numeric workspace ID
---@param alias string
---@return string
function M.resolve(alias)
	return M.WS_ALIASES[alias] or alias
end

--- Move active window to a semantic target (silent or follow)
---@param alias string
---@param follow? boolean
function M.send_to(alias, follow)
	local target_id = M.resolve(alias)
	hl.dispatch(hl.dsp.window.move({
		workspace = target_id,
		follow = follow or false,
	}))
	hl.notification.create({
		text = "Window -> WS " .. target_id .. " (" .. alias:upper() .. ")",
		timeout = 1200,
		icon = "ok",
	})
end

--- Focus semantic target workspace
---@param alias string
function M.focus_to(alias)
	local target_id = M.resolve(alias)
	hl.dispatch(hl.dsp.focus({ workspace = target_id }))
end

return M
