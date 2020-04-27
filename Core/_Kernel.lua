local UnitClass = UnitClass

local _class = UnitClass("player")

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
ni.objectManager = {}
ni.objects = {}
ni.members = {}
ni.tanks = {}
ni[_class] = {
    rotations = {},
    StartRotation = function()
        if (ni.vars.profiles.active ~= nil and ni.vars.profiles.active ~= "None") then
            ni[_class].rotations[ni.vars.profiles.active].Start()
        end
    end
}
ni.functions = {
	AddLog = %%AddLog%%,
	Popup = %%PopUp%%,
	LoadLua = %%LoadFile%%,
	Test = %%Test%%,
	ObjectExists = %%ObjectExists%%,
	LoS = %%LoS%%,
	UnitCreator = %%UnitCreator%%,
	CreatureType = %%CreatureType%%,
	CombatReach = %%CombatReach%%,
	UnitFlags = %%UnitFlags%%,
	UnitDynamicFlags = %%UnitDynamicFlags%%,
	ObjectInfo = %%ObjectInfo%%,
	IsFacing = %%IsFacing%%,
	GetDistance = %%GetDistance%%,
	IsBehind = %%IsBehind%%,
	HasAura = %%HasAura%%,
	MoveTo = %%MoveTo%%,
	ClickAt = %%ClickAt%%,
	StopMoving = %%StopMoving%%,
	LookAt = %%LookAt%%,
	SetTarget = %%SetTarget%%,
	RunText = %%RunText%%,
	Item = %%Item%%,
	InventoryItem = %%InventoryItem%%,
	Interact = %%Interact%%,
	Cast = %%Cast%%,
	GetSpellID = %%GetSpellID%%,
	StopCasting = %%StopCasting%%,
	GetObjectManager = %%GetOM%%
}