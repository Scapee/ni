ni.frames.DelayFrame = CreateFrame("Frame")
ni.frames.DelayFrame_OnUpdate = function(self, elapsed)
	local count = #ni.tables.delaytable
	local i = 1
	while i <= count do
		local waitRecord = tremove(ni.tables.delaytable, i)
		local d = tremove(waitRecord, 1)
		local f = tremove(waitRecord, 1)
		local p = tremove(waitRecord, 1)
		if d > elapsed then
			tinsert(ni.tables.delaytable, i, {d - elapsed, f, p})
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
	tinsert(ni.tables.delaytable, {delay, func, {...}})
	return true
end
