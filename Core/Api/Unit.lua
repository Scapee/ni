local UnitGUID,
	UnitCanAttack,
	tinsert,
	tonumber,
	UnitLevel,
	UnitHealth,
	UnitHealthMax,
	UnitExists,
	UnitThreatSituation,
	GetUnitSpeed,
	UnitIsDeadOrGhost,
	UnitReaction,
	UnitCastingInfo,
	UnitBuff,
	GetSpellInfo,
	tContains,
	UnitDebuff =
	UnitGUID,
	UnitCanAttack,
	tinsert,
	tonumber,
	UnitLevel,
	UnitHealth,
	UnitHealthMax,
	UnitExists,
	UnitThreatSituation,
	GetUnitSpeed,
	UnitIsDeadOrGhost,
	UnitReaction,
	UnitCastingInfo,
	UnitBuff,
	GetSpellInfo,
	tContains,
	UnitDebuff

local creaturetypes = {
	[0] = "Unknown",
	[1] = "Beast",
	[2] = "Dragon",
	[3] = "Demon",
	[4] = "Elemental",
	[5] = "Giant",
	[6] = "Undead",
	[7] = "Humanoid",
	[8] = "Critter",
	[9] = "Mechanical",
	[10] = "NotSpecified",
	[11] = "Totem",
	[12] = "NonCombatPet",
	[13] = "GasCloud"
}

