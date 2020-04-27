local getSpellCooldown,
	getTime,
	getSpellInfo,
	getNetStats,
	tonumber,
	unitIsDeadOrGhost,
	unitCanAttack,
	isSpellInRange,
	isSpellKnown,
	unitPower,
	unitClass,
	getShapeshiftForm,
	unitCastingInfo,
	unitChannelInfo,
	tContains,
	random,
	sin,
	cos,
	unitHealth,
	sqrt,
	tremove,
	tinsert,
	strafeLeftStart,
	strafeLeftStop =
	getSpellCooldown,
	getTime,
	getSpellInfo,
	getNetStats,
	tonumber,
	unitIsDeadOrGhost,
	unitCanAttack,
	isSpellInRange,
	isSpellKnown,
	unitPower,
	unitClass,
	getShapeshiftForm,
	unitCastingInfo,
	unitChannelInfo,
	tContains,
	random,
	sin,
	cos,
	unitHealth,
	sqrt,
	tremove,
	tinsert,
	strafeLeftStart,
	strafeLeftStop

ni.spell = {
	queue = {},
	id = function(s)
		if s == nil then
			return nil
		end
		local id = ni.functions.getSpellId(s)
		return (id ~= 0) and id or nil
	end,
	cd = function(id)
		if tonumber(id) == nil then
			id = ni.spell.id(id)
		end
		if id > 0 and isSpellKnown(id) then
			local start, duration = getSpellCooldown(id)
			if (start > 0 and duration > 0) then
				return start + duration - getTime(), true
			else
				return 0, false
			end
		else
			return 0, false
		end
	end,
	gcd = function()
		local _, d = getSpellCooldown(61304)
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

		if id ~= nil and id ~= 0 and isSpellKnown(id) then
			local name, _, _, cost, _, powertype = getSpellInfo(id)
			if
				name and
					((powertype == -2 and unitHealth("player") >= cost) or (powertype >= 0 and unitPower("player", powertype) >= cost)) and
					ni.spell.cd(id) == 0
			 then
				result = true
			end
		end
		return result
	end,
	castTime = function(spell)
		return select(7, getSpellInfo(spell)) / 1000 + select(3, getNetStats()) / 1000
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
	castSpells = function(spells, t)
		local items = ni.utils.splitString(spells)

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
	castAt = function(spell, t, offset)
		if spell then
			if t == "click" then
				ni.spell.cast(spell)
				ni.player.clickTerrain("click")
			elseif ni.unit.exists(t) then
				local offset = true and offset or random()
				local x, y, z = ni.unit.info(t)
				local r = offset * sqrt(random())
				local theta = random() * 360
				local tx = x + r * cos(theta)
				local ty = y + r * sin(theta)
				ni.spell.cast(spell)
				ni.player.clickTerrain(tx, ty, z)
			end
		end
	end,
	castQueue = function(...)
		local id, tar = ...
		if id == nil then
			id = ni.getSpellIdFromActionBar()
		end
		if id == nil or id == 0 then
			return
		end
		for k, v in pairs(ni.spell.queue) do
			if tContains(v[2], id) then
				ni.frames.spellQueue.update()
				tremove(ni.spell.queue, k)
				return
			end
		end
		tinsert(ni.spell.queue, {ni.spell.cast, {id, tar}})
		ni.frames.spellQueue.update(id, true)
	end,
	castAtQueue = function(...)
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
				ni.info.update()
				tremove(ni.spell.queue, k)
				return
			end
		end
		if tar ~= nil then
			tinsert(ni.spell.queue, {ni.spell.castAt, {id, tar}})
			ni.frames.spellQueue.update(id, true)
		end
	end,
	stopCasting = function()
		ni.functions.stopCasting()
	end,
	stopChanneling = function()
		strafeLeftStart()
		strafeLeftStop()
	end,
	loS = function(...)
		local t = ...
		if t == nil then
			return
		end

		if (ni.tables.whitelistedLoSUnits[ni.unit.id(t)]) then
			return true
		end

		return ni.functions.loS("player", ...)
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

		local name, _, _, cost, _, powertype = getSpellInfo(spellid)

		if
			ni.unit.exists(t) and ((not friendly and (not unitIsDeadOrGhost(t) and unitCanAttack("player", t) == 1)) or friendly) and
				isSpellInRange(name, t) == 1 and
				isSpellKnown(spellid) and
				unitPower("player", powertype) >= cost and
				((facing and ni.player.isFacing(t)) or not facing) and
				((los and ni.spell.loS(t)) or not los)
		 then
			return true
		end

		return false
	end,
	getInterrupt = function()
		local _, class = unitClass("player")
		local interruptSpell = 0

		if class == "SHAMAN" then
			interruptSpell = 57994
		elseif class == "WARRIOR" then
			if getShapeshiftForm() == 3 then
				interruptSpell = 6552
			elseif getShapeshiftForm() == 2 then
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
		elseif class == "WARLOCK" and isSpellKnown(19647, true) then
			interruptSpell = 19647
		end

		return interruptSpell
	end,
	castInterrupt = function(t)
		local interruptSpell = ni.spell.getInterrupt()

		if interruptSpell ~= 0 then
			ni.spell.stopCasting()
			ni.spell.stopChanneling()
			ni.spell.cast(interruptSpell, t)
		end
	end,
	getPercent = function()
		return math.random(40, 60)
	end,
	shouldInterrupt = function(t)
		local interruptPercent = ni.spell.getPercent()
		local castName, _, _, _, castStartTime, castEndTime, _, _, castInterruptable = unitCastingInfo(t)
		local channelName, _, _, _, channelStartTime, channelEndTime, _, _, channelInterruptable = unitChannelInfo(t)

		if channelName ~= nil then
			castName = channelName
			castStartTime = channelStartTime
			castEndTime = channelEndTime
			castInterruptable = channelInterruptable
		end

		if castName ~= nil then
			if unitCanAttack("player", t) == nil then
				return false
			end
			local timeSinceStart = (GetTime() * 1000 - castStartTime) / 1000
			local castTime = castEndTime - castStartTime
			local currentPercent = timeSinceStart / castTime * 100000

			if (currentPercent < interruptPercent) then
				return false
			end

			local interruptSpell = ni.spell.getInterrupt()

			if interruptSpell ~= 0 then
				if ni.spell.cd(interruptSpell) > 0 or not isSpellInRange(GetSpellInfo(interruptSpell), t) == 1 then
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
