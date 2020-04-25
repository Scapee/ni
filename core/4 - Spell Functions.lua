--4 - Spell Functions.lua
local version = "1.0.0";
local GetSpellCooldown, GetTime, GetRuneCooldown, GetSpellInfo, GetNetStats, tonumber, UnitExists, UnitIsDeadOrGhost, UnitCanAttack, IsSpellInRange, IsSpellKnown, UnitPower, UnitClass, GetShapeshiftForm, UnitCastingInfo, UnitChannelInfo, tContains, UnitDebuff = GetSpellCooldown, GetTime, GetRuneCooldown, GetSpellInfo, GetNetStats, tonumber, UnitExists, UnitIsDeadOrGhost, UnitCanAttack, IsSpellInRange, IsSpellKnown, UnitPower, UnitClass, GetShapeshiftForm, UnitCastingInfo, UnitChannelInfo, tContains, UnitDebuff;
ni.spell = {
	spellqueue = {},
	getid = function(s)
		if s == nil then
			return nil;
		end
		local id = ni.functions.getspellid(s);
		return (id ~= 0) and id or nil;
	end,
	cd = function(id)
		if tonumber(id) == nil then
			id = ni.spell.getid(id);
		end
		if id > 0 and IsSpellKnown(id) then
			local start, duration, enable = GetSpellCooldown(id);
			if (start > 0 and duration > 0) then
				return start + duration - GetTime();
			else
				return 0;
			end
		else
			return 0;
		end
	end,
	gcd = function()
		local _, d = GetSpellCooldown(61304);
		if (d ~= 0) then
			return true;
		else
			return false;
		end
	end,
	available = function(id, stutter)
		local stutter = true and stutter or false;
		if stutter then
			if ni.spell.gcd()
			 or ni.vars.CastStarted == true then
				return false;
			end
		end
		if tonumber(id) == nil then
			id = ni.spell.getid(id);
		end
		local result = false;
		if id ~= nil and id ~= 0 and IsSpellKnown(id) then
			local name, _, _, cost, _, powertype = GetSpellInfo(id);
			if name
			 and ((powertype == -2
			 and UnitHealth("player") >= cost)
			 or (powertype >= 0
			 and UnitPower("player", powertype) >= cost))
			 and ni.spell.cd(id) == 0 then
				result = true;
			end
		end
		return result;
	end,
	runecd = function(rune)
		local s, d, i = GetRuneCooldown(rune)
		if i == true then return false end
		if s ~= 0 then
			return true
		else
			return false
		end
	end,
	runecdremains = function(rune)
		local s, d, i = GetRuneCooldown(rune)
		if i == true then return 0 end
		if s ~= 0 then
			return s + d - GetTime()
		else
			return 0
		end
	end,
	casttime = function(spell)
		return select(7, GetSpellInfo(spell))/1000 + select(3, GetNetStats())/1000
	end,
	cast = function(...)
		local i, t = ...;
		if i == nil then
			return;
		end
		if tonumber(i) == nil then
			i = ni.spell.getid(i);
			if i == 0 then
				return;
			end
		end
		if t ~= nil then
			ni.functions.cast(i, t);
		else
			ni.functions.cast(i);
		end
	end,
	castspells = function(spells, t)
		local items = ni.splitstring(spells);
		for i = 0, #items do
			local st = items[i];
			if st ~= nil then
				local id = tonumber(st);
				if id ~= nil then
					ni.spell.cast(id, t);
				else
					ni.spell.cast(st, t);
				end
			end
		end
	end,
	castat = function(spell, t, offset)
		if spell then 
			if t == "click" then
				ni.spell.cast(spell);
				ni.player.terrainclick("click");
			elseif ni.unit.exists(t) then
				local offset = true and offset or random();
				local x, y, z = ni.unit.info(t);
				local r = offset * sqrt(random());
				local theta = random() * 360;
				local tx = x + r * cos(theta);
				local ty = y + r * sin(theta);
				ni.spell.cast(spell);
				ni.player.terrainclick(tx, ty, z);
			end
		end
	end,
	queue = function(...)
		local id, tar = ...;
		if id == nil then
			id = ni.getFrameSpellID();
		end
		if id == nil or id == 0 then
			return;
		end
		for k, v in pairs(ni.spell.spellqueue) do
			if tContains(v[2], id) then
				ni.Info.update()
				tremove(ni.spell.spellqueue, k);
				return;
			end
		end
		tinsert(ni.spell.spellqueue, {ni.spell.cast, {id, tar}});
		ni.Info.update(id, true);
	end,
	queueat = function(...)
		local id, tar = ...;
		if id == nil then
			id = ni.getFrameSpellID();
			tar = "target";
		end
		if id == nil or id == 0 then
			return;
		end
		for k, v in pairs(ni.spell.spellqueue) do
			if tContains(v[2], id) then
				ni.Info.update()
				tremove(ni.spell.spellqueue, k);
				return;
			end
		end
		if tar ~= nil then
			tinsert(ni.spell.spellqueue, {ni.spell.castat, {id, tar}});
			ni.Info.update(id, true);
		end
	end,
	stopcasting = function()
		ni.functions.stopcasting();
	end,
	los = function(...)
		local t = ...;
		if t == nil then
			return;
		end
		return ni.functions.los("player", ...);
	end,
	valid = function(t, spellid, facing, los, friendly)
		friendly = true and friendly or false;
		los = true and los or false;
		facing = true and facing or false;
		if tonumber(spellid) == nil then
			spellid = ni.spell.getid(spellid);
			if spellid == 0 then
				return false
			end
		end
		local name, rank, _, cost, isfunnel, powertype, castingtime, minrange, maxrange = GetSpellInfo(spellid);
		if ni.unit.exists(t)
		 and ((not friendly
		 and (not UnitIsDeadOrGhost(t)
		 and UnitCanAttack('player', t) == 1))
		 or friendly)
		 and IsSpellInRange(name, t) == 1
		 and IsSpellKnown(spellid)
		 and UnitPower('player', powertype) >= cost
		 and ((facing 
		 and ni.player.isfacing(t))
		 or not facing)
		 and ((los
		 and ni.spell.los(t))
		 or not los)
		 then
			return true
		else
			return false
		end
	end,
	getinterrupt = function()
		local _, class = UnitClass('player');
		local interruptSpell = 0;
		if class == 'SHAMAN' then
			interruptSpell = 57994;
		elseif class == 'WARRIOR' then
			if GetShapeshiftForm() == 3 then
				interruptSpell = 6552;
			elseif GetShapeshiftForm() == 2 then
				interruptSpell = 72;
			end
		elseif class == 'PRIEST' then
			interruptSpell = 15487;
		elseif class == 'DEATHKNIGHT' then
			interruptSpell = 47528;
		elseif class == 'ROGUE' then
			interruptSpell = 1766;
		elseif class == 'MAGE' then
			interruptSpell = 2139;
		elseif class == 'HUNTER' then
			interruptSpell = 34490;
		elseif class == 'WARLOCK' and IsSpellKnown(19647, true) then
			interruptSpell = 19647;
		end
		return interruptSpell;
	end,
	castinterrupt = function(t)
		local interruptSpell = ni.spell.getinterrupt();           
		if interruptSpell ~= 0 then
			ni.spell.stopcasting();
			ni.spell.cast(interruptSpell, t);
		end
	end,
	getpercent = function() return math.random(40,60); end,
	shouldweinterrupt = function(t)
		local InterruptPercent = ni.spell.getpercent();
		local castName,_,_,_,castStartTime,castEndTime,_,_,castInterruptable = UnitCastingInfo(t);
		local channelName,_,_,_,channelStartTime,channelEndTime,_,_,channelInterruptable = UnitChannelInfo(t);
		if channelName ~= nil then
			castName = channelName;
			castStartTime = channelStartTime;
			castEndTime = channelEndTime;
			castInterruptable = channelInterruptable;
		end
		if castName ~= nil then
			if UnitCanAttack('player', t) == nil then
				return false;
			end
			local timeSinceStart = (GetTime()*1000-castStartTime)/1000
			local castTime = castEndTime-castStartTime
			local currentPercent = timeSinceStart/castTime*100000
			if (currentPercent < InterruptPercent) then
				return false;
			end
			local interruptSpell = ni.spell.getinterrupt();
			if interruptSpell ~= 0 then
				if ni.spell.cd(interruptSpell) > 0 or not IsSpellInRange(GetSpellInfo(interruptSpell), t) == 1 then
					return false;
				end
			else
				return false;
			end
			if ni.vars.interrupt == 'wl' then
				if tContains(ni.vars.InterruptList, castName) then
					return true;
				else
					return false;
				end
			else
				if tContains(ni.vars.BlackList, castName) then
					return false;
				end
			end
			return true;
		end
		return false;
	end,
	ValidTotemDispel = function(t)
		local HasValidTotemDispel = false
		local i = 1
		local debuff = UnitDebuff(t, i)
		local blacklist = {70338, 70337, --Necrotic Plauge
						   71503, 70311, 70405, 24673
				}
		for n = 1, #blacklist do
			if ni.unit.debuff(t, blacklist[n]) then return false end
		end
		while debuff do
			local debuffType = select(5, UnitDebuff(t, i))
			if debuffType  == 'Poison'  
			or debuffType  == 'Disease'  then
				HasValidDispel = true
			end
			i = i + 1
			debuff = UnitDebuff(t, i)
		end
		return HasValidTotemDispel
	end,
	HSorCleave = function(n, t)
		local t = true and t or nil;
		local _, _, _, cost, _, powertype = GetSpellInfo(n);
		local _,_,_,hc = GetSpellInfo(47450);
		local _,_,_,cc = GetSpellInfo(47520);
		if t == nil or UnitExists(t) then
			if ni.vars.AoE == true then
				if UnitPower('player', powertype) >= cost+cc then
					ni.spell.cast(47520);
				end
			elseif ni.vars.AoE == false then
				if UnitPower('player', powertype) >= cost+hc then
					ni.spell.cast(47450);
				end
			end
			if t then
				ni.spell.cast(n, t);
			else
				ni.spell.cast(n);
			end
		end
	end
}