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

ni.unit = {
	creatureTypes = {
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
	},
	Exists = function(t)
		return t ~= nil and ni.functions.ObjectExists(t) or false
	end,
	LoS = function(...)
		local t1, t2 = ...
		if t1 ~= nil and t2 ~= nil then
			return ni.functions.LoS(...)
		end
		return false
	end,
	IsCreator = function(t)
		return ni.unit.Exists(t) and ni.functions.UnitCreator(t) or nil
	end,
	Creations = function(unit)
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
	IsCreature = function(t)
		return ni.unit.Exists(t) and ni.functions.CreatureType(t) or 0
	end,
	IsTotem = function(t)
		return (ni.unit.Exists(t) and ni.unit.CreatureType(t) == 11) or false
	end,
	isUnitReadableCreatureType = function(t)
		return ni.unit.creatureTypes[ni.unit.CreatureType(t)]
	end,
	HasReach = function(t)
		return t ~= nil and ni.functions.CombatReach(t) or 0
	end,
	IsBoss = function(t)
		local bossId = ni.unit.Id(t)

		if ni.tables.bosses[bossId] then
			return true
		end

		if ni.tables.mismarkedbosses[bossId] then
			return false
		end

		return UnitLevel(t) == -1
	end,
	Threat = function(t, u)
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
	IsMoving = function(t)
		return GetUnitSpeed(t) ~= 0
	end,
	Id = function(t)
		if tonumber(t) then
			return tonumber((t):sub(-12, -7), 16)
		else
			return tonumber((UnitGUID(t)):sub(-12, -7), 16)
		end
	end,
	IsDummy = function(t)
		if ni.unit.Exists(t) then
			t = ni.unit.Id(t)
			return ni.tables.dummies[t]
		end

		return false
	end,
	Ttd = function(t)
		if ni.unit.IsDummy(t) then
			return 99
		end

		if ni.unit.Exists(t) and (not UnitIsDeadOrGhost(t) and UnitCanAttack("player", t) == 1) then
			t = UnitGUID(t)
		else
			return -2
		end

		if ni.objects[t] and ni.objects[t].ttd ~= nil then
			return ni.objects[t].ttd
		end

		return 99
	end,
	Hp = function(t)
		return 100 * UnitHealth(t) / UnitHealthMax(t)
	end,
	Info = function(t)
		if t == nil then
			return
		end
		local tmp = t

		if tonumber(tmp) == nil then
			t = UnitGUID(tmp)
			if t == nil then
				t = ni.objectManager.ObjectGUID(tmp)
			end
		end

		if ni.unit.Exists(t) then
			return ni.functions.ObjectInfo(t)
		end
	end,
	IsFacing = function(t1, t2)
		return (t1 ~= nil and t2 ~= nil) and ni.functions.IsFacing(t1, t2) or false
	end,
	Distance = function(t1, t2)
		return (t1 ~= nil and t2 ~= nil) and ni.functions.GetDistance(t1, t2) or nil
	end,
	IsBehind = function(t1, t2)
		return (t1 ~= nil and t2 ~= nil) and ni.functions.IsBehind(t1, t2) or false
	end,
	EnemiesInRange = function(t, n)
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
	FriendsInRange = function(t, n)
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
	UnitsTargeting = function(t, f)
		local unit = true and UnitGUID(t) or t
		local f = f and true or false
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
	IsCasting = function(t)
		local name, _, _, _, _, _, _, id = UnitCastingInfo(t)
		if name and id == t then
			return true
		end

		return false
	end,
	Aura = function(t, s)
		return (t ~= nil and s ~= nil) and ni.functions.HasAura(t, s) or false
	end,
	BuffType = function(t, str)
		if not ni.unit.Exists(t) then
			return false
		end

		local st = ni.utils.SplitStringToLower(str)
		local has = false
		local i = 1
		local buff = UnitBuff(t, i)

		while buff do
			local buffType = select(5, UnitBuff(t, i))
			if buffType ~= nil then
				local bTlwr = string.lower(buffType)
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
	Buff = function(t, id, caster, exact)
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
	Buffs = function(t, ids, caster, exact)
		local ands = ni.utils.FindAnd(ids)
		local results = false
		if ands ~= nil or (ands == nil and string.len(ids) > 0) then
			local tmp
			if ands then
				tmp = ni.utils.SplitStringByDelimiter(ids, "&&")
				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])

						if id ~= nil then
							if not ni.player.Buff(t, id, caster, exact) then
								results = false
								break
							else
								results = true
							end
						else
							if not ni.player.Buff(t, tmp[i], caster, exact) then
								results = false
								break
							else
								results = true
							end
						end
					end
				end
			else
				tmp = ni.utils.SplitStringByDelimiter(ids, "||")
				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])

						if id ~= nil then
							if ni.player.Buff(t, id, caster, exact) then
								results = true
								break
							end
						else
							if ni.player.Buff(t, tmp[i], caster, exact) then
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
	DebuffType = function(t, str)
		if not ni.unit.Exists(t) then
			return false
		end

		local st = ni.utils.SplitStringToLower(str)
		local has = false
		local i = 1
		local debuff = UnitDebuff(t, i)

		while debuff do
			local debuffType = select(5, UnitDebuff(t, i))

			if debuffType ~= nil then
				local dTlwr = string.lower(debuffType)
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
	Debuff = function(t, spellID, caster, exact)
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
	Debuffs = function(t, spellIDs, caster, exact)
		local ands = ni.utils.FindAnd(spellIDs)
		local results = false

		if ands ~= nil or (ands == nil and string.len(spellIDs) > 0) then
			local tmp

			if ands then
				tmp = ni.utils.SplitStringByDelimiter(spellIDs, "&&")

				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])
						if id ~= nil then
							if not ni.player.Debuff(t, id, caster, exact) then
								results = false
								break
							else
								results = true
							end
						else
							if not ni.player.Debuff(t, tmp[i], caster, exact) then
								results = false
								break
							else
								results = true
							end
						end
					end
				end
			else
				tmp = ni.utils.SplitStringByDelimiter(spellIDs, "||")
				for i = 0, #tmp do
					local id = tonumber(tmp[i])
					if id ~= nil then
						if ni.player.Debuff(t, id, caster, exact) then
							results = true
							break
						end
					else
						if ni.player.Debuff(t, tmp[i], caster, exact) then
							results = true
							break
						end
					end
				end
			end
		end

		return results
	end,
	Flags = function(t)
		if t ~= nil then
			return ni.functions.UnitFlags(t)
		end
	end,
	DynamicFlags = function(t)
		if t ~= nil then
			return ni.functions.UnitDynamicFlags(t)
		end
	end,
	IsTappedByAllThreatList = function(t)
		return (ni.unit.Exists(t) and select(2, ni.unit.DynamicFlags(t))) or false
	end,
	Lootable = function(t)
		return (ni.unit.Exists(t) and select(3, ni.unit.DynamicFlags(t))) or false
	end,
	TaggedByMe = function(t)
		return (ni.unit.Exists(t) and select(7, ni.unit.DynamicFlags(t))) or false
	end,
	TaggedByOther = function(t)
		return (ni.unit.Exists(t) and select(8, ni.unit.DynamicFlags(t))) or false
	end,
	CanPerformAction = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(1, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(1, ni.unit.Flags(t))) or false
		end
	end,
	Confused = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(23, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(3, ni.unit.Flags(t))) or false
		end
	end,
	Dazed = function(t)
		if ni.vars.build == 30300 then
			return false
		else
			return (ni.unit.Exists(t) and select(4, ni.unit.Flags(t))) or false
		end
	end,
	Disarmed = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(22, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(5, ni.unit.Flags(t))) or false
		end
	end,
	Fleeing = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(24, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(6, ni.unit.Flags(t))) or false
		end
	end,
	Influenced = function(t)
		if ni.vars.build == 30300 then
			return false
		else
			return (ni.unit.Exists(t) and select(7, ni.unit.Flags(t))) or false
		end
	end,
	Looting = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(11, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(8, ni.unit.Flags(t))) or false
		end
	end,
	Mounted = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(28, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(9, ni.unit.Flags(t))) or false
		end
	end,
	NotAttackable = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(2, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(11, ni.unit.Flags(t))) or false
		end
	end,
	NotSelectable = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(26, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(12, ni.unit.Flags(t))) or false
		end
	end,
	Pacified = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(18, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(13, ni.unit.Flags(t))) or false
		end
	end,
	PetInCombat = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(12, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(14, ni.unit.Flags(t))) or false
		end
	end,
	PlayerControlled = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(4, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(15, ni.unit.Flags(t))) or false
		end
	end,
	Possessed = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(25, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(17, ni.unit.Flags(t))) or false
		end
	end,
	Preparation = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(6, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(18, ni.unit.Flags(t))) or false
		end
	end,
	PvPFlagged = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(13, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(19, ni.unit.Flags(t))) or false
		end
	end,
	Silenced = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(14, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(21, ni.unit.Flags(t))) or false
		end
	end,
	Skinnable = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(27, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(23, ni.unit.Flags(t))) or false
		end
	end,
	Stunned = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(19, ni.unit.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(24, ni.unit.Flags(t))) or false
		end
	end,
	Immune = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(32, ni.unit.Flags(t))) or false
		else
			return false
		end
	end
}
