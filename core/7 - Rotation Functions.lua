--7 - Rotation Functions.lua
local version = "1.0.0";
local IsLeftShiftKeyDown, GetCurrentKeyBoardFocus, GetTime = IsLeftShiftKeyDown, GetCurrentKeyBoardFocus, GetTime;
local togglemod, cdtogglemod, customtogglemod = 0, 0, 0;
ni.rotation = { 
	stop = function()
		ni.vars.profiles.enabled = false;
		ni.showstatus(ni.vars.profiles.active);
	end,
	loadlua = function(...)
		local s = ...;
		if s ~= nil then
			return ni.functions.loadlua(s);
		end
	end,
    custommod = function()
		if ni.vars.hotkeys.custom == 'Left Shift' then
			if IsLeftShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == 'Left Control' then
			if IsLeftControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == 'Left Alt' then
			if IsLeftAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == 'Right Shift' then
			if IsRightShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == 'Right Control' then
			if IsRightControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.custom == 'Right Alt' then
			if IsRightAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	cdmod = function()
		if ni.vars.hotkeys.cd == 'Left Shift' then
			if IsLeftShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == 'Left Control' then
			if IsLeftControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == 'Left Alt' then
			if IsLeftAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == 'Right Shift' then
			if IsRightShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == 'Right Control' then
			if IsRightControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.cd == 'Right Alt' then
			if IsRightAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	CDtoggle = function()
		if ni.vars.profiles.enabled then
		  if ni.rotation.cdmod() and GetTime() - cdtogglemod > 0.5 then
			cdtogglemod = GetTime()
			if ni.vars.CD then
			  ni.vars.CD = false
			  ni.FloatingText:Message('Cooldown toggle: \124cffff0000Disabled');
			else
			  ni.vars.CD = true
			  ni.FloatingText:Message('Cooldown toggle: \124cff00ff00Enabled');
			end
		  end
		end
	end,
	aoemod = function()
		if ni.vars.hotkeys.aoe == 'Left Shift' then
			if IsLeftShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == 'Left Control' then
			if IsLeftControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == 'Left Alt' then
			if IsLeftAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == 'Right Shift' then
			if IsRightShiftKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == 'Right Control' then
			if IsRightControlKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		elseif ni.vars.hotkeys.aoe == 'Right Alt' then
			if IsRightAltKeyDown()
			 and not GetCurrentKeyBoardFocus() then
				return true
			end
		end
	end,
	AoEtoggle = function()
		if (ni.vars.profiles.enabled == false or ni.vars.AoE == false) and ni.notification:IsShown() then
			ni.notification:Hide();
		end
		if ni.rotation.aoemod() and GetTime() - togglemod > 0.5 and ni.vars.profiles.enabled then
			togglemod = GetTime();
			if ni.vars.AoE == false then
                ni.message('Area of Effect Enabled');
				ni.vars.AoE = true;
			elseif ni.vars.AoE == true then
    			ni.notification:Hide();
				ni.vars.AoE = false;
			end
		end
	end
}