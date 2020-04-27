local isLeftShiftKeyDown,
	getCurrentKeyBoardFocus,
	getTime,
	isLeftControlKeyDown,
	isLeftAltKeyDown,
	isRightShiftKeyDown,
	isRightControlKeyDown,
	isRightAltKeyDown =
	isLeftShiftKeyDown,
	getCurrentKeyBoardFocus,
	getTime,
	isLeftControlKeyDown,
	isLeftAltKeyDown,
	isRightShiftKeyDown,
	isRightControlKeyDown,
	isRightAltKeyDown

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
		if ni.vars.hotkeys.custom == "Left shift" then
			if isLeftShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Left control" then
			if isLeftControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Left alt" then
			if isLeftAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Right shift" then
			if isRightShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Right control" then
			if isRightControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == "Right alt" then
			if isRightAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	cDMod = function()
		if ni.vars.hotkeys.cd == "Left shift" then
			if isLeftShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Left control" then
			if isLeftControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Left alt" then
			if isLeftAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Right shift" then
			if isRightShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Right control" then
			if isRightControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == "Right alt" then
			if isRightAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	cDToggle = function()
		if ni.vars.profiles.enabled then
			if ni.rotation.cdmod() and getTime() - cdtogglemod > 0.5 then
				cdtogglemod = getTime()
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
	aoEMod = function()
		if ni.vars.hotkeys.aoe == "Left shift" then
			if isLeftShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Left control" then
			if isLeftControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Left alt" then
			if isLeftAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Right shift" then
			if isRightShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Right control" then
			if isRightControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == "Right alt" then
			if isRightAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	aoEToggle = function()
		if (ni.vars.profiles.enabled == false or ni.vars.combat.aoe == false) and ni.frames.notification:isShown() then
			ni.frames.notification:hide()
		end
		if ni.rotation.aoEMod() and getTime() - togglemod > 0.5 and ni.vars.profiles.enabled then
			togglemod = getTime()
			if ni.vars.combat.aoe == false then
				ni.message("Area of effect enabled")
				ni.vars.combat.aoe = true
			elseif ni.vars.combat.aoe == true then
				ni.frames.notification:hide()
				ni.vars.combat.aoe = false
			end
		end
	end,
	stopMod = function()
		if ni.vars.hotkeys.pause == "Left shift" then
			if isLeftShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Left control" then
			if isLeftControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Left alt" then
			if isLeftAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Right shift" then
			if isRightShiftKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Right control" then
			if isRightControlKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.pause == "Right alt" then
			if isRightAltKeyDown() and not getCurrentKeyBoardFocus() then
				return true
			end
		end
	end
}
