--6 - Object Manager.lua
local version = "1.0.0";
local tinsert, tremove, GetTime, tonumber, UnitReaction, UnitName, rawset, UnitIsDeadOrGhost, UnitHealth, UnitHealthMax = tinsert, tremove, GetTime, tonumber, UnitReaction, UnitName, rawset, UnitIsDeadOrGhost, UnitHealth, UnitHealthMax;
ni.object = { };
ni.om = {
	get = function()
		return ni.functions.getom();
	end,
	contains = function(o)
		local tmp = UnitName(o);
		if tmp ~= nil then
			o = tmp;
		end
		for k, v in pairs(ni.object) do
			if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
				if v.name == o then
					return true;
				end
			end
		end
		return false;
	end,
	oGUID = function(o)
		if tonumber(o) ~= nil then
			return o;
		else
			local tmp = UnitName(o);
			if tmp ~= nil then
				o = tmp;
			end
			for k, v in pairs(ni.object) do
				if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
					if v.name == o then
						return k;
					end
				end
			end
		end
	end
}
setmetatable(ni.object,{
	__index = function(t, k)
		local guid = true and UnitGUID(k) or nil;
		if guid ~= nil then
			if ni.objectSetup.cache[guid] ~= nil then
				return ni.objectSetup.cache[guid];
			end
			local _, _, _, _, otype = ni.unit.info(guid);
			local name = UnitName(guid);
			local ob = ni.objectSetup:get(guid, otype, name);
			return ob;
		end
		return ni.objectSetup:get(0, 0, "Unknown");
	end});
ni.objectSetup = { };
ni.objectSetup.cache = { };
ni.objectSetup.__index = {
	guid = 0,
	name = "Unknown",
	type = 0,
};
local _powerTypes = {
	mana = 0,
	rage = 1,
	focus = 2,
	energy = 3,
	combopoints = 4,
	runes = 5,
	runicpower = 6,
	soulshards = 7,
	eclipse = 8,
	holy = 9,
	alternate = 10,
	darkforce = 11,
	chi = 12,
	shadoworbs = 13,
	burningembers = 14,
	demonicfury = 15
};
function ni.objectSetup:get(objguid, objtype, objname)
	if ni.objectSetup.cache[objguid] then
		return ni.objectSetup.cache[objguid]
	else
		return ni.objectSetup:create(objguid, objtype, objname)
	end
end;
function ni.objectSetup:create(objguid, objtype, objname)
	local o = { };
	setmetatable(o, ni.objectSetup);
	if objguid then
		o.guid = objguid;
		o.name = objname;
		o.type = objtype;
	end
	function o:exists()
		return ni.unit.exists(o.guid);
	end
	function o:info()
		return ni.unit.info(o.guid);
	end
	function o:hp()
		return (100 * UnitHealth(o.guid)/UnitHealthMax(o.guid));
	end
	function o:power(t)
		if tonumber(t) == nil then
			t = _powerTypes[t];
		end
		return UnitPower(o.guid, t);
	end
	function o:unit()
		return o.type == 3
	end
	function o:player()
		return o.type == 4
	end
	function o:powermax(t)
		if tonumber(t) == nil then
			t = _powerTypes[t];
		end
		return UnitPowerMax(o.guid, t);
	end
	function o:canattack(tar)
		local t = true and tar or "player";
		return (UnitCanAttack(t, o.guid) == 1);
	end
	function o:canassist(tar)
		local t = true and tar or "player";
		return (UnitCanAssist(t, o.guid) == 1);
	end
	function o:los(tar)
		local t = true and tar or "player";
		return ni.unit.los(o.guid, t);
	end
	function o:cast(spell)
		ni.spell.cast(spell, o.guid);
	end
	function o:castat(spell)
		if ni.spell.los(o.guid) then
			ni.spell.castat(spell, o.guid);
		end
	end
	function o:combat()
		return (UnitAffectingCombat(o.guid) ~= nil);
	end
	function o:behind(tar, rev)
		local t = true and tar or "player";
		if rev ~= nil then
			return ni.unit.isbehind(t, o.guid);
		end
		return ni.unit.isbehind(o.guid, t);
	end
	function o:facing(tar, rev)
		local t = true and tar or "player";
		if rev ~= nil then
			return ni.unit.isfacing(t, o.guid);
		end
		return ni.unit.isfacing(o.guid, t);
	end
	function o:distance(tar)
		local t = true and tar or "player";
		return ni.unit.distance(o.guid, t);
	end
	function o:range(tar)
		local dist = o:distance(tar);
		return (dist < 40) and true or false;
	end
	function o:creator()
		return ni.unit.creator(o.guid);
	end
	function o:target()
		local t =  select(6, ni.unit.info(o.guid));
		return t;
	end
	function o:location()
		local x, y, z, r = ni.unit.info(o.guid);
		local t = {
			X = x,
			Y = y,
			Z = z,
			R = r }
		return t;
	end
	function o:calculatettd()
		if (o:unit() or o:player()) and o:canattack() and not UnitIsDeadOrGhost(o.guid) and o:combat() then
			if o.timeincombat == nil then
			  o.timeincombat = GetTime()
			end

			local currenthp = UnitHealth(o.guid)
			local maxhp = UnitHealthMax(o.guid)
			local diff = maxhp - currenthp
			local duration = GetTime() - o.timeincombat
			local _dps = diff / duration
			local death = 0

			if _dps ~= 0 then
			  death = math.max(0, currenthp) / _dps
			else
			  death = 0
			end
			o.dps = math.floor(_dps)

			if death == math.huge then
			  o.ttd = -1
			elseif death < 0 then
			  o.ttd = 0
			else
			  o.ttd = death
			end
			if maxhp - currenthp == 0 then
			  o.ttd = -1
			end
		end
	end
	function o:UpdateObject()
		local _, _, _, _, obtype = ni.unit.info(o.guid);
		o.guid = o.guid;
		o.name = o.name ~= "Unknown" and o.name or UnitName(o.guid);
		o.type = o.type;
		o:calculatettd()
	end
	ni.objectSetup.cache[objguid] = o;
	return o;
end;
function ni.objectSetup:new(objguid, objtype, objname)
	if ni.objectSetup.cache[objguid] then return false end
	return ni.objectSetup:create(objguid, objtype, objname);
end;
function ni.object:UpdateObjects()
	for k, v in pairs(ni.object) do
		if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
			if v.lastupdate == nil or GetTime() >= (v.lastupdate + (math.random(1,12)/100)) then
				v.lastupdate = GetTime();
				if not v:exists() then
					ni.objectSetup.cache[k] = nil
					ni.object[k] = nil;
				else
					v:UpdateObject()
				end
			end
		end
	end
end;
ni.objframe = CreateFrame('frame');
ni.objframe:SetScript("OnUpdate", function(self, elapsed)
	if ni.object ~= nil and ni.functions.getom ~= nil then
		local throttle = 1/GetFramerate();
		self.st = elapsed + (self.st or 0);
		if self.st > throttle then
			self.st = 0;
			local tmp = ni.om.get();
			for i = 1, #tmp do
				local ob = ni.objectSetup:new(tmp[i].guid, tmp[i].type, tmp[i].name);
				if ob then 
					rawset(ni.object, tmp[i].guid, ob)
				end
			end
			ni.object:UpdateObjects();
		end
	end
end);