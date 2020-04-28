ni.utils = {
	loadfile = function(filename)
		return ni.functions.loadlua(filename)
	end,
	loadfiles = function(files)
		for _, v in pairs(files) do
			if not ni.utils.loadfile(v) then
				ni.debug.log("Failed to load: " .. v, true)
				return false;
			end
		end
		return true;
	end,
	splitstringbydelimiter = function(str, sep)
		if sep == nil then
			sep = "%s"
		end
		local t = {}
		for st in string.gmatch(str, "([^" .. sep .. "]+)") do
			table.insert(t, st)
		end
		return t
	end,
	splitstring = function(str)
		local t = {}
		for st in string.gmatch(str, "([^|]+)") do
			table.insert(t, st)
		end
		return t
	end,
	splitstringtolower = function(str)
		str = string.lower(str)
		return ni.utils.splitstring(str)
	end,
	findand = function(str)
		return str and (string.match(str, "&&") and true) or nil
	end,
	firstcharacterupper = function(str)
		str = string.lower(str)
		return str:sub(1, 1):upper() .. str:sub(2)
	end
}
