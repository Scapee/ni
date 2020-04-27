ni.debug = {
	print = function(str)
		if ni.vars.debug then
			print("\124cffff0000" .. str)
		end
	end,
	log = function(str, bool)
		local bool = bool ~= nil and bool or false
		return (str ~= nil and bool ~= nil) and ni.functions.addLog(str, bool) or false
	end,
	popup = function(title, text)
		return (title ~= nil and text ~= nil) and ni.functions.popup(title, text) or false
	end
}
