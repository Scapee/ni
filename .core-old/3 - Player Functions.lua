--3 - Player Functions.lua
local version = "1.0.0";
local UnitCastingInfo, GetGlyphSocketInfo, GetContainerNumSlots, GetContainerItemID, GetItemCooldown, GetInventoryItemID, GetTime, GetSpellCooldown, GetRuneCooldown, GetRuneType, UnitClass, UnitExists, IsSpellInRange, IsFalling, UnitPower, UnitPowerMax, tonumber, IsLeftShiftKeyDown, GetCurrentKeyBoardFocus = UnitCastingInfo, GetGlyphSocketInfo, GetContainerNumSlots, GetContainerItemID, GetItemCooldown, GetInventoryItemID, GetTime, GetSpellCooldown, GetRuneCooldown, GetRuneType, UnitClass, UnitExists, IsSpellInRange, IsFalling, UnitPower, UnitPowerMax, tonumber, IsLeftShiftKeyDown, GetCurrentKeyBoardFocus;
ni.player = {
	hasdebufftype = function(str)
		return ni.unit.hasdebufftype("player", str);
	end,
	hasbufftype = function(str)
		return ni.unit.hasbufftype("player", str);
	end,
	isfacing = function(t)
		return ni.unit.isfacing("player", t);
	end,
	los = function(t)
		return ni.unit.los("player", t);
	end,
	creations = function()
		return ni.unit.creations("player");
	end,
	isbehind = function(t)
		return ni.unit.isbehind("player", t);
	end,
	debuff = function(spellID, caster, exact)
		return ni.unit.debuff('player', spellID, caster, exact);
	end,
	debuffs = function(spellIDs, caster)
		return ni.unit.debuffs("player", spellIDs, caster);
	end,
	buff = function(spellID, caster, exact)
		return ni.unit.buff('player', spellID, caster, exact);
	end,
	buffs = function(spellIDs, caster)
		return ni.unit.buffs("player", spellIDs, caster);
	end,
	hasaura = function(spellID)
		return ni.unit.hasaura('player', spellID);
	end,
	unitstargeting = function(f)
		local f = f and true or false;
		return ni.unit.unitstargeting('player', f);
	end,
	unitstargetingtable = function(f)
		local f = f and true or false;
		return ni.unit.unitstargetingtable('player', f);
	end,
	distance = function(t)
		return ni.unit.distance('player', t);
	end,
	enemiesinrange = function(f)
		return ni.unit.enemiesinrange('player', f)
	end,
	friendsinrange = function(f)
		return ni.unit.friendsinrange('player', f)
	end,
	moveto = function(...)
		local f = ...;
		if f == nil then
			return;
		end
		ni.functions.moveto(...);
	end,
	terrainclick = function(...)
		local f = ...;
		if f == nil then
			return;
		end
		ni.functions.clickat(...);
	end,
	stopmoving = function()
		ni.functions.stopmoving();
	end,
	lookat = function(t, inv)
		if t == nil then
			return;
		end
		ni.functions.lookat(t, inv);
	end,
	target = function(t)
		if t == nil then
			return;
		end
		ni.functions.settarget(t);
	end,
	runtext = function(...)
		local t = ...;
		if t == nil then
			return;
		end
		ni.functions.runtext(...);
	end,
	useitem = function(...)
		local t = ...;
		if t == nil then
			return;
		end
		ni.functions.item(...);
	end,
	useinventoryitem = function(...)
		local t = ...;
		if t == nil then
			return;
		end
		ni.functions.inventoryitem(...);
	end,
	interact = function(t)
		if t == nil then
			return;
		end
		ni.functions.interact(t);
	end,
	iscasting = function(t)
		local result = false;
		local name, _, _, _, _, _, _, id = UnitCastingInfo('player');
		if name and id == t then
			result = true;
		end
		return result;
	end,
	glyph = function(glyphID)
		local hasglyph = false;
		local i = 1;
		local glyph = GetGlyphSocketInfo(i);
		while glyph do
			local id = select(3, GetGlyphSocketInfo(i));
			if id == glyphID then
				hasglyph = true;
				break;
			end
			i = i + 1;
			glyph = GetGlyphSocketInfo(i);
		end
		return hasglyph;
	end,
	hasitem = function(item)
		local hasitem = false;
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				if GetContainerItemID(b, s) == item then
					hasitem = true;
					break;
				end
			end
		end
		return hasitem;
	end,
	itemequipped = function(id)
		local itemequipped = false;
		for i = 1, 19 do
			if GetInventoryItemID("player", i) == id then
				itemequipped = true;
				break;
			end
		end
		return itemequipped;
	end,
	itemcd = function(item)
		local start, duration, enable = GetItemCooldown(item);
		if (start > 0 and duration > 0) then
			return true;
		else
			return false;
		end
	end,
	slotcd = function(slotnum)
		if GetItemSpell(GetInventoryItemID('player', slotnum)) == nil then
			return true;
		end
		local start, duration, enable = GetItemCooldown(GetInventoryItemID('player', slotnum));
		if (start > 0 and duration > 0) then
			return true;
		else
			return false;
		end
	end,
	itemcdremains = function(item)
		local start, duration, enable = GetItemCooldown(item);
		if (start > 0 and duration > 0) then
			return start + duration - GetTime();
		else
			return 0;
		end
	end,
	petcd = function(spell)
		local start, duration, enable = GetSpellCooldown(spell)
		if ( start > 0 and duration > 0 ) then
			return true
		else
			return false
		end
	end,
	petcdremains = function(spell)
		local start, duration, enable = GetSpellCooldown(spell)
		if ( start > 0 and duration > 0 ) then
			return start + duration - GetTime()
		else
			return 0
		end
	end,
	runecdremains = function(rune)
		local s, d, i = GetRuneCooldown(rune)
		if i == true then return 0 end
		if s ~= 0 then
			return s + d - GetTime()
		else
			return 0
		end
	end,
	runecd = function()
		local RunesOnCD = 0
		for i=1, 6 do
			if select(3, GetRuneCooldown(i)) == false then
				RunesOnCD = RunesOnCD + 1
			end
		end
		return RunesOnCD
	end,
	deathrunecd = function()
		local DRunesOnCD = 0
		local DRunesOffCD = 0
		for i=1, 6 do
			if GetRuneType(i) == 4 and select(3, GetRuneCooldown(i)) == false then
				DRunesOnCD = DRunesOnCD + 1
			elseif GetRuneType(i) == 4 and select(3, GetRuneCooldown(i)) == true then
				DRunesOffCD = DRunesOffCD + 1
			end
		end
		return DRunesOnCD, DRunesOffCD
	end,
	frostrunecd = function()
		local FRunesOnCD = 0
		local FRunesOffCD = 0
		for i=1, 6 do
			if GetRuneType(i) == 2 and select(3, GetRuneCooldown(i)) == false then
				FRunesOnCD = FRunesOnCD + 1
			elseif GetRuneType(i) == 2 and select(3, GetRuneCooldown(i)) == true then
				FRunesOffCD = FRunesOffCD + 1
			end
		end
		return FRunesOnCD, FRunesOffCD
	end,
	unholyrunecd = function()
		local URunesOnCD = 0
		local URunesOffCD = 0
		for i=1, 6 do
			if GetRuneType(i) == 3 and select(3, GetRuneCooldown(i)) == false then
				URunesOnCD = URunesOnCD + 1
			elseif GetRuneType(i) == 3 and select(3, GetRuneCooldown(i)) == true then
				URunesOffCD = URunesOffCD + 1
			end
		end
		return URunesOnCD, URunesOffCD
	end,
	bloodrunecd = function()
		local BRunesOnCD = 0
		local BRunesOffCD = 0
		for i=1, 6 do
			if GetRuneType(i) == 1 and select(3, GetRuneCooldown(i)) == false then
				BRunesOnCD = BRunesOnCD + 1
			elseif GetRuneType(i) == 1 and select(3, GetRuneCooldown(i)) == true then
				BRunesOffCD = BRunesOffCD + 1
			end
		end
		return BRunesOnCD, BRunesOffCD
	end,
	canheal = function(t)
		local _, class = UnitClass('player');
		local heal = nil;
		if class == 'PALADIN' then
			heal = 'Holy Light'
		elseif class == 'PRIEST' then
			heal = 'Renew'
		elseif class == 'DRUID' then
			heal = 'Healing Touch'
		elseif class == 'SHAMAN' then
			heal = 'Healing Wave'
		elseif class == 'MONK' then
			heal = 'Healing Surge'
		end
		if UnitExists(t)
		 and IsSpellInRange(heal, t) == 1 then
			return true
		else
			return false
		end
	end,
	hasheal = function()
		local _, class = UnitClass('player');
		local has = false
		if class == 'PALADIN' then
			has = true
		elseif class == 'PRIEST' then
			has = true
		elseif class == 'DRUID' then
			has = true
		elseif class == 'SHAMAN' then
			has = true
		end
		return has
	end,
	ismoving = function()
		if ni.unit.ismoving('player') or IsFalling() then
			return true
		else
			return false
		end
	end,
	powertypes = {
		['mana'] = 0,
		['rage'] = 1,
		['focus'] = 2,
		['energy'] = 3,
		['combopoints'] = 4,
		['runes'] = 5,
		['runicpower'] = 6,
		['soulshards'] = 7,
		['eclipse'] = 8,
		['holy'] = 9,
		['alternate'] = 10,
		['darkforce'] = 11,
		['chi'] = 12,
		['shadoworbs'] = 13,
		['burningembers'] = 14,
		['demonicfury'] = 15
	},
	hp = function()
		return 100*UnitHealth('player')/UnitHealthMax('player')
	end,
	mana = function()
		return 100*UnitMana('player')/UnitManaMax('player')
	end,
	power = function(t)
		if tonumber(t) == nil then
			t = ni.player.powertypes[t]
		end
		return UnitPower('player', t);
	end,
	powermax = function(t)
		if tonumber(t) == nil then
			t = ni.player.powertypes[t]
		end
		return UnitPowerMax('player', t);
	end,
	ismaxpower = function(t)
		if tonumber(t) == nil then
			t = ni.player.powertypes[t]
		end
		return UnitPower('player', t) == UnitPowerMax('player', t);
	end,
	stopmod = function()
		if ni.vars.hotkeys.pause == 'Left Shift' then
			if IsLeftShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == 'Left Control' then
			if IsLeftControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == 'Left Alt' then
			if IsLeftAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == 'Right Shift' then
			if IsRightShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == 'Right Control' then
			if IsRightControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == 'Right Alt' then
			if IsRightAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end
};