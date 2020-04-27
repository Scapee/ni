local UnitName, GetTime, CreateFrame = UnitName, GetTime, CreateFrame

ni.frames.CombatLog = CreateFrame("Frame")
ni.frames.CombatLog:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_SENT")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_STOP")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_FAILED")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
ni.frames.CombatLog:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
ni.frames.CombatLog:RegisterEvent("PLAYER_REGEN_ENABLED")
ni.frames.CombatLog:RegisterEvent("PLAYER_REGEN_DISABLED")
ni.frames.CombatLog_OnEvent = function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		ni.vars.combat.started = true
		ni.vars.combat.time = GetTime()
	end
	if event == "PLAYER_REGEN_ENABLED" then
		ni.vars.combat.started = false
		ni.vars.combat.time = 0
	end
	if (event == "UNIT_SPELLCAST_SENT" or event == "UNIT_SPELLCAST_CHANNEL_START") and ni.vars.combat.casting == false then
		local unit, spell = ...
		if unit == "player" then
			ni.vars.combat.casting = true
		end
	end
	if
		(event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_FAILED_QUIET" or
			event == "UNIT_SPELLCAST_INTERRUPTED" or
			event == "UNIT_SPELLCAST_CHANNEL_STOP" or
			event == "UNIT_SPELLCAST_STOP") and
			ni.vars.combat.casting == true
	 then
		local unit, spell = ...
		if unit == "player" then
			if ni.vars.combat.casting then
				ni.vars.combat.casting = false
			end
		end
	end
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subevent, _, source, _, _, dest, _, spellID, spellName = ...
		if source == UnitName("player") then
			if subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_CAST_FAILED" then
				if ni.vars.combat.casting then
					ni.vars.combat.casting = false
				end
			end
		end
	end
end