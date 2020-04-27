local GetGlyphSocketInfo,
	GetContainerNumSlots,
	GetContainerItemID,
	GetItemSpell,
	GetInventoryItemID,
	GetItemCooldown,
	GetSpellCooldown,
	GetTime,
	UnitClass,
	IsFalling,
	UnitExists,
	IsSpellInRange =
	GetGlyphSocketInfo,
	GetContainerNumSlots,
	GetContainerItemID,
	GetItemSpell,
	GetInventoryItemID,
	GetItemCooldown,
	GetSpellCooldown,
	GetTime,
	UnitClass,
	IsFalling,
	UnitExists,
	IsSpellInRange

ni.player = {
	DebuffType = function(str)
		return ni.debuff.HasType("player", str)
	end,
	BuffType = function(str)
		return ni.buff.HasType("player", str)
	end,
	Debuff = function(spellID, caster, exact)
		return ni.debuff.Has("player", spellID, caster, exact)
	end,
	Debuffs = function(spellIDs, caster)
		return ni.debuff.HasMany("player", spellIDs, caster)
	end,
	Buff = function(spellID, caster, exact)
		return ni.buff.Has("player", spellID, caster, exact)
	end,
	Buffs = function(spellIDs, caster)
		return ni.buff.HasMany("player", spellIDs, caster)
	end,
	Aura = function(spellID)
		return ni.aura.Has("player", spellID)
	end,
	IsFacing = function(t)
		return ni.unit.IsFacing("player", t)
	end,
	LoS = function(t)
		return ni.unit.LoS("player", t)
	end,
	Creations = function()
		return ni.unit.Creations("player")
	end,
	IsBehind = function(t)
		return ni.unit.IsBehind("player", t)
	end,
	UnitsTargeting = function(f)
		local f = f and true or false
		return ni.unit.UnitsTargeting("player", f)
	end,
	Distance = function(t)
		return ni.unit.Distance("player", t)
	end,
	EnemiesInRange = function(f)
		return ni.unit.EnemiesInRange("player", f)
	end,
	FriendsInRange = function(f)
		return ni.unit.FriendsInRange("player", f)
	end,
	MoveTo = function(...)
		local f = ...
		if f == nil then
			return
		end
		ni.functions.MoveTo(...)
	end,
	ClickTerrain = function(...)
		local f = ...
		if f == nil then
			return
		end
		ni.functions.ClickAt(...)
	end,
	StopMoving = function()
		ni.functions.StopMoving()
	end,
	LookAt = function(t, inv)
		if t == nil then
			return
		end
		ni.functions.LookAt(t, inv)
	end,
	Target = function(t)
		if t == nil then
			return
		end
		ni.functions.SetTarget(t)
	end,
	RunText = function(...)
		local t = ...
		if t == nil then
			return
		end
		ni.functions.RunText(...)
	end,
	UseItem = function(...)
		local t = ...
		if t == nil then
			return
		end
		ni.functions.Item(...)
	end,
	UseInventoryItem = function(...)
		local t = ...
		if t == nil then
			return
		end
		ni.functions.InventoryItem(...)
	end,
	Interact = function(t)
		if t == nil then
			return
		end
		ni.functions.Interact(t)
	end,
	IsCasting = function()
		return ni.unit.IsCasting("player")
	end,
	HasGlyph = function(glyphID)
		local hasglyph = false
		local i = 1
		local glyph = GetGlyphSocketInfo(i)
		while glyph do
			local id = select(3, GetGlyphSocketInfo(i))
			if id == glyphID then
				hasglyph = true
				break
			end
			i = i + 1
			glyph = GetGlyphSocketInfo(i)
		end
		return hasglyph
	end,
	HasItem = function(item)
		local hasitem = false
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				if GetContainerItemID(b, s) == item then
					hasitem = true
					break
				end
			end
		end
		return hasitem
	end,
	ItemEquipped = function(id)
		local itemequipped = false
		for i = 1, 19 do
			if GetInventoryItemID("player", i) == id then
				itemequipped = true
				break
			end
		end
		return itemequipped
	end,
	SlotCd = function(slotnum)
		if GetItemSpell(GetInventoryItemID("player", slotnum)) == nil then
			return true
		end
		local start, duration, enable = GetItemCooldown(GetInventoryItemID("player", slotnum))
		if (start > 0 and duration > 0) then
			return true
		else
			return false
		end
	end,
	ItemCd = function(item)
		local start, duration, enable = GetItemCooldown(item)
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		end

		return 0
	end,
	PetCd = function(spell)
		local start, duration, enable = GetSpellCooldown(spell)
		if (start > 0 and duration > 0) then
			return start + duration - GetTime()
		else
			return 0
		end
	end,
	CanHeal = function(t)
		local _, class = UnitClass("player")
		local heal = nil

		if class == "PALADIN" then
			heal = "Holy Light"
		elseif class == "PRIEST" then
			heal = "Renew"
		elseif class == "DRUID" then
			heal = "Healing Touch"
		elseif class == "SHAMAN" then
			heal = "Healing Wave"
		elseif class == "MONK" then
			heal = "Healing Surge"
		end

		if UnitExists(t) and IsSpellInRange(heal, t) == 1 then
			return true
		end

		return false
	end,
	HasHeal = function()
		local _, class = UnitClass("player")
		local has = false

		if class == "PALADIN" then
			has = true
		elseif class == "PRIEST" then
			has = true
		elseif class == "DRUID" then
			has = true
		elseif class == "SHAMAN" then
			has = true
		end

		return has
	end,
	IsMoving = function()
		if ni.unit.IsMoving("player") or IsFalling() then
			return true
		end

		return false
	end,
	Hp = function()
		return ni.unit.Hp("player")
	end
}
