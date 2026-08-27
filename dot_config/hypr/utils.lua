local M = {}

--- Checks if a display output is physically connected via sysfs
--- @param port_name string e.g. "HDMI-A-1", "eDP-1", "DP-1"
--- @return boolean
function M.is_monitor_connected(port_name)
	-- Direct sysfs check covering card0, card1, card2
	for _, card in ipairs({ "card1", "card0", "card2" }) do
		local path = string.format("/sys/class/drm/%s-%s/status", card, port_name)
		local f = io.open(path, "r")
		if f then
			local status = f:read("*a")
			f:close()
			return status:find("connected") ~= nil and status:find("disconnected") == nil
		end
	end

	-- Fallback via shell wildcard if card naming is non-standard
	local handle = io.popen(string.format("cat /sys/class/drm/card*-%s/status 2>/dev/null", port_name))
	if handle then
		local out = handle:read("*a")
		handle:close()
		return out:find("connected") ~= nil and out:find("disconnected") == nil
	end

	return false
end

return M
