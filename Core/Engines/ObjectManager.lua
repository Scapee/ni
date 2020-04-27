local UnitName, UnitGUID, UnitPower, UnitPowerMax, UnitAffectingCombat, GetTime, UnitCanAssist, UnitCanAttack =
	UnitName,
	UnitGUID,
	UnitPower,
	UnitPowerMax,
	UnitAffectingCombat,
	GetTime,
	UnitCanAssist,
	UnitCanAttack

ni.objectManager = {
	Get = function()
		return ni.functions.GetOM()
	end,
	Contains = function(o)
		local tmp = UnitName(o)

		if tmp ~= nil then
			o = tmp
		end
		for k, v in pairs(ni.objects) do
			if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
				if v.name == o then
					return true
				end
			end
		end
		return false
	end,
	ObjectGUID = function(o)
		if tonumber(o) ~= nil then
			return o
		else
			local tmp = UnitName(o)
			if tmp ~= nil then
				o = tmp
			end
			for k, v in pairs(ni.objects) do
				if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
					if v.name == o then
						return k
					end
				end
			end
		end
	end
}

setmetatable(
	ni.objects,
	{
		__index = function(t, k)
			local guid = true and UnitGUID(k) or nil
			if guid ~= nil then
				if ni.objectSetup.cache[guid] ~= nil then
					return ni.objectSetup.cache[guid]
				end
				local _, _, _, _, otype = ni.unit.Info(guid)
				local name = UnitName(guid)
				local ob = ni.objectSetup:get(guid, otype, name)
				return ob
			end
			return ni.objectSetup:get(0, 0, "Unknown")
		end
	}
)
ni.objectSetup = {}
ni.objectSetup.cache = {}
ni.objectSetup.__index = {
	guid = 0,
	name = "Unknown",
	type = 0
}
function ni.objectSetup:Get(objguid, objtype, objname)
	if ni.objectSetup.cache[objguid] then
		return ni.objectSetup.cache[objguid]
	else
		return ni.objectSetup:Create(objguid, objtype, objname)
	end
end
function ni.objectSetup:Create(objguid, objtype, objname)
	local o = {}
	setmetatable(o, ni.objectSetup)
	if objguid then
		o.guid = objguid
		o.name = objname
		o.type = objtype
	end
	function o:Exists()
		return ni.unit.Exists(o.guid)
	end
	function o:Info()
		return ni.unit.Info(o.guid)
	end
	function o:Hp()
		return ni.unit.Hp(o.guid)
	end
	function o:Power(t)
		return ni.power.CurrentPercent(o.guid)
	end
	function o:Unit()
		return o.type == 3
	end
	function o:Player()
		return o.type == 4
	end
	function o:PowerMax(t)
		return ni.power.Max(o.guid)
	end
	function o:CanAttack(tar)
		local t = true and tar or "player"
		return (UnitCanAttack(t, o.guid) == 1)
	end
	function o:CanAssist(tar)
		local t = true and tar or "player"
		return (UnitCanAssist(t, o.guid) == 1)
	end
	function o:LoS(tar)
		local t = true and tar or "player"
		return ni.unit.LoS(o.guid, t)
	end
	function o:Cast(spell)
		ni.spell.Cast(spell, o.guid)
	end
	function o:CastAt(spell)
		if ni.spell.LoS(o.guid) then
			ni.spell.CastAt(spell, o.guid)
		end
	end
	function o:Combat()
		return (UnitAffectingCombat(o.guid) ~= nil)
	end
	function o:IsBehind(tar, rev)
		local t = true and tar or "player"

		if rev ~= nil then
			return ni.unit.IsBehind(t, o.guid)
		end

		return ni.unit.IsBehind(o.guid, t)
	end
	function o:IsFacing(tar, rev)
		local t = true and tar or "player"

		if rev ~= nil then
			return ni.unit.IsFacing(t, o.guid)
		end

		return ni.unit.IsFacing(o.guid, t)
	end
	function o:Distance(tar)
		local t = true and tar or "player"
		return ni.unit.Distance(o.guid, t)
	end
	function o:Range(tar)
		return ni.unit.HasReach(tar)
	end
	function o:Creator()
		return ni.unit.Creator(o.guid)
	end
	function o:Target()
		return select(6, ni.unit.Info(o.guid))
	end
	function o:Location()
		local x, y, z, r = ni.unit.Info(o.guid)
		local t = {
			X = x,
			Y = y,
			Z = z,
			R = r
		}
		return t
	end
	function o:CalculateTtd()
		ni.ttd.Calculate(o)
	end
	function o:UpdateObject()
		local _, _, _, _, obtype = ni.unit.Info(o.guid)
		o.guid = o.guid
		o.name = o.name ~= "Unknown" and o.name or UnitName(o.guid)
		o.type = o.type
		o:CalculateTtd()
	end
	ni.objectSetup.cache[objguid] = o
	return o
end
function ni.objectSetup:New(objguid, objtype, objname)
	if ni.objectSetup.cache[objguid] then
		return false
	end
	return ni.objectSetup:Create(objguid, objtype, objname)
end
function ni.objects:UpdateObjects()
	for k, v in pairs(ni.objects) do
		if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
			if v.lastupdate == nil or GetTime() >= (v.lastupdate + (math.random(1, 12) / 100)) then
				v.lastupdate = GetTime()
				if not v:Exists() then
					ni.objectSetup.cache[k] = nil
					ni.objects[k] = nil
				else
					v:UpdateObject()
				end
			end
		end
	end
end
