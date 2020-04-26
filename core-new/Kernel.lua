local UnitClass = UnitClass

local _, unitClass = UnitClass("player")

ni = {}
ni.frames = {}
ni.vars = {}
ni.rotations = {}
ni.utils = {}
ni.combat = {
	started = false,
	time = 0
}
ni.tables = {
	bosses = {},
	mismarkedBosses = {},
	whitelistedLoSUnits = {},
	blacklistedInterrupts = {},
	whitelistedInterrupts = {},
	whitelistedCCDebuffs = {},
	dummies = {},
	blacklistedAoEUnits = {},
	delaytable = {}
}
ni.debug = {}
ni.unit = {}
ni.player = {}
ni.objectManager = {}
ni.object = {}
ni.members = {}
ni.tanks = {}
ni[unitClass] = {
    rotations = {},
    StartRotation = function()
        if (ni.vars.profiles.active ~= nil and ni.vars.profiles.active ~= "None") then
            ni[unitClass].rotations[ni.vars.profiles.active].rotation()
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