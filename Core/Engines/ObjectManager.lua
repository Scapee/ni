local UnitName, UnitGUID, UnitPower, UnitPowerMax, UnitAffectingCombat, GetTime, UnitCanAssist, UnitCanAttack =
	UnitName,
	UnitGUID,
	UnitPower,
	UnitPowerMax,
	UnitAffectingCombat,
	GetTime,
	UnitCanAssist,
	UnitCanAttack

	
local objectsetup = {}
local cache = {}
cache.__index = {
	guid = 0,
	name = "Unknown",
	type = 0
}

ni.objectmanager = {
	get = function()
		return ni.functions.getobjects()
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
	end,
	onupdate = function(self, elapsed)
		if ni.objects ~= nil and ni.functions.getOM ~= nil then
			local throttle = 1 / GetFramerate()
			self.st = elapsed + (self.st or 0)
			if self.st > throttle then
				self.st = 0
				local tmp = ni.objectmanager.get()
				for i = 1, #tmp do
					local ob = ni.objectsetup:new(tmp[i].guid, tmp[i].type, tmp[i].name)
					if ob then
						rawset(ni.objects, tmp[i].guid, ob)
					end
				end
				ni.objects:updateobjects()
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
				if cache[guid] ~= nil then
					return cache[guid]
				end
				local _, _, _, _, otype = ni.unit.info(guid)
				local name = UnitName(guid)
				local ob = ni.objectsetup:get(guid, otype, name)
				return ob
			end
			return ni.objectsetup:get(0, 0, "Unknown")
		end
	}
)
function ni.objectsetup:get(objguid, objtype, objname)
	if cache[objguid] then
		return cache[objguid]
	else
		return ni.objectsetup:create(objguid, objtype, objname)
	end
end
function ni.objectsetup:create(objguid, objtype, objname)
	local o = {}
	setmetatable(o, ni.objectsetup)
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
		return ni.power.currentpercent(o.guid, t);
	end
	function o:unit()
		return o.type == 3
	end
	function o:player()
		return o.type == 4
	end
	function o:powermax(t)
		return ni.power.max(o.guid, t);
	end
	function o:canattack(tar)
		local t = true and tar or "player"
		return (UnitCanAttack(t, o.guid) == 1)
	end
	function o:canassist(tar)
		local t = true and tar or "player"
		return (UnitCanAssist(t, o.guid) == 1)
	end
	function o:los(tar)
		local t = true and tar or "player"
		return ni.unit.los(o.guid, t)
	end
	function o:cast(spell)
		ni.spell.cast(spell, o.guid)
	end
	function o:castat(spell)
		if ni.spell.los(o.guid) then
			ni.spell.castat(spell, o.guid)
		end
	end
	function o:combat()
		return (UnitAffectingCombat(o.guid) ~= nil)
	end
	function o:isbehind(tar, rev)
		local t = true and tar or "player"
		if rev ~= nil then
			return ni.unit.isbehind(t, o.guid)
		end
		return ni.unit.isbehind(o.guid, t)
	end
	function o:isfacing(tar, rev)
		local t = true and tar or "player"
		if rev ~= nil then
			return ni.unit.isfacing(t, o.guid)
		end
		return ni.unit.isfacing(o.guid, t)
	end
	function o:distance(tar)
		local t = true and tar or "player"
		return ni.unit.distance(o.guid, t)
	end
	function o:range(tar)
		local dist = o:distance(tar);
		return (dist < 40) and true or false;
	end
	function o:creator()
		return ni.unit.creator(o.guid)
	end
	function o:target()
		local t = select(6, ni.unit.info(o.guid))
		return t;
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
	function o:calculatettd()
		ni.ttd.calculate(o)
	end
	function o:updateobject()
		o.guid = o.guid
		o.name = o.name ~= "Unknown" and o.name or UnitName(o.guid)
		o.type = o.type
		o:calculatettd()
	end
	cache[objguid] = o
	return o
end
function ni.objectsetup:new(objguid, objtype, objname)
	if cache[objguid] then
		return false
	end
	return ni.objectsetup:create(objguid, objtype, objname)
end
function ni.objects:updateobjects()
	for k, v in pairs(ni.objects) do
		if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
			if v.lastupdate == nil or GetTime() >= (v.lastupdate + (math.random(1, 12) / 100)) then
				v.lastupdate = GetTime()
				if not v:exists() then
					ni.objectsetup.cache[k] = nil
					ni.objects[k] = nil
				else
					v:updateobject()
				end
			end
		end
	end
end
