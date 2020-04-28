local GetSpellCooldown,
	GetTime,
	GetSpellInfo,
	GetNetStats,
	tonumber,
	UnitIsDeadOrGhost,
	UnitCanAttack,
	IsSpellInRange,
	IsSpellKnown,
	UnitPower,
	UnitClass,
	GetShapeshiftForm,
	UnitCastingInfo,
	UnitChannelInfo,
	tContains,
	random,
	sin,
	cos,
	UnitHealth,
	sqrt,
	tremove,
	tinsert,
	StrafeLeftStart,
	StrafeLeftStop =
	GetSpellCooldown,
	GetTime,
	GetSpellInfo,
	GetNetStats,
	tonumber,
	UnitIsDeadOrGhost,
	UnitCanAttack,
	IsSpellInRange,
	IsSpellKnown,
	UnitPower,
	UnitClass,
	GetShapeshiftForm,
	UnitCastingInfo,
	UnitChannelInfo,
	tContains,
	random,
	sin,
	cos,
	UnitHealth,
	sqrt,
	tremove,
	tinsert,
	StrafeLeftStart,
	StrafeLeftStop

ni.spell = {
	queue = {},
	id = function(s)
		if s == nil then
			return nil
		end
		local id = ni.functions.getspellid(s)
		return (id ~= 0) and id or nil
	end,
	cd = function(id)
		if tonumber(id) == nil then
			id = ni.spell.id(id)
		end
		if id > 0 and IsSpellKnown(id) then
			local start, duration = GetSpellCooldown(id)
			if (start > 0 and duration > 0) then
				return start + duration - GetTime(), true
			else
				return 0, false
			end
		else
			return 0, false
		end
	end,
	gcd = function()
		local _, d = GetSpellCooldown(61304)
		return d ~= 0
	end,
	available = function(id, stutter)
		local stutter = true and stutter or true

		if stutter then
			if ni.spell.gcd() or ni.vars.combat.casting == true then
				return false
			end
		end

		if tonumber(id) == nil then
			id = ni.spell.id(id)
		end

		local result = false

		if id ~= nil and id ~= 0 and IsSpellKnown(id) then
			local name, _, _, cost, _, powertype = GetSpellInfo(id)
			if
				name and
					((powertype == -2 and UnitHealth("player") >= cost) or (powertype >= 0 and UnitPower("player", powertype) >= cost)) and
					ni.spell.cd(id) == 0
			 then
				result = true
			end
		end
		return result
	end,
	casttime = function(spell)
		return select(7, GetSpellInfo(spell)) / 1000 + select(3, GetNetStats()) / 1000
	end,
	cast = function(...)
		local i, t = ...
		if i == nil then
			return
		end

		if tonumber(i) == nil then
			i = ni.spell.id(i)
			if i == 0 then
				return
			end
		end

		if t ~= nil then
			ni.functions.cast(i, t)
		else
			ni.functions.cast(i)
		end
	end,
	castspells = function(spells, t)
		local items = ni.utils.splitstring(spells)

		for i = 0, #items do
			local st = items[i]
			if st ~= nil then
				local id = tonumber(st)
				if id ~= nil then
					ni.spell.cast(id, t)
				else
					ni.spell.cast(st, t)
				end
			end
		end
	end,
	castat = function(spell, t, offset)
		if spell then
			if t == "mouse" then
				ni.spell.cast(spell)
				ni.player.clickat("mouse")
			elseif ni.unit.exists(t) then
				local offset = true and offset or random()
				local x, y, z = ni.unit.info(t)
				local r = offset * sqrt(random())
				local theta = random() * 360
				local tx = x + r * cos(theta)
				local ty = y + r * sin(theta)
				ni.spell.cast(spell)
				ni.player.clickat(tx, ty, z)
			end
		end
	end,
	castqueue = function(...)
		local id, tar = ...
		if id == nil then
			id = ni.getspellidfromactionbar()
		end
		if id == nil or id == 0 then
			return
		end
		for k, v in pairs(ni.spell.queue) do
			if tContains(v[2], id) then
				ni.frames.spellqueue.update()
				tremove(ni.spell.queue, k)
				return
			end
		end
		tinsert(ni.spell.queue, {ni.spell.cast, {id, tar}})
		ni.frames.spellqueue.update(id, true)
	end,
	castatqueue = function(...)
		local id, tar = ...
		if id == nil then
			id = ni.getspellidfromactionbar()
			tar = "target"
		end
		if id == nil or id == 0 then
			return
		end
		for k, v in pairs(ni.spell.queue) do
			if tContains(v[2], id) then
				ni.info.update()
				tremove(ni.spell.queue, k)
				return
			end
		end
		if tar ~= nil then
			tinsert(ni.spell.queue, {ni.spell.castat, {id, tar}})
			ni.frames.spellqueue.update(id, true)
		end
	end,
	stopcasting = function()
		ni.functions.stopcasting()
	end,
	stopchanneling = function()
		StrafeLeftStart()
		StrafeLeftStop()
	end,
	los = function(...)
		local t = ...
		if t == nil then
			return false;
		end

		if (ni.tables.whitelistedlosunits[ni.unit.id(t)]) then
			return true
		end

		return ni.functions.los("player", ...)
	end,
	valid = function(t, spellid, facing, los, friendly)
		friendly = true and friendly or false
		los = true and los or false
		facing = true and facing or false

		if tonumber(spellid) == nil then
			spellid = ni.spell.id(spellid)
			if spellid == 0 then
				return false
			end
		end

		local name, _, _, cost, _, powertype = GetSpellInfo(spellid)

		if
			ni.unit.exists(t) and ((not friendly and (not UnitIsDeadOrGhost(t) and UnitCanAttack("player", t) == 1)) or friendly) and
				IsSpellInRange(name, t) == 1 and
				IsSpellKnown(spellid) and
				UnitPower("player", powertype) >= cost and
				((facing and ni.player.isfacing(t)) or not facing) and
				((los and ni.spell.los(t)) or not los)
		 then
			return true
		end

		return false
	end,
	getinterrupt = function()
		local _, class = UnitClass("player")
		local interruptSpell = 0

		if class == "SHAMAN" then
			interruptSpell = 57994
		elseif class == "WARRIOR" then
			if GetShapeshiftForm() == 3 then
				interruptSpell = 6552
			elseif GetShapeshiftForm() == 2 then
				interruptSpell = 72
			end
		elseif class == "PRIEST" then
			interruptSpell = 15487
		elseif class == "DEATHKNIGHT" then
			interruptSpell = 47528
		elseif class == "ROGUE" then
			interruptSpell = 1766
		elseif class == "MAGE" then
			interruptSpell = 2139
		elseif class == "HUNTER" then
			interruptSpell = 34490
		elseif class == "WARLOCK" and IsSpellKnown(19647, true) then
			interruptSpell = 19647
		end

		return interruptSpell
	end,
	castinterrupt = function(t)
		local interruptSpell = ni.spell.getinterrupt()

		if interruptSpell ~= 0 then
			ni.spell.stopcasting()
			ni.spell.stopchanneling()
			ni.spell.cast(interruptSpell, t)
		end
	end,
	getpercent = function()
		return math.random(40, 60)
	end,
	shouldinterrupt = function(t)
		local InterruptPercent = ni.spell.getpercent()
		local castName, _, _, _, castStartTime, castEndTime, _, _, castinterruptable = UnitCastingInfo(t)
		local channelName, _, _, _, channelStartTime, channelEndTime, _, _, channelInterruptable = UnitChannelInfo(t)

		if channelName ~= nil then
			castName = channelName
			castStartTime = channelStartTime
			castEndTime = channelEndTime
			castinterruptable = channelInterruptable
		end

		if castName ~= nil then
			if UnitCanAttack("player", t) == nil then
				return false
			end
			local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
			local casttime = castEndTime - castStartTime
			local currentpercent = timeSinceStart / casttime * 100000

			if (currentpercent < InterruptPercent) then
				return false
			end

			local interruptSpell = ni.spell.getinterrupt()

			if interruptSpell ~= 0 then
				if ni.spell.cd(interruptSpell) > 0 or not IsSpellInRange(GetSpellInfo(interruptSpell), t) == 1 then
					return false
				end
			else
				return false
			end
			if ni.vars.interrupt == "wl" then
				if tContains(ni.vars.interrupts.whiteListed, castName) then
					return true
				else
					return false
				end
			else
				if tContains(ni.vars.interrupts.blackListed, castName) then
					return false
				end
			end
			return true
		end
		return false
	end
}
