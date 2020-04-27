local CreateFrame, unpack, tremove, tinsert = CreateFrame, unpack, tremove, tinsert

ni.frames.Delay = CreateFrame("Frame")
ni.frames.Delay_OnUpdate = function(self, elapsed)
	local count = #ni.delays
	local i = 1
	while i <= count do
		local waitRecord = tremove(ni.delays, i)
		local d = tremove(waitRecord, 1)
		local f = tremove(waitRecord, 1)
		local p = tremove(waitRecord, 1)
		if d > elapsed then
			tinsert(ni.delays, i, {d - elapsed, f, p})
			i = i + 1
		else
			count = count - 1
			f(unpack(p))
		end
	end
end

ni.delayfor = function(delay, func, ...)
	if type(delay) ~= "number" or type(func) ~= "function" then
		return false
	end
	tinsert(ni.delays, {delay, func, {...}})
	return true
end
