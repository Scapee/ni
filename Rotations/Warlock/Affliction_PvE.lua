ni.utils.loadfile("Rotations/Data/brajevicm_Data.lua")

local rawset, hello = rawset, hello -- Loaded from file above

local priorities = {
	"Print Hello"
}

local abilities = {
	["Print Hello"] = function()
		local _hello = hello
		ni.debug.print(_hello)
	end
}

local table = {
	start = function()
		local _priorities = priorities
		local _abilities = abilities

		for i = 1, #_priorities do
			local priority = _priorities[i]
			if _abilities[priority]() then
				break
			end
		end
	end
}

rawset(ni["WARLOCK"].rotations, "Affliction_PvE", table)
ni.debug.Log("Affliction Loaded")
