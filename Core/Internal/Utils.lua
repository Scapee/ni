ni.utils = {
	loadFile = function(filename)
		if filename == nil then
			return false
		end
		return ni.functions.loadLua(filename)
	end,
	loadFiles = function(files)
		for _, v in pairs(files) do
			if not ni.utils.loadFile(v) then
				ni.debug.log("Failed to load: " .. v, true)
				return false;
			end
		end
	end,
	splitStringByDelimiter = function(str, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		for st in string.gmatch(str, "([^" .. sep .. "]+)") do
			table.insert(t, st)
		end
		return t
	end,
	splitString = function(str)
		local t = {}
		for st in string.gmatch(str, "([^|]+)") do
			table.insert(t, st)
		end
		return t
	end,
	splitStringToLower = function(str)
		str = string.lower(str)
		return ni.utils.splitString(str)
	end,
	findAnd = function(str)
		return str and (string.match(str, "&&") and true) or nil
	end,
	firstCharacterUpper = function(str)
		str = string.lower(str)
		return str:sub(1, 1):upper() .. str:sub(2)
	end
}
