local GetNumRaidMembers, GetNumPartyMembers, IsInRaid, GetNumGroupMembers, tinsert

ni.memberSetup = {}
ni.memberSetup.cache = {}
ni.blacklistID = {24099}
ni.metaTable1 = {}
ni.cantheal = {30843, 41292, 55593, 45996}
ni.badDebuffList = {}
ni.metaTable1.__call = function(_, ...)
	if ni.vars.build == 30300 then
		local group = GetNumRaidMembers() > 0 and "raid" or "party"
		local groupSize = group == "raid" and GetNumRaidMembers() or GetNumPartyMembers()
		if group == "party" then
			tinsert(ni.members, ni.memberSetup:new("player"))
		end
		for i = 1, groupSize do
			local groupUnit = group .. i
			local groupMember = ni.memberSetup:new(groupUnit)
			if groupMember then
				tinsert(ni.members, groupMember)
			end
		end
	else
		local group = IsInRaid() and "raid" or "party"
		local groupSize = IsInRaid() and GetNumGroupMembers() or GetNumGroupMembers() - 1
		if group == "party" then
			tinsert(ni.members, ni.memberSetup:new("player"))
		end
		for i = 1, groupSize do
			local groupUnit = group .. i
			local groupMember = ni.memberSetup:new(groupUnit)
			if groupMember then
				tinsert(ni.members, groupMember)
			end
		end
	end
end
ni.metaTable1.__index = {
	name = "members",
	author = "bubba"
}
ni.memberSetup.__index = {
	unit = "noob",
	name = "noob",
	class = "noob",
	guid = 0,
	guidsh = 0,
	role = "NOOB",
	range = false,
	dispel = false,
	hp = 100,
	threat = 0,
	target = "noobtarget",
	isTank = false
}
local function Nova_GUID(unit)
	local nShortHand = ""
	local targetGUID
	if UnitExists(unit) then
		if UnitIsPlayer(unit) then
			targetGUID = UnitGUID(unit)
		else
			targetGUID = tonumber((UnitGUID(unit)):sub(-12, -9), 16)
		end
		nShortHand = string.sub(tostring(UnitGUID(unit)), -5, -1)
	end
	return targetGUID, nShortHand
end
local function CheckBadDebuff(tar)
	for i = 1, #ni.badDebuffList do
		if ni.unit.debuff(tar, ni.badDebuffList[i]) then
			return false
		end
	end
	return true
end
local function CheckCreatureType(tar)
	local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
	for i = 1, #CreatureTypeList do
		if UnitCreatureType(tar) == CreatureTypeList[i] then
			return false
		end
	end
	if not UnitIsBattlePet(tar) and not UnitIsWildBattlePet(tar) then
		return true
	else
		return false
	end
end
local function HealCheck(tar)
	if
		((UnitCanCooperate("player", tar) and not UnitIsCharmed(tar) and not UnitIsDeadOrGhost(tar) and ni.unit.exists(tar)) or
			UnitIsUnit("player", tar)) and
			CheckBadDebuff(tar) and
			CheckCreatureType(tar)
	 then
		return true
	else
		return false
	end
end
ni.unitDispel = {
	druid = {"Curse"},
	shaman = {"Disease", "Poison", "Curse"},
	paladin = {"Poison", "Disease", "Magic"},
	priest = {"Magic", "Disease"},
	mage = {"Curse"}
}
ni.addblacklistdebuff = function(id)
	if not tContains(ni.blacklistID, id) then
		tinsert(ni.blacklistID, id)
	end
end
ni.dontdispel = function(t)
	for i = 1, #ni.blacklistID do
		if UnitDebuff(t, GetSpellInfo(ni.blacklistID[i])) then
			return true
		end
	end
	return false