ni.unit = {
	exists = function(t)
		return ni.functions.objectexists(t);
	end,
	los = function(...) --target, target/x1,y1,z1,x2,y2,z2
		return ni.functions.los(...)
	end,
	creator = function(t)
		return ni.unit.exists(t) and ni.functions.unitcreator(t) or nil
	end,
	creations = function(unit)
		if unit then
			local t = {}
			local guid = UnitGUID(unit)
			for k, v in pairs(ni.objects) do
				if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
					local creator = v:creator()
					if creator == guid then
						table.insert(t, {name = v.name, guid = v.guid})
					end
				end
			end
			if (#t > 0) then
				return t
			end
		end
		return nil
	end,
	creature = function(t)
		return ni.unit.exists(t) and ni.functions.creaturetype(t) or 0
	end,
	istotem = function(t)
		return (ni.unit.exists(t) and ni.unit.creaturetype(t) == 11) or false
	end,
	readablecreaturetype = function(t)
		return creaturetypes[ni.unit.creaturetype(t)]
	end,
	combatreach = function(t)
		return t ~= nil and ni.functions.combatreach(t) or 0
	end,
	isboss = function(t)
		local bossId = ni.unit.id(t)

		if ni.tables.bosses[bossId] then
			return true
		end

		if ni.tables.mismarkedbosses[bossId] then
			return false
		end

		return UnitLevel(t) == -1
	end,
	threat = function(t, u)
		if u then
			if UnitExists(t) and UnitExists(u) and UnitThreatSituation(t, u) ~= nil then
				return UnitThreatSituation(t, u)
			else
				return 0
			end
		else
			if UnitExists(t) and UnitThreatSituation(t) ~= nil then
				return UnitThreatSituation(t)
			else
				return 0
			end
		end
	end,
	ismoving = function(t)
		return GetUnitSpeed(t) ~= 0
	end,
	id = function(t)
		if tonumber(t) then
			return tonumber((t):sub(-12, -7), 16)
		else
			return tonumber((UnitGUID(t)):sub(-12, -7), 16)
		end
	end,
	isdummy = function(t)
		if ni.unit.exists(t) then
			t = ni.unit.id(t)
			return ni.tables.dummies[t]
		end

		return false
	end,
	ttd = function(t)
		if ni.unit.isdummy(t) then
			return 99
		end
		if ni.unit.exists(t) and (not UnitIsDeadOrGhost(t) and UnitCanAttack("player", t) == 1) then
			t = UnitGUID(t)
		else
			return -2
		end

		if ni.objects[t] and ni.objects[t].ttd ~= nil then
			return ni.objects[t].ttd
		end

		return 99
	end,
	hp = function(t)
		return 100 * UnitHealth(t) / UnitHealthMax(t)
	end,
	info = function(t)
		if t == nil then
			return
		end
		local tmp = t

		if tonumber(tmp) == nil then
			t = UnitGUID(tmp)
			if t == nil then
				t = ni.objectmanager.objectGUID(tmp)
			end
		end

		if ni.unit.exists(t) then
			return ni.functions.objectinfo(t)
		end
	end,
	isfacing = function(t1, t2)
		return (t1 ~= nil and t2 ~= nil) and ni.functions.isfacing(t1, t2) or false
	end,
	distance = function(t1, t2)
		return (t1 ~= nil and t2 ~= nil) and ni.functions.getdistance(t1, t2) or nil
	end,
	isbehind = function(t1, t2)
		return (t1 ~= nil and t2 ~= nil) and ni.functions.isbehind(t1, t2) or false
	end,
	enemiesinrange = function(t, n)
		local tmp = {}
		local unit = true and UnitGUID(t) or t
		if unit then
			for k, v in pairs(ni.objects) do
				if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
					if k ~= unit and v:canattack() and not UnitIsDeadOrGhost(k) then
						local distance = v:distance(unit)
						if (distance ~= nil and distance <= n) then
							tinsert(tmp, {guid = k, name = v.name, distance = distance})
						end
					end
				end
			end
		end
		return tmp, #tmp
	end,
	friendsinrange = function(t, n)
		local tmp = {}
		local unit = true and UnitGUID(t) or t
		if unit then
			for k, v in pairs(ni.objects) do
				if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
					if k ~= unit and v:canassist() and not UnitIsDeadOrGhost(k) then
						local distance = v:distance(unit)
						if (distance ~= nil and distance <= n) then
							tinsert(tmp, {guid = k, name = v.name, distance = distance})
						end
					end
				end
			end
		end
		return tmp, #tmp
	end,
	unitstargeting = function(t, friendlies)
		local unit = true and UnitGUID(t) or t
		local f = true and friendlies or false
		local returntable = {}

		if unit then
			if not f then
				for k, v in pairs(ni.objects) do
					if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
						if k ~= unit and UnitReaction(unit, k) ~= nil and UnitReaction(unit, k) <= 4 and not UnitIsDeadOrGhost(k) then
							local target = v:target()
							if target ~= nil and target == unit then
								table.insert(returntable, {name = v.name, guid = k})
							end
						end
					end
				end
			else
				for k, v in pairs(ni.objects) do
					if type(k) ~= "function" and (type(k) == "string" and type(v) == "table") then
						if k ~= unit and UnitReaction(unit, k) ~= nil and UnitReaction(unit, k) > 4 then
							local target = v:target()
							if target ~= nil and target == unit then
								table.insert(returntable, {name = v.name, guid = k})
							end
						end
					end
				end
			end
		end
		return returntable, #returntable
	end,
	iscasting = function(t)
		local name, _, _, _, _, _, _, id = UnitCastingInfo(t)
		if name and id == t then
			return true
		end

		return false
	end,
	aura = function(t, s)
		return (t ~= nil and s ~= nil) and ni.functions.hasaura(t, s) or false
	end,
	bufftype = function(t, str)
		if not ni.unit.exists(t) then
			return false
		end

		local st = ni.utils.splitstringtolower(str)
		local has = false
		local i = 1
		local buff = UnitBuff(t, i)

		while buff do
			local bufftype = select(5, UnitBuff(t, i))
			if bufftype ~= nil then
				local bTlwr = string.lower(bufftype)
				if tContains(st, bTlwr) then
					has = true
					break
				end
			end
			i = i + 1
			buff = UnitBuff(t, i)
		end

		return has
	end,
	buff = function(t, id, caster, exact)
		exact = exact and true or false

		local spellName = ""

		if tonumber(id) ~= nil then
			spellName = GetSpellInfo(id)
		else
			spellName = id
			id = nil
		end
		if spellName == "" or spellName == nil then
			return
		end
		if
			caster ~= nil and
				((id and exact and select(11, UnitBuff(t, spellName, nil, caster)) == id) or
					((not id or exact == false) and UnitBuff(t, spellName, nil, caster)))
		 then
			return UnitBuff(t, spellName, nil, caster)
		elseif
			caster == nil and
				((id and exact and select(11, UnitBuff(t, spellName)) == id) or
					((not id or exact == false) and UnitBuff(t, spellName)))
		 then
			return UnitBuff(t, spellName)
		end
	end,
	buffs = function(t, ids, caster, exact)
		local ands = ni.utils.findand(ids)
		local results = false
		if ands ~= nil or (ands == nil and string.len(ids) > 0) then
			local tmp
			if ands then
				tmp = ni.utils.splitstringbydelimiter(ids, "&&")
				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])

						if id ~= nil then
							if not ni.player.buff(t, id, caster, exact) then
								results = false
								break
							else
								results = true
							end
						else
							if not ni.player.buff(t, tmp[i], caster, exact) then
								results = false
								break
							else
								results = true
							end
						end
					end
				end
			else
				tmp = ni.utils.splitstringbydelimiter(ids, "||")
				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])

						if id ~= nil then
							if ni.player.buff(t, id, caster, exact) then
								results = true
								break
							end
						else
							if ni.player.buff(t, tmp[i], caster, exact) then
								results = true
								break
							end
						end
					end
				end
			end
		end
		return results
	end,
	debufftype = function(t, str)
		if not ni.unit.exists(t) then
			return false
		end

		local st = ni.utils.splitstringtolower(str)
		local has = false
		local i = 1
		local debuff = UnitDebuff(t, i)

		while debuff do
			local debufftype = select(5, UnitDebuff(t, i))

			if debufftype ~= nil then
				local dTlwr = string.lower(debufftype)
				if tContains(st, dTlwr) then
					has = true
					break
				end
			end

			i = i + 1
			debuff = UnitDebuff(t, i)
		end

		return has
	end,
	debuff = function(t, spellID, caster, exact)
		exact = exact and true or false
		local spellName = ""

		if tonumber(spellID) ~= nil then
			spellName = GetSpellInfo(spellID)
		else
			spellName = spellID
			spellID = nil
		end

		if spellName == "" or spellName == nil then
			return
		end
		if
			caster == nil and
				((spellID and exact and select(11, UnitDebuff(t, spellName)) == spellID) or
					((not spellID or exact == false) and UnitDebuff(t, spellName)))
		 then
			return UnitDebuff(t, spellName)
		elseif
			caster ~= nil and
				((spellID and exact and select(11, UnitDebuff(t, spellName, nil, caster)) == spellID) or
					((not spellID or exact == false) and UnitDebuff(t, spellName, nil, caster)))
		 then
			return UnitDebuff(t, spellName, nil, caster)
		end
	end,
	debuffs = function(t, spellIDs, caster, exact)
		local ands = ni.utils.findand(spellIDs)
		local results = false

		if ands ~= nil or (ands == nil and string.len(spellIDs) > 0) then
			local tmp

			if ands then
				tmp = ni.utils.splitstringbydelimiter(spellIDs, "&&")

				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])
						if id ~= nil then
							if not ni.player.debuff(t, id, caster, exact) then
								results = false
								break
							else
								results = true
							end
						else
							if not ni.player.debuff(t, tmp[i], caster, exact) then
								results = false
								break
							else
								results = true
							end
						end
					end
				end
			else
				tmp = ni.utils.splitstringbydelimiter(spellIDs, "||")
				for i = 0, #tmp do
					local id = tonumber(tmp[i])
					if id ~= nil then
						if ni.player.debuff(t, id, caster, exact) then
							results = true
							break
						end
					else
						if ni.player.debuff(t, tmp[i], caster, exact) then
							results = true
							break
						end
					end
				end
			end
		end

		return results
	end,
	flags = function(t)
		if t ~= nil then
			return ni.functions.unitflags(t)
		end
	end,
	dynamicflags = function(t)
		if t ~= nil then
			return ni.functions.unitdynamicflags(t)
		end
	end,
	istappedbyallthreatlist = function(t)
		return (ni.unit.exists(t) and select(2, ni.unit.dynamicflags(t))) or false
	end,
	lootable = function(t)
		return (ni.unit.exists(t) and select(3, ni.unit.dynamicflags(t))) or false
	end,
	taggedbyme = function(t)
		return (ni.unit.exists(t) and select(7, ni.unit.dynamicflags(t))) or false
	end,
	taggedbyother = function(t)
		return (ni.unit.exists(t) and select(8, ni.unit.dynamicflags(t))) or false
	end,
	canPerformAction = function(t)
		return (ni.unit.exists(t) and select(1, ni.unit.flags(t))) or false
	end,
	confused = function(t)
		return (ni.unit.exists(t) and select(23, ni.unit.flags(t))) or false
	end,
	disarmed = function(t)
		return (ni.unit.exists(t) and select(22, ni.unit.flags(t))) or false
	end,
	fleeing = function(t)
		return (ni.unit.exists(t) and select(24, ni.unit.flags(t))) or false
	end,
	looting = function(t)
		return (ni.unit.exists(t) and select(11, ni.unit.flags(t))) or false
	end,
	mounted = function(t)
		return (ni.unit.exists(t) and select(28, ni.unit.flags(t))) or false
	end,
	notattackable = function(t)
		return (ni.unit.exists(t) and select(2, ni.unit.flags(t))) or false
	end,
	notselectable = function(t)
		return (ni.unit.exists(t) and select(26, ni.unit.flags(t))) or false
	end,
	pacified = function(t)
		return (ni.unit.exists(t) and select(18, ni.unit.flags(t))) or false
	end,
	petInCombat = function(t)
		return (ni.unit.exists(t) and select(12, ni.unit.flags(t))) or false
	end,
	playercontrolled = function(t)
		return (ni.unit.exists(t) and select(4, ni.unit.flags(t))) or false
	end,
	possessed = function(t)
		return (ni.unit.exists(t) and select(25, ni.unit.flags(t))) or false
	end,
	preparation = function(t)
		return (ni.unit.exists(t) and select(6, ni.unit.flags(t))) or false
	end,
	pvpflagged = function(t)
		return (ni.unit.exists(t) and select(13, ni.unit.flags(t))) or false
	end,
	silenced = function(t)
		return (ni.unit.exists(t) and select(14, ni.unit.flags(t))) or false
	end,
	skinnable = function(t)
		return (ni.unit.exists(t) and select(27, ni.unit.flags(t))) or false
	end,
	stunned = function(t)
		return (ni.unit.exists(t) and select(19, ni.unit.flags(t))) or false
	end,
	immune = function(t)
		return (ni.unit.exists(t) and select(32, ni.unit.flags(t))) or false
	end
}
