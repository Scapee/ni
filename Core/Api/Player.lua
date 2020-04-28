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

local _, class = UnitClass("player");

ni.player = {
	debufftype = function(string)
		return ni.unit.debufftype("player", string)
	end,
	bufftype = function(string)
		return ni.unit.bufftype("player", string)
	end,
	debuff = function(spell, caster, exact) --id or name
		return ni.unit.debuff("player", spell, caster, exact)
	end,
	debuffs = function(spells, caster) --passed as string of ids or names separated by |
		return ni.unit.debuffs("player", spells, caster)
	end,
	buff = function(spell, caster, exact) --id or name
		return ni.unit.buff("player", spell, caster, exact)
	end,
	buffs = function(spells, caster) --passed as string of ids or names separated by |
		return ni.unit.buffs("player", spells, caster)
	end,
	aura = function(spellid)
		return ni.unit.aura("player", spellid)
	end,
	isfacing = function(target)
		return ni.unit.isfacing("player", target)
	end,
	los = function(target)
		return ni.unit.los("player", target)
	end,
	creations = function()
		return ni.unit.creations("player")
	end,
	isbehind = function(target)
		return ni.unit.isbehind("player", target)
	end,
	unitstargeting = function(friendlies)
		local freindlies = true and friendlies or false
		return ni.unit.unitstargeting("player", friendlies)
	end,
	distance = function(target)
		return ni.unit.distance("player", target)
	end,
	enemiesinrange = function(radius)
		return ni.unit.enemiesinrange("player", radius)
	end,
	friendsinrange = function(radius)
		return ni.unit.friendsinrange("player", radius)
	end,
	moveto = function(...) --target/x,y,z
		ni.functions.moveto(...)
	end,
	clickat = function(...) --target/x,y,z/mouse
		ni.functions.clickat(...)
	end,
	stopmoving = function()
		ni.functions.stopmoving()
	end,
	lookat = function(target, inv) --inv true to look away
		ni.functions.lookat(target, inv)
	end,
	target = function(target)
		ni.functions.settarget(target)
	end,
	runtext = function(text)
		ni.functions.runtext(text)
	end,
	useitem = function(...) --itemid/name[, target]
		ni.functions.item(...)
	end,
	useinventoryitem = function(slotid)
		ni.functions.inventoryitem(slotid)
	end,
	interact = function(target)
		ni.functions.interact(target)
	end,
	iscasting = function()
		return ni.unit.iscasting("player")
	end,
	hasglyph = function(glyphid)
		for i = 1, 6 do
			if GetGlyphSocketInfo(i) then
				if select(3, GetGlyphSocketInfo(i)) == glyphid then
					return true;
				end
			end
		end
		return false;
	end,
	hasitem = function(itemid)
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				if GetContainerItemID(b, s) == itemid then
					return true;
				end
			end
		end
		return false;
	end,
	itemequipped = function(id)
		for i = 1, 19 do
			if GetInventoryItemID("player", i) == id then
				return true;
			end
		end
		return false;
	end,
	slotcd = function(slotnum)
		if GetItemSpell(GetInventoryItemID("player", slotnum)) == nil then
			return true;
		end
		local start, duration, enable = GetItemCooldown(GetInventoryItemID("player", slotnum));
		if (start > 0 and duration > 0) then
			return true;
		else
			return false;
		end
	end,
	itemcd = function(item)
		local start, duration, enable = GetItemCooldown(item);
		if (start > 0 and duration > 0) then
			return start + duration - GetTime();
		end
		return 0;
	end,
	petcd = function(spell)
		local start, duration, enable = GetSpellCooldown(spell, "pet");
		if (start > 0 and duration > 0) then
			return start + duration - GetTime();
		else
			return 0;
		end
	end,
	canheal = function(target)
		if UnitExists(target) then
			local heal;
			if class == "PALADIN" then
				heal = "Holy Light";
			elseif class == "PRIEST" then
				heal = "Renew";
			elseif class == "DRUID" then
				heal = "Healing Touch";
			elseif class == "SHAMAN" then
				heal = "Healing Wave";
			end
			if heal ~= nil and IsSpellInRange(heal, target) == 1 then
				return true;
			end
		end
		return false;
	end,
	hasheal = function()
		if class == "PALADIN" then
			return true;
		elseif class == "PRIEST" then
			return true;
		elseif class == "DRUID" then
			return true;
		elseif class == "SHAMAN" then
			return true;
		end
		return false;
	end,
	ismoving = function()
		if ni.unit.ismoving("player") or IsFalling() then
			return true
		end
		return false;
	end,
	hp = function()
		return ni.unit.hp("player");
	end
}