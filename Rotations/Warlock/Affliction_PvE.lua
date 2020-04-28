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

rawset(ni["WARLOCK"].rotations, "Affliction_PvE", ni.bootstrap.rotation(priorities, abilities))
ni.debug.Log("Affliction Loaded")