end
ni.validDispel = function(t)
	local hasValidDispel = false
	local i = 1
	local debuff = UnitDebuff(t, i)
	if ni.dontdispel(t) then
		return false
	end
	local _, class = UnitClass("player")
	while debuff do
		local debuffType = select(5, UnitDebuff(t, i))
		if class == "PALADIN" then
			if tContains(ni.unitDispel.paladin, debuffType) then
				hasValidDispel = true
				break
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		elseif class == "SHAMAN" then
			if tContains(ni.unitDispel.shaman, debuffType) then
				hasValidDispel = true
				break
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		elseif class == "PRIEST" then
			if tContains(ni.unitDispel.priest, debuffType) then
				hasValidDispel = true
				break
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		elseif class == "DRUID" then
			if tContains(ni.unitDispel.druid, debuffType) then
				hasValidDispel = true
				break
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		end
	end
	return HasValidDispel
end
function ni.memberSetup:new(unit)
	if ni.memberSetup.cache[select(2, Nova_GUID(unit))] then
		return false
	end
	local o = {}
	setmetatable(o, ni.memberSetup)
	if unit and type(unit) == "string" then
		o.unit = unit
	end
	function o:isTank()
		local result = false
		if select(2, UnitClass(o.unit)) == "WARRIOR" and ni.unit.aura(o.guid, 71) then
			result = true
		end
		if select(2, UnitClass(o.unit)) == "DRUID" and ni.unit.buff(o.unit, 9634) then
			result = true
		end
		if ni.unit.aura(o.guid, 57340) then
			result = true
		end
		return result
	end
	function o:debuffType(str)
		return ni.unit.debuffType(o.guid, str)
	end
	function o:buffType(str)
		return ni.unit.buffType(o.guid, str)
	end
	function o:dispel()
		local dispelthem = false
		local _, class = UnitClass("player")
		if class == "DRUID" then
			local k = 1
			while UnitDebuff(o.unit, k) do
				if ni.validDispel(o.unit) then
					dispelthem = true
					break
				end
				k = k + 1
			end
		elseif class == "SHAMAN" then
			local k = 1
			while UnitDebuff(o.unit, k) do
				if ni.validDispel(o.unit) then
					dispelthem = true
					break
				end
				k = k + 1
			end
		elseif class == "PALADIN" then
			local k = 1
			while UnitDebuff(o.unit, k) do
				if ni.validDispel(o.unit) then
					dispelthem = true
					break
				end
				k = k + 1
			end
		elseif class == "PRIEST" then
			local k = 1
			while UnitDebuff(o.unit, k) do
				if ni.validDispel(o.unit) then
					dispelthem = true
					break
				end
				k = k + 1
			end
		end
		if dispelthem == true then
			return true
		end
		return false
	end
	function o:calculateHp()
		local Percent = 100 * UnitHealth(o.unit) / UnitHealthMax(o.unit)
		local Actual = (UnitHealthMax(o.unit) - UnitHealth(o.unit))
		if o.role == "TANK" then
			percent = Percent - 5
		end
		if UnitIsDeadOrGhost(o.unit) == 1 then
			percent = 250
		end
		if o.dispel then
			percent = Percent - 2
		end
		for i = 1, #ni.cantheal do
			if ni.unit.debuff(o.unit, ni.cantheal[i]) then
				percent = 100
				actual = UnitHealthMax(o.unit)
			end
		end
		return Percent, Actual
	end
	function o:nGUID()
		local nSH = nil
		local targetGUID
		if UnitExists(o.unit) then
			if UnitIsPlayer(o.unit) then
				targetGUID = UnitGUID(o.unit)
			else
				targetGUID = tonumber((UnitGUID(o.unit)):sub(-12, -9), 16)
			end
		end
		if string.len(tostring(targetGUID)) > 5 then
			nSH = string.sub(tostring(targetGUID), -5, -1)
		else
			nSH = tostring(targetGUID)
		end
		return targetGUID, nSH
	end
	function o:rangeCheck()
		local range = false
		if ni.unit.exists(o.guid) and ni.spell.loS(o.guid) then
			local dist = ni.player.distance(o.guid)
			if (dist ~= nil and dist < 40) then
				range = true
			else
				range = false
			end
		end
		return range
	end
	function o:updateUnit()
		o.name = UnitName(o.unit)
		o.class = select(2, UnitClass(o.unit))
		o.guid = o:nGUID()
		o.guidsh = select(2, o:nGUID())
		o.range = o:rangeCheck()
		o.dispel = o:dispel()
		o.hp = o:calculateHp()
		o.threat = ni.unit.threat(o.unit)
		o.target = tostring(o.unit) .. "target"
		o.isTank = o:isTank()
		ni.memberSetup.cache[select(2, Nova_GUID(o.unit))] = o
	end
	ni.memberSetup.cache[select(2, o:nGUID())] = o
	return o
