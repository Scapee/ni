--0 - Initial.lua
local version = "1.0.0";
local _, _class = UnitClass('player');
ni = {};
ni.functions = {
	addlog = %%AddLog%%,
	popup = %%PopUp%%,
	loadlua = %%LoadFile%%,
	test = %%Test%%,
	objectexists = %%ObjectExists%%,
	los = %%LoS%%,
	unitcreator = %%UnitCreator%%,
	creaturetype = %%CreatureType%%,
	combatreach = %%CombatReach%%,
	unitflags = %%UnitFlags%%,
	unitdynamicflags = %%UnitDynamicFlags%%,
	objectinfo = %%ObjectInfo%%,
	isfacing = %%IsFacing%%,
	getdistance = %%GetDistance%%,
	isbehind = %%IsBehind%%,
	hasaura = %%HasAura%%,
	moveto = %%MoveTo%%,
	clickat = %%ClickAt%%,
	stopmoving = %%StopMoving%%,
	lookat = %%LookAt%%,
	settarget = %%SetTarget%%,
	runtext = %%RunText%%,
	item = %%Item%%,
	inventoryitem = %%InventoryItem%%,
	interact = %%Interact%%,
	cast = %%Cast%%,
	getspellid = %%GetSpellID%%,
	stopcasting = %%StopCasting%%,
	getom = %%GetOM%%
};
ni.tables = {
	bosses = {},
	mismarkedbosses = {},
	ccdebuffs = {}
};
ni.ui = {
	debugout = function(str)
		if ni.vars.debug then
			print("\124cffff0000"..str);
		end
	end,
	addlog = function(str, bool)
		local bool = bool ~= nil and bool or false
		return (str ~= nil and bool ~= nil) and ni.functions.addlog(str, bool) or false;
	end,
	popup = function(title, text)
		return (title ~= nil and text ~= nil) and ni.functions.popup(title, text) or false;
	end,
}
ni.loadfile = function(filename)
	if filename == nil then return end;
	return ni.functions.loadfile(filename);
end;
ni.test = function(...)
	return ni.functions.test(...);
end;
ni.vars = {
	IsMelee = false,
	CastAM = false,
	CastStarted = false,
	CD = false,
	DnDTimer = 0,
	ShouldICast = 0,
	MyLastCast = 0,
	WasItSuccessful = false,
	queued = false,
	LogCatching = false,
	AoE = false,
	debug = false,
	AutoLoot = false,
	AutoLootDE = false,
	AutoLootNeed = false,
	RotationStarted = false,
	AutoAcceptRC = true,
	customTarget = 'player',
	latency = 220,
	hotkeys = {
		aoe = '{aoeToggle}',
		cd = '{cdToggle}',
		pause = '{pauseToggle}',
		custom = '{customToggle}',
	},
	profiles = {
		primary = 'None',
		secondary = 'None',
		active = 'None',
		interrupt = false,
		enabled = false,
		useEngine = true
	},
	units = {
		follow = '{followUnit}',
		followEnabled = false,
		mainTank = '{mainTank}',
		mainTankEnabled = false,
		offTank = '{offTank}',
		offTankEnabled = false
	},
	interrupt = 'all',
	BlackList = { },
	InterruptList = { }
};
ni.splitbydelim = function(str, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for st in string.gmatch(str, "([^"..sep.."]+)") do
		table.insert(t, st)
	end
	return t
end;
ni.splitstring = function(str)
	local t = {};
	for st in string.gmatch(str, "([^|]+)") do
		table.insert(t, st);
	end
	return t;
end;
ni.splitstringtolower = function(str)
	local t = {};
	for st in string.gmatch(str, "([^|]+)") do
		local strlwr = string.lower(st);
		table.insert(t, strlwr)
	end
	return t;
end;
ni.updateinterrupts = function(str)
	local t = ni.splitstring(str);
	ni.vars.BlackList = t;
end;
ni.combat = {
	started = false,
	time = 0
};
ni[_class] = {
	rotations = {},
	rotation = function()
		if(ni.vars.profiles.active ~= nil and ni.vars.profiles.active ~= "None")then
			ni[_class].rotations[ni.vars.profiles.active].rotation();
		end
	end,
};