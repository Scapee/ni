ni.flag = {
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
		return (ni.unit.Exists(t) and select(2, ni.flag.DynamicFlags(t))) or false
	end,
	Lootable = function(t)
		return (ni.unit.Exists(t) and select(3, ni.flag.DynamicFlags(t))) or false
	end,
	TaggedByMe = function(t)
		return (ni.unit.Exists(t) and select(7, ni.flag.DynamicFlags(t))) or false
	end,
	TaggedByOther = function(t)
		return (ni.unit.Exists(t) and select(8, ni.flag.DynamicFlags(t))) or false
	end,
	CanPerformAction = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(1, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(1, ni.flag.Flags(t))) or false
		end
	end,
	Confused = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(23, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(3, ni.flag.Flags(t))) or false
		end
	end,
	Dazed = function(t)
		if ni.vars.build == 30300 then
			return false
		else
			return (ni.unit.Exists(t) and select(4, ni.flag.Flags(t))) or false
		end
	end,
	Disarmed = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(22, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(5, ni.flag.Flags(t))) or false
		end
	end,
	Fleeing = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(24, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(6, ni.flag.Flags(t))) or false
		end
	end,
	Influenced = function(t)
		if ni.vars.build == 30300 then
			return false
		else
			return (ni.unit.Exists(t) and select(7, ni.flag.Flags(t))) or false
		end
	end,
	Looting = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(11, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(8, ni.flag.Flags(t))) or false
		end
	end,
	Mounted = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(28, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(9, ni.flag.Flags(t))) or false
		end
	end,
	NotAttackable = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(2, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(11, ni.flag.Flags(t))) or false
		end
	end,
	NotSelectable = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(26, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(12, ni.flag.Flags(t))) or false
		end
	end,
	Pacified = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(18, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(13, ni.flag.Flags(t))) or false
		end
	end,
	PetInCombat = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(12, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(14, ni.flag.Flags(t))) or false
		end
	end,
	PlayerControlled = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(4, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(15, ni.flag.Flags(t))) or false
		end
	end,
	Possessed = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(25, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(17, ni.flag.Flags(t))) or false
		end
	end,
	Preparation = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(6, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(18, ni.flag.Flags(t))) or false
		end
	end,
	PvPFlagged = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(13, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(19, ni.flag.Flags(t))) or false
		end
	end,
	Silenced = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(14, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(21, ni.flag.Flags(t))) or false
		end
	end,
	Skinnable = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(27, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(23, ni.flag.Flags(t))) or false
		end
	end,
	Stunned = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(19, ni.flag.Flags(t))) or false
		else
			return (ni.unit.Exists(t) and select(24, ni.flag.Flags(t))) or false
		end
	end,
	Immune = function(t)
		if ni.vars.build == 30300 then
			return (ni.unit.Exists(t) and select(32, ni.flag.Flags(t))) or false
		else
			return false
		end
	end
}
