--5 - Members Table.lua
local version = "1.0.0";
local tinsert, UnitExists, UnitIsPlayer, UnitGUID, tostring, tonumber, UnitCanCooperate, UnitIsCharmed, UnitIsDeadOrGhost, tContains, GetSpellInfo, UnitDebuff, UnitClass, UnitHealth, UnitHealthMax, UnitInRange = tinsert, UnitExists, UnitIsPlayer, UnitGUID, tostring, tonumber, UnitCanCooperate, UnitIsCharmed, UnitIsDeadOrGhost, tContains, GetSpellInfo, UnitDebuff, UnitClass, UnitHealth, UnitHealthMax, UnitInRange;
ni.members = {} 
ni.tanks = {}
ni.memberSetup = {}
ni.memberSetup.cache = {} 
ni.BlacklistID = { 24099 } 
ni.metaTable1 = {} 
ni.cantheal = { 30843,41292, 55593, 45996 }
ni.BadDebuffList = {}
ni.metaTable1.__call = function(_, ...)
	if select(4, GetBuildInfo()) == 30300 then
		local group =  GetNumRaidMembers() > 0 and 'raid' or 'party';
		local groupSize = group == 'raid' and GetNumRaidMembers() or GetNumPartyMembers();
		if group == 'party' then tinsert(ni.members, ni.memberSetup:new('player')) end 
		for i=1, groupSize do 
			local groupUnit = group..i
			local groupMember = ni.memberSetup:new(groupUnit)
			if groupMember then tinsert(ni.members, groupMember) end 
		end
	else
		local group =  IsInRaid() and 'raid' or 'party';
		local groupSize = IsInRaid() and GetNumGroupMembers() or GetNumGroupMembers() - 1;
		if group == 'party' then tinsert(ni.members, ni.memberSetup:new('player')) end 
		for i=1, groupSize do 
			local groupUnit = group..i
			local groupMember = ni.memberSetup:new(groupUnit)
			if groupMember then tinsert(ni.members, groupMember) end 
		end	
	end
end
ni.metaTable1.__index =  {
    name = 'members',author = 'bubba',
}
ni.memberSetup.__index = {
	unit = 'noob',name = 'noob',
	class = 'noob',
	guid = 0,
	guidsh = 0,
	role = 'NOOB',
	range = false,
	dispel = false,
	hp = 100,
	threat = 0,
	target = 'noobtarget',
	isTank = false
}
ni.updateHealingTable = CreateFrame('frame', nil)
ni.updateHealingTable:RegisterEvent('PARTY_MEMBERS_CHANGED')
ni.updateHealingTable:RegisterEvent('RAID_ROSTER_UPDATE')
ni.updateHealingTable:RegisterEvent('GROUP_ROSTER_UPDATE')
ni.updateHealingTable:RegisterEvent('PARTY_CONVERTED_TO_RAID')
ni.updateHealingTable:RegisterEvent('ZONE_CHANGED')
ni.updateHealingTable:RegisterEvent('PLAYER_ENTERING_WORLD')
ni.updateHealingTable:SetScript('OnEvent', function()
	table.wipe(ni.members);
	table.wipe(ni.memberSetup.cache);
	ni.SetupTables()
end)
local function Nova_GUID(unit)
	local nShortHand = ''
	local targetGUID;
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
	for i=1, #ni.BadDebuffList do
		if ni.unit.debuff(tar, ni.BadDebuffList[i]) then
			return false
		end
	end
	return true
end
local function CheckCreatureType(tar)
	local CreatureTypeList = {'Critter','Totem', 'Non-combat Pet', 'Wild Pet'}
	for i=1, #CreatureTypeList do
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
	if (( UnitCanCooperate('player',tar) and not UnitIsCharmed(tar) and not UnitIsDeadOrGhost(tar) and ni.unit.exists(tar)) or UnitIsUnit('player', tar) )
	 and CheckBadDebuff(tar)
	 and CheckCreatureType(tar)
	then return true else return false end
