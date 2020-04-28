local UnitClass = UnitClass;

local _, class = UnitClass("player");

ni = {}
ni.frames = {}
ni.vars = {}
ni.rotations = {}
ni.utils = {}
ni.rotation = {}
ni.combat = {}
ni.tables = {}
ni.delays = {}
ni.debug = {}
ni.ui = {}
ni.unit = {}
ni.player = {}
ni.rune = {}
ni.spell = {}
ni.power = {}
ni.objectmanager = {}
ni.objects = {}
ni.members = {}
ni.tanks = {}
ni[class] = {
    rotations = {},
    startrotation = function()
        if (ni.vars.profiles.active ~= nil and ni.vars.profiles.active ~= "None") then
            ni[class].rotations[ni.vars.profiles.active].start()
        end
    end
}
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
	getobjects = %%GetOM%%
}