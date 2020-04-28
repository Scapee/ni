if ni.utils.loadfile("Rotations\\Data\\brajevicm_Data.lua") then
	local hello = hello -- Loaded from file above

	local priorities = {
		"Print Hello"
	}

	local abilities = {
		["Print Hello"] = function()
			ni.debug.print(hello)
		end
	}

	rawset(ni["WARLOCK"].rotations, "Affliction_PvE", ni.bootstrap.rotation(priorities, abilities))
	ni.debug.log("Affliction Loaded")
end