end
function ni.setupTables()
	setmetatable(ni.members, ni.metaTable1)
	function ni.members:update(MO)
		local MouseoverCheck = MO or true
		for i = 1, #ni.members do
			ni.members[i]:updateUnit()
		end
		table.sort(
			ni.members,
			function(x, y)
				if x.range and y.range then
					return x.hp < y.hp
				elseif x.range then
					return true
				elseif y.range then
					return false
				else
					return x.hp < y.hp
				end
			end
		)
	end
	ni.members()
end
ni.setupTables()
ni.missingcount = function()
	local total = 0
	for i = 1, #ni.members do
		if ni.members[i].hp < 100 then
			total = total + 1
		end
	end
	return total
end
ni.numberbelow = function(n)
	local total = 0
	for i = 1, #ni.members do
		if ni.members[i].hp < n then
			total = total + 1
		end
	end
	return total
end
ni.totemdispelcount = function()
	local DispelNumbers = 0
	for i = 1, #ni.members do
		if ni.spell.validTotemDispel(ni.members[i].unit) then
			dispelNumbers = DispelNumbers + 1
		end
	end
	return DispelNumbers
end
ni.tanks = function()
	if ni.vars.units.mainTankEnabled and ni.vars.units.offTankEnabled then
		return ni.vars.units.mainTank, ni.vars.units.offTank
	end
	local tanks = {}
	for i = 1, #ni.members do
		if ni.members[i].isTank then
			tinsert(tanks, {unit = ni.members[i].unit, health = UnitHealthMax(ni.members[i].unit)})
		end
	end
	if #tanks > 1 then
		table.sort(
			tanks,
			function(x, y)
				return x.health > y.health
			end
		)
		if ni.vars.units.mainTankEnabled or ni.vars.units.offTankEnabled then
			if ni.vars.units.offTankEnabled and not ni.vars.units.mainTankEnabled then
				return tanks[1].unit, ni.vars.units.offTank
			elseif ni.vars.units.mainTankEnabled and not ni.vars.units.offTankEnabled then
				return ni.vars.units.mainTank, tanks[1].unit
			else
				return tanks[1].unit, tanks[2].unit
			end
		end
	end
	if #tanks == 1 then
		if ni.vars.units.offTankEnabled and not ni.vars.units.mainTankEnabled then
			return tanks[1].unit, ni.vars.units.offTank
		elseif ni.vars.units.mainTankEnabled and not ni.vars.units.offTankEnabled then
			return ni.vars.units.mainTank, tanks[1].unit
		else
			return tanks[1].unit, "focus"
		end
	end
	if ni.vars.units.mainTankEnabled then
		return ni.vars.units.mainTank, "focus"
	elseif ni.vars.units.offTankEnabled then
		return "focus", ni.vars.units.offTank
	else
		return "focus"
	end
end
ni.averageHealth = function(n)
	local NumberOfPeople = n
	local Vasa_Average = 0
	if #ni.members < NumberOfPeople then
		for i = NumberOfPeople, 0, -1 do
			if #ni.members >= i then
				numberOfPeople = i
				break
			end
		end
	end
	for i = 1, NumberOfPeople do
		vasa_Average = Vasa_Average + ni.members[i].hp
	end
	vasa_Average = Vasa_Average / NumberOfPeople
	return Vasa_Average, NumberOfPeople
end
