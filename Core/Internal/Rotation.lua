local IsLeftShiftKeyDown,
	GetCurrentKeyBoardFocus,
	GetTime,
	IsLeftControlKeyDown,
	IsLeftAltKeyDown,
	IsRightShiftKeyDown,
	IsRightControlKeyDown,
	IsRightAltKeyDown =
	IsLeftShiftKeyDown,
	GetCurrentKeyBoardFocus,
	GetTime,
	IsLeftControlKeyDown,
	IsLeftAltKeyDown,
	IsRightShiftKeyDown,
	IsRightControlKeyDown,
	IsRightAltKeyDown

local togglemod, cdtogglemod, customtogglemod = 0, 0, 0

ni.rotation = {
	started = false,
	stop = function()
		ni.vars.profiles.enabled = false;
		ni.showstatus(ni.vars.profiles.active);
	end,
	custommod = function()
		local mod = ni.vars.hotkeys.custom;
		if mod == "Left Shift" then
			if IsLeftShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Left Control" then
			if IsLeftControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Left Alt" then
			if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Shift" then
			if IsRightShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Control" then
			if IsRightControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Alt" then
			if IsRightAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		end
		return false;
	end,
	cdmod = function()
		local mod = ni.vars.hotkeys.cd;
		if mod == "Left Shift" then
			if IsLeftShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Left Control" then
			if IsLeftControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Left Alt" then
			if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Shift" then
			if IsRightShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Control" then
			if IsRightControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Alt" then
			if IsRightAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		end
		return false;
	end,
	cdtoggle = function()
		if ni.vars.profiles.enabled then
			if ni.rotation.cdmod() and GetTime() - cdtogglemod > 0.5 then
				cdtogglemod = GetTime()
				if ni.vars.combat.cd then
					ni.vars.combat.cd = false
					ni.floatingtext:message("Cooldown toggle: \124cffff0000Disabled")
				else
					ni.vars.combat.cd = true
					ni.floatingtext:message("Cooldown toggle: \124cff00ff00Enabled")
				end
			end
		end
	end,
	aoemod = function()
		local mod = ni.vars.hotkeys.aoe;
		if mod == "Left Shift" then
			if IsLeftShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Left Control" then
			if IsLeftControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Left Alt" then
			if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Shift" then
			if IsRightShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Control" then
			if IsRightControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		elseif mod == "Right Alt" then
			if IsRightAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true;
			end
		end
		return false;
	end,
	aoeToggle = function()
		if (ni.vars.profiles.enabled == false or ni.vars.combat.aoe == false) and ni.frames.notification:IsShown() then
			ni.frames.notification:Hide()
		end
		if ni.rotation.aoemod() and GetTime() - togglemod > 0.5 and ni.vars.profiles.enabled then
			togglemod = GetTime()
			if ni.vars.combat.aoe == false then
				ni.frames.notification:message("Area of Effect Enabled")
				ni.vars.combat.aoe = true
			elseif ni.vars.combat.aoe == true then
				ni.frames.notification:Hide()
				ni.vars.combat.aoe = false
			end
		end
	end,
	stopMod = function()
		if ni.vars.hotkeys.pause == "Left Shift" then
			if IsLeftShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Left Control" then
			if IsLeftControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Left Alt" then
			if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Right Shift" then
			if IsRightShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Right Control" then
			if IsRightControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Right Alt" then
			if IsRightAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end
}
