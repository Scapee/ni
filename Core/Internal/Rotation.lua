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
		ni.vars.profiles.enabled = false
		ni.showstatus(ni.vars.profiles.active)
	end,
	loadLua = function(...)
		local s = ...
		if s ~= nil then
			return ni.functions.loadLua(s)
		end
	end,
	customMod = function()
		if ni.vars.hotkeys.custom == "Left Shift" then
			if IsLeftShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Left Control" then
			if IsLeftControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Left Alt" then
			if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Right Shift" then
			if IsRightShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Right Control" then
			if IsRightControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Right Alt" then
			if IsRightAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	cdMod = function()
		if ni.vars.hotkeys.cd == "Left Shift" then
			if IsLeftShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Left Control" then
			if IsLeftControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Left Alt" then
			if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Right Shift" then
			if IsRightShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Right Control" then
			if IsRightControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Right Alt" then
			if IsRightAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	cdToggle = function()
		if ni.vars.profiles.enabled then
			if ni.rotation.cdMod() and GetTime() - cdtogglemod > 0.5 then
				cdtogglemod = GetTime()
				if ni.vars.combat.cd then
					ni.vars.combat.cd = false
					ni.floatingText:message("Cooldown toggle: \124cffff0000Disabled")
				else
					ni.vars.combat.cd = true
					ni.floatingText:message("Cooldown toggle: \124cff00ff00Enabled")
				end
			end
		end
	end,
	aoeMod = function()
		if ni.vars.hotkeys.aoe == "Left Shift" then
			if IsLeftShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Left Control" then
			if IsLeftControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Left Alt" then
			if IsLeftAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Right Shift" then
			if IsRightShiftKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Right Control" then
			if IsRightControlKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Right Alt" then
			if IsRightAltKeyDown() and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	aoeToggle = function()
		if (ni.vars.profiles.enabled == false or ni.vars.combat.aoe == false) and ni.frames.notification:isShown() then
			ni.frames.notification:hide()
		end
		if ni.rotation.aoEMod() and GetTime() - togglemod > 0.5 and ni.vars.profiles.enabled then
			togglemod = GetTime()
			if ni.vars.combat.aoe == false then
				ni.message("Area of Effect Enabled")
				ni.vars.combat.aoe = true
			elseif ni.vars.combat.aoe == true then
				ni.frames.notification:hide()
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
