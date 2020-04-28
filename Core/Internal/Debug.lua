ni.debug = {
	print = function(string)
		if ni.vars.debug then
			print("\124cffff0000" .. string);
		end
	end,
	log = function(string, bool) --bool is optional, true for error message, empty or false for normal
		return ni.functions.addlog(string, bool);
	end,
	popup = function(title, text)
		ni.functions.popup(title, text);
	end
}
