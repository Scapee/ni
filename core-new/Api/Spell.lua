ni.spell = {
	queue = {},
	Id = function(s)
		if s == nil then
			return nil
		end
		local id = ni.functions.GetSpellId(s)
		return (id ~= 0) and id or nil
	end,
	Cd = function(id)
		if tonumber(id) == nil then
			id = ni.spell.Id(id)
		end
		if id > 0 and IsSpellKnown(id) then
			local start, duration = GetSpellCooldown(id)
			if (start > 0 and duration > 0) then
				return start + duration - GetTime()
			else
				return 0
			end
		else
			return 0
		end
	end,
	Gcd = function()
		local _, d = GetSpellCooldown(61304)
		return d ~= 0
	end,
	Available = function(id, stutter)
		local stutter = true and stutter or true

		if stutter then
			if ni.spell.Gcd() or ni.vars.combat.casting == true then
				return false
			end
		end

		if tonumber(id) == nil then
			id = ni.spell.Id(id)
		end

		local result = false

		if id ~= nil and id ~= 0 and IsSpellKnown(id) then
			local name, _, _, cost, _, powertype = GetSpellInfo(id)
			if
				name and
					((powertype == -2 and UnitHealth("player") >= cost) or (powertype >= 0 and UnitPower("player", powertype) >= cost)) and
					ni.spell.Cd(id) == 0
			 then
				result = true
			end
		end
		return result
	end,
	CastTime = function(spell)
		return select(7, GetSpellInfo(spell)) / 1000 + select(3, GetNetStats()) / 1000
	end,
	Cast = function(...)
		local i, t = ...
		if i == nil then
			return
		end

		if tonumber(i) == nil then
			i = ni.spell.Id(i)
			if i == 0 then
				return
			end
		end

		if t ~= nil then
			ni.functions.Cast(i, t)
		else
			ni.functions.Cast(i)
		end
	end,
	CastSpells = function(spells, t)
		local items = ni.utils.SplitString(spells)

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
	CastAt = function(spell, t, offset)
		if spell then
			if t == "click" then
				ni.spell.Cast(spell)
				ni.player.ClickTerrain("click")
			elseif ni.unit.Exists(t) then
				local offset = true and offset or random()
				local x, y, z = ni.unit.info(t)
				local r = offset * sqrt(random())
				local theta = random() * 360
				local tx = x + r * cos(theta)
				local ty = y + r * sin(theta)
				ni.spell.Cast(spell)
				ni.player.ClickTerrain(tx, ty, z)
			end
		end
	end,
	Queue = function(...)
		local id, tar = ...
		if id == nil then
			id = ni.getSpellIdFromActionBar()
		end
		if id == nil or id == 0 then
			return
		end
		for k, v in pairs(ni.spell.queue) do
			if tContains(v[2], id) then
				ni.frames.SpellQueue.Update()
				tremove(ni.spell.queue, k)
				return
			end
		end
		tinsert(ni.spell.queue, {ni.spell.Cast, {id, tar}})
		ni.frames.SpellQueue.Update(id, true)
	end,
	QueueAt = function(...)
		local id, tar = ...
		if id == nil then
			id = ni.getSpellIdFromActionBar()
			tar = "target"
		end
		if id == nil or id == 0 then
			return
		end
		for k, v in pairs(ni.spell.queue) do
			if tContains(v[2], id) then
				ni.Info.update()
				tremove(ni.spell.queue, k)
				return
			end
		end
		if tar ~= nil then
			tinsert(ni.spell.queue, {ni.spell.CastAt, {id, tar}})
			ni.frames.SpellQueue.Update(id, true)
		end
	end,
	StopCasting = function()
		ni.functions.StopCasting()
	end,
	StopChanneling = function()
		StrafeLeftStart()
		StrafeLeftStop()
	end,
	LoS = function(...)
		local t = ...
		if t == nil then
			return
		end

		if (ni.tables.whitelistedLoSUnits[ni.unit.Id(t)]) then
			return true
		end

		return ni.functions.LoS("player", ...)
	end,
	Valid = function(t, spellid, facing, los, friendly)
		friendly = true and friendly or false
		los = true and los or false
		facing = true and facing or false

		if tonumber(spellid) == nil then
			spellid = ni.spell.Id(spellid)
			if spellid == 0 then
				return false
			end
		end

		local name, _, _, cost, _, powertype = GetSpellInfo(spellid)

		if
			ni.unit.Exists(t) and ((not friendly and (not UnitIsDeadOrGhost(t) and UnitCanAttack("player", t) == 1)) or friendly) and
				IsSpellInRange(name, t) == 1 and
				IsSpellKnown(spellid) and
				UnitPower("player", powertype) >= cost and
				((facing and ni.player.IsFacing(t)) or not facing) and
				((los and ni.spell.LoS(t)) or not los)
		 then
			return true
		end

		return false
	end,
	GetInterrupt = function()
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
	CastInterrupt = function(t)
		local interruptSpell = ni.spell.GetInterrupt()

		if interruptSpell ~= 0 then
			ni.spell.StopCasting()
			ni.spell.StopChanneling()
			ni.spell.Cast(interruptSpell, t)
		end
	end,
	GetPercent = function()
		return math.random(40, 60)
	end,
	ShouldInterrupt = function(t)
		local InterruptPercent = ni.spell.GetPercent()
		local castName, _, _, _, castStartTime, castEndTime, _, _, castInterruptable = UnitCastingInfo(t)
		local channelName, _, _, _, channelStartTime, channelEndTime, _, _, channelInterruptable = UnitChannelInfo(t)

		if channelName ~= nil then
			castName = channelName
			castStartTime = channelStartTime
			castEndTime = channelEndTime
			castInterruptable = channelInterruptable
		end

		if castName ~= nil then
			if UnitCanAttack("player", t) == nil then
				return false
			end
			local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
			local castTime = castEndTime - castStartTime
			local currentPercent = timeSinceStart / castTime * 100000

			if (currentPercent < InterruptPercent) then
				return false
			end

			local interruptSpell = ni.spell.GetInterrupt()

			if interruptSpell ~= 0 then
				if ni.spell.Cd(interruptSpell) > 0 or not IsSpellInRange(GetSpellInfo(interruptSpell), t) == 1 then
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
