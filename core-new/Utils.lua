ni.utils = {
	LoadFile = function(filename)
		if filename == nil then
			return
		end
		return ni.functions.LoadFile(filename)
	end,
	SplitStringByDelimiter = function(str, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		for st in string.gmatch(str, "([^" .. sep .. "]+)") do
			table.insert(t, st)
		end
		return t
	end,
	SplitString = function(str)
		local t = {}
		for st in string.gmatch(str, "([^|]+)") do
			table.insert(t, st)
		end
		return t
	end,
	SplitStringToLower = function(str)
		local t = {}
		for st in string.gmatch(str, "([^|]+)") do
			local strlwr = string.lower(st)
			table.insert(t, strlwr)
		end
		return t
	end
}
