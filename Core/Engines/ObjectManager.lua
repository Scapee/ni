local UnitName, UnitGUID, UnitPower, UnitPowerMax, UnitAffectingCombat, GetTime, UnitCanAssist, UnitCanAttack =
	unitName,
	unitGUID,
	unitPower,
	unitPowerMax,
	unitAffectingCombat,
	getTime,
	unitCanAssist,
	unitCanAttack

ni.objectManager = {
	get = function()
		return ni.functions.getOM()
	end,
	contains = function(o)
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
	objectGUID = function(o)
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
				local _, _, _, _, otype = ni.unit.info(guid)
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
function ni.objectSetup:get(objguid, objtype, objname)
	if ni.objectSetup.cache[objguid] then
		return ni.objectSetup.cache[objguid]
	else
		return ni.objectSetup:create(objguid, objtype, objname)
	end
end
function ni.objectSetup:create(objguid, objtype, objname)
	local o = {}
	setmetatable(o, ni.objectSetup)
	if objguid then
		o.guid = objguid
		o.name = objname
		o.type = objtype
	end
	function o:exists()
		return ni.unit.exists(o.guid)
	end
	function o:info()
		return ni.unit.info(o.guid)
	end
	function o:hp()
		return ni.unit.hp(o.guid)
	end
	function o:power(t)
		return ni.power.currentPercent(o.guid)
	end
	function o:unit()
		return o.type == 3
	end
	function o:player()
		return o.type == 4
	end
	function o:powerMax(t)
		return ni.power.max(o.guid)
	end
	function o:canAttack(tar)
		local t = true and tar or "player"
		return (UnitCanAttack(t, o.guid) == 1)
	end
	function o:canAssist(tar)
		local t = true and tar or "player"
		return (UnitCanAssist(t, o.guid) == 1)
	end
	function o:loS(tar)
		local t = true and tar or "player"
		return ni.unit.loS(o.guid, t)
	end
	function o:cast(spell)
		ni.spell.cast(spell, o.guid)
	end
	function o:castAt(spell)
		if ni.spell.loS(o.guid) then
			ni.spell.castAt(spell, o.guid)
		end
	end
	function o:combat()
		return (UnitAffectingCombat(o.guid) ~= nil)
	end
	function o:isBehind(tar, rev)
		local t = true and tar or "player"

		if rev ~= nil then
			return ni.unit.isBehind(t, o.guid)
		end

		return ni.unit.isBehind(o.guid, t)
	end
	function o:isFacing(tar, rev)
		local t = true and tar or "player"

		if rev ~= nil then
			return ni.unit.isFacing(t, o.guid)
		end

		return ni.unit.isFacing(o.guid, t)
	end
	function o:distance(tar)
		local t = true and tar or "player"
		return ni.unit.distance(o.guid, t)
	end
	function o:range(tar)
		return ni.unit.hasReach(tar)
	end
	function o:creator()
		return ni.unit.creator(o.guid)
	end
	function o:target()
		return select(6, ni.unit.info(o.guid))
	end
	function o:location()
		local x, y, z, r = ni.unit.info(o.guid)
		local t = {
			x = x,
			y = y,
			z = z,
			r = r
		}
		return t
	end
	function o:calculateTtd()
		ni.ttd.calculate(o)
	end
	function o:updateObject()
		local _, _, _, _, obtype = ni.unit.info(o.guid)
		o.guid = o.guid
		o.name = o.name ~= "Unknown" and o.name or UnitName(o.guid)
		o.type = o.type
		o:calculateTtd()
	end
	ni.objectSetup.cache[objguid] = o
	return o
end
function ni.objectSetup:new(objguid, objtype, objname)
	if ni.objectSetup.cache[objguid] then
		return false
	end
	return ni.objectSetup:create(objguid, objtype, objname)
end
function ni.objects:updateObjects()
	for k, v in pairs(ni.objects) do
		if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
			if v.lastupdate == nil or GetTime() >= (v.lastupdate + (math.random(1, 12) / 100)) then
				v.lastupdate = GetTime()
				if not v:exists() then
					ni.objectSetup.cache[k] = nil
					ni.objects[k] = nil
				else
					v:updateObject()
				end
			end
		end
	end
end
