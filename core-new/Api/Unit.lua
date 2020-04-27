local UnitGUID,
	UnitCanAttack,
	tinsert,
	tonumber,
	GetSpellInfo,
	UnitDebuff,
	UnitBuff,
	UnitName,
	UnitLevel,
	UnitHealth,
	UnitHealthMax,
	UnitMana,
	UnitManaMax,
	UnitExists,
	UnitThreatSituation,
	GetUnitSpeed,
	UnitIsDeadOrGhost =
	UnitGUID,
	UnitCanAttack,
	tinsert,
	tonumber,
	GetSpellInfo,
	UnitDebuff,
	UnitBuff,
	UnitName,
	UnitLevel,
	UnitHealth,
	UnitHealthMax,
	UnitMana,
	UnitManaMax,
	UnitExists,
	UnitThreatSituation,
	GetUnitSpeed,
	UnitIsDeadOrGhost

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
			for k, v in pairs(ni.object) do
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

		if ni.object[t] and ni.object[t].ttd ~= nil then
			return ni.object[t].ttd
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
				t = ni.om.oGUID(tmp)
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
			for k, v in pairs(ni.object) do
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
			for k, v in pairs(ni.object) do
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
				for k, v in pairs(ni.object) do
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
				for k, v in pairs(ni.object) do
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
	end
}