end
ni.UnitDispel = {
    druid = { 'Curse' },
	shaman = { 'Disease', 'Poison', 'Curse' },
	paladin = { 'Poison', 'Disease', 'Magic'},
	priest = { 'Magic', 'Disease' },
	mage = { 'Curse' }
}
local function DebuffBlacklistCheck(id)
	if tContains(ni.BlacklistID, id) then
		return false
	end
	return true
end
ni.addblacklistdebuff = function(id)
	if not tContains(ni.BlacklistID, id) then
		tinsert(ni.BlacklistID, id);
	end
end
ni.dontdispel = function(t)
	for i = 1, #ni.BlacklistID do
		if UnitDebuff(t, GetSpellInfo(ni.BlacklistID[i])) then
			return true;
		end
	end
	return false;
end
ni.ValidDispel = function(t)
	local HasValidDispel = false
	local i = 1
	local debuff = UnitDebuff(t, i)
	if ni.dontdispel(t) then return false end
    local _, class = UnitClass('player')
	while debuff do
		local debuffType = select(5, UnitDebuff(t, i))
		if class == 'PALADIN' then
			if tContains(ni.UnitDispel.paladin, debuffType) then
				HasValidDispel = true
                break;
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		elseif class == 'SHAMAN' then
			if tContains(ni.UnitDispel.shaman, debuffType) then
				HasValidDispel = true
                break;
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		elseif class == 'PRIEST' then
			if tContains(ni.UnitDispel.priest, debuffType) then
				HasValidDispel = true
                break;
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		elseif class == 'DRUID' then
			if tContains(ni.UnitDispel.druid, debuffType) then
				HasValidDispel = true
                break;
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		end
	end	
	return HasValidDispel
end
function ni.memberSetup:new(unit)
	if ni.memberSetup.cache[select(2, Nova_GUID(unit))] then return false end
	local o = {}
	setmetatable(o, ni.memberSetup)
	if unit and type(unit) == 'string' then
		o.unit = unit
	end
	function o:IsTank()
		local result = false;
		if select(2, UnitClass(o.unit)) == 'WARRIOR' and ni.unit.hasaura(o.guid, 71) then
			result = true;
		end
		if select(2, UnitClass(o.unit)) == 'DRUID' and ni.unit.buff(o.unit, 9634) then
			result = true;
		end
		if ni.unit.hasaura(o.guid, 57340) then
			result = true;
		end
		return result;
	end
	function o:hasdebufftype(str)
		return ni.unit.hasdebufftype(o.guid, str);
	end
	function o:hasbufftype(str)
		return ni.unit.hasbufftype(o.guid, str);
	end
	function o:Dispel()
		local nDebuffList = {};
		local dispelthem = false;
        local _, class = UnitClass('player');
		if class == 'DRUID' then
			local k=1
			while UnitDebuff(o.unit, k) do
				local nDebuff = UnitDebuff(o.unit, k)
				if ni.ValidDispel(o.unit) then
					dispelthem = true;
                    break;
				end
				k=k+1
			end
		elseif class == 'SHAMAN' then
			local k=1
			while UnitDebuff(o.unit, k) do
				local nDebuff = UnitDebuff(o.unit, k)
				if ni.ValidDispel(o.unit) then
					dispelthem = true;
                    break;
				end
				k=k+1
			end
		elseif class == 'PALADIN' then
			local k=1
			while UnitDebuff(o.unit, k) do
				local nDebuff = UnitDebuff(o.unit, k)
				if ni.ValidDispel(o.unit) then
					dispelthem = true;
                    break;
				end
				k=k+1
			end
		elseif class == 'PRIEST' then
			local k=1
			while UnitDebuff(o.unit, k) do
				local nDebuff = {UnitDebuff(o.unit, k)}
				if ni.ValidDispel(o.unit) then
					dispelthem = true;
                    break;
				end
				k=k+1
			end
		end
		if dispelthem == true then
			return true
		end
		return false
	end
	function o:CalcHP()
		local Percent = 100*UnitHealth(o.unit)/UnitHealthMax(o.unit)
		local Actual = ( UnitHealthMax(o.unit) - UnitHealth(o.unit) )
		if o.role == 'TANK' then Percent = Percent - 5 end 
		if UnitIsDeadOrGhost(o.unit) == 1 then Percent = 250 end 
		if o.dispel then Percent = Percent - 2 end 
		for i = 1, #ni.cantheal do
			if ni.unit.debuff(o.unit, ni.cantheal[i]) then
				Percent = 100;
				Actual = UnitHealthMax(o.unit)
			end
		end
		return Percent, Actual
	end
	function o:nGUID()
		local nSH = nil
		local targetGUID;
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
	function o:RangeCheck()
		local range = false
		if ni.unit.exists(o.guid) and ni.spell.los(o.guid) then
			local dist = ni.player.distance(o.guid);
			if(dist ~= nil and dist < 40)then
				range = true
			else
				range = false
			end
		end
		return range
	end
	function o:UpdateUnit()
		o.name = UnitName(o.unit)
		o.class = select(2, UnitClass(o.unit))
		o.guid = o:nGUID()
		o.guidsh = select(2, o:nGUID())
		o.range = o:RangeCheck()
		o.dispel = o:Dispel()
		o.hp = o:CalcHP()
		o.threat = ni.unit.threat(o.unit)
		o.target = tostring(o.unit)..'target'
		o.isTank = o:IsTank()
		ni.memberSetup.cache[select(2, Nova_GUID(o.unit))] = o
	end
	ni.memberSetup.cache[select(2, o:nGUID())] = o
	return o
