local unitClass = unitClass

local _, _class = unitClass("player")

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
    startRotation = function()
        if (ni.vars.profiles.active ~= nil and ni.vars.profiles.active ~= "None") then
            ni[_class].rotations[ni.vars.profiles.active].start()
        end
    end
}
ni.functions = {
	addLog = %%AddLog%%,
	popup = %%PopUp%%,
	loadLua = %%LoadFile%%,
	test = %%Test%%,
	objectExists = %%ObjectExists%%,
	los = %%LoS%%,
	unitCreator = %%UnitCreator%%,
	creatureType = %%CreatureType%%,
	combatReach = %%CombatReach%%,
	unitFlags = %%UnitFlags%%,
	unitDynamicFlags = %%UnitDynamicFlags%%,
	objectInfo = %%ObjectInfo%%,
	isFacing = %%IsFacing%%,
	getDistance = %%GetDistance%%,
	isBehind = %%IsBehind%%,
	hasAura = %%HasAura%%,
	moveTo = %%MoveTo%%,
	clickAt = %%ClickAt%%,
	stopMoving = %%StopMoving%%,
	lookAt = %%LookAt%%,
	setTarget = %%SetTarget%%,
	runText = %%RunText%%,
	item = %%Item%%,
	inventoryItem = %%InventoryItem%%,
	interact = %%Interact%%,
	cast = %%Cast%%,
	getSpellID = %%GetSpellID%%,
	stopCasting = %%StopCasting%%,
	getObjectManager = %%GetOM%%
}