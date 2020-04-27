local getGlyphSocketInfo,
	getContainerNumSlots,
	getContainerItemID,
	getItemSpell,
	getInventoryItemID,
	getItemCooldown,
	getSpellCooldown,
	getTime,
	unitClass,
	isFalling,
	unitExists,
	isSpellInRange =
	getGlyphSocketInfo,
	getContainerNumSlots,
	getContainerItemID,
	getItemSpell,
	getInventoryItemID,
	getItemCooldown,
	getSpellCooldown,
	getTime,
	unitClass,
	isFalling,
	unitExists,
	isSpellInRange

ni.player = {
	debuffType = function(str)
		return ni.unit.debuffType("player", str)
	end,
	buffType = function(str)
		return ni.unit.buffType("player", str)
	end,
	debuff = function(spellID, caster, exact)
		return ni.unit.debuff("player", spellID, caster, exact)
	end,
	debuffs = function(spellIDs, caster)
		return ni.unit.debuffs("player", spellIDs, caster)
	end,
	buff = function(spellID, caster, exact)
		return ni.unit.buff("player", spellID, caster, exact)
	end,
	buffs = function(spellIDs, caster)
		return ni.unit.buffs("player", spellIDs, caster)
	end,
	aura = function(spellID)
		return ni.unit.aura("player", spellID)
	end,
	isFacing = function(t)
		return ni.unit.isFacing("player", t)
	end,
	loS = function(t)
		return ni.unit.loS("player", t)
	end,
	creations = function()
		return ni.unit.creations("player")
	end,
	isBehind = function(t)
		return ni.unit.isBehind("player", t)
	end,
	unitsTargeting = function(f)
		local f = f and true or false
		return ni.unit.unitsTargeting("player", f)
	end,
	distance = function(t)
		return ni.unit.distance("player", t)
	end,
	enemiesInRange = function(f)
		return ni.unit.enemiesInRange("player", f)
	end,
	friendsInRange = function(f)
		return ni.unit.friendsInRange("player", f)
	end,
	moveTo = function(...)
		local f = ...
		if f == nil then
			return
		end
		ni.functions.moveTo(...)
	end,
	clickTerrain = function(...)
		local f = ...
		if f == nil then
			return
		end
		ni.functions.clickAt(...)
	end,
	stopMoving = function()
		ni.functions.stopMoving()
	end,
	lookAt = function(t, inv)
		if t == nil then
			return
		end
		ni.functions.lookAt(t, inv)
	end,
	target = function(t)
		if t == nil then
			return
		end
		ni.functions.setTarget(t)
	end,
	runText = function(...)
		local t = ...
		if t == nil then
			return
		end
		ni.functions.runText(...)
	end,
	useItem = function(...)
		local t = ...
		if t == nil then
			return
		end
		ni.functions.item(...)
	end,
	useInventoryItem = function(...)
		local t = ...
		if t == nil then
			return
		end
		ni.functions.inventoryItem(...)
	end,
	interact = function(t)
		if t == nil then
			return
		end
		ni.functions.interact(t)
	end,
	isCasting = function()
		return ni.unit.isCasting("player")
	end,
	hasGlyph = function(glyphID)
		local hasglyph = false
		local i = 1
		local glyph = getGlyphSocketInfo(i)
		while glyph do
			local id = select(3, getGlyphSocketInfo(i))
			if id == glyphID then
				hasglyph = true
				break
			end
			i = i + 1
			glyph = getGlyphSocketInfo(i)
		end
		return hasglyph
	end,
	hasItem = function(item)
		local hasitem = false
		for b = 0, 4 do
			for s = 1, getContainerNumSlots(b) do
				if getContainerItemID(b, s) == item then
					hasitem = true
					break
				end
			end
		end
		return hasitem
	end,
	itemEquipped = function(id)
		local itemequipped = false
		for i = 1, 19 do
			if getInventoryItemID("player", i) == id then
				itemequipped = true
				break
			end
		end
		return itemequipped
	end,
	slotCd = function(slotnum)
		if getItemSpell(GetInventoryItemID("player", slotnum)) == nil then
			return true
		end
		local start, duration, enable = getItemCooldown(GetInventoryItemID("player", slotnum))
		if (start > 0 and duration > 0) then
			return true
		else
			return false
		end
	end,
	itemCd = function(item)
		local start, duration, enable = getItemCooldown(item)
		if (start > 0 and duration > 0) then
			return start + duration - getTime()
		end

		return 0
	end,
	petCd = function(spell)
		local start, duration, enable = getSpellCooldown(spell)
		if (start > 0 and duration > 0) then
			return start + duration - getTime()
		else
			return 0
		end
	end,
	canHeal = function(t)
		local _, class = unitClass("player")
		local heal = nil

		if class == "PALADIN" then
			heal = "Holy light"
		elseif class == "PRIEST" then
			heal = "Renew"
		elseif class == "DRUID" then
			heal = "Healing touch"
		elseif class == "SHAMAN" then
			heal = "Healing wave"
		elseif class == "MONK" then
			heal = "Healing surge"
		end

		if unitExists(t) and isSpellInRange(heal, t) == 1 then
			return true
		end

		return false
	end,
	hasHeal = function()
		local _, class = unitClass("player")
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
	isMoving = function()
		if ni.unit.isMoving("player") or isFalling() then
			return true
		end

		return false
	end,
	hp = function()
		return ni.unit.hp("player")
	end
}