end
function ni.SetupTables() 
	setmetatable(ni.members, ni.metaTable1) 
	function ni.members:Update(MO)
		local MouseoverCheck = MO or true
		for i=1, #ni.members do
			ni.members[i]:UpdateUnit()
		end
		table.sort(ni.members, function(x,y)
			if x.range and y.range then return x.hp < y.hp
			elseif x.range then return true
			elseif y.range then return false
			else return x.hp < y.hp end
		end)
	end
	ni.members()
end
ni.SetupTables()
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
		if ni.spell.ValidTotemDispel(ni.members[i].unit) then
			DispelNumbers = DispelNumbers + 1
		end
	end
	return DispelNumbers
end
ni.Tanks = function()
  if ni.vars.units.mainTankEnabled and ni.vars.units.offTankEnabled then
    return ni.vars.units.mainTank, ni.vars.units.offTank
  end
  local tanks = {}
  for i=1, #ni.members do
	if ni.members[i].isTank then
      tinsert(tanks, { unit = ni.members[i].unit, health = UnitHealthMax(ni.members[i].unit) })
	end
  end
  if #tanks > 1 then
    table.sort(tanks, function(x,y)
      return x.health > y.health
    end)
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
        return tanks[1].unit, 'focus'
    end
  end
  if ni.vars.units.mainTankEnabled then
    return ni.vars.units.mainTank, 'focus'
  elseif ni.vars.units.offTankEnabled then
    return 'focus', ni.vars.units.offTank
  else
    return 'focus'
  end
end
ni.AverageHealth = function(n) 
	local NumberOfPeople = n
	local Vasa_Average = 0
	if #ni.members < NumberOfPeople then
		for i=NumberOfPeople, 0, -1 do
			if #ni.members >= i then
				NumberOfPeople = i
				break
			end
		end
	end
	for i=1, NumberOfPeople do
		Vasa_Average = Vasa_Average + ni.members[i].hp 
	end
	Vasa_Average = Vasa_Average / NumberOfPeople
	return Vasa_Average, NumberOfPeople
end