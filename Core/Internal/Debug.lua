ni.debug = {
	Print = function(str)
		if ni.vars.debug then
			print("\124cffff0000" .. str)
		end
	end,
	Log = function(str, bool)
		local bool = bool ~= nil and bool or false
		return (str ~= nil and bool ~= nil) and ni.functions.AddLog(str, bool) or false
	end,
	Popup = function(title, text)
		return (title ~= nil and text ~= nil) and ni.functions.Popup(title, text) or false
	end
}
