local  UnitName, GetTime = UnitName, GetTime;

ni.frames.CombatLogFrame = CreateFrame('Frame');
ni.frames.CombatLogFrame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_SENT');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_STOP');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_FAILED');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_FAILED_QUIET');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START');
ni.frames.CombatLogFrame:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP');
ni.frames.CombatLogFrame:RegisterEvent('PLAYER_REGEN_ENABLED');
ni.frames.CombatLogFrame:RegisterEvent('PLAYER_REGEN_DISABLED');
ni.frames.CombatLogFrame_OnEvent =  function(self, event, ...)
	if event == 'PLAYER_REGEN_DISABLED' then
	  ni.combat.started = true;
	  ni.combat.time = GetTime();
	end
	if event == 'PLAYER_REGEN_ENABLED' then
	  ni.combat.started = false;
	  ni.combat.time = 0;
	end
	if (event == 'UNIT_SPELLCAST_SENT' or event == 'UNIT_SPELLCAST_CHANNEL_START') and ni.vars.CastStarted == false then
	  local unit, spell = ...;
	  if unit == 'player' then
		ni.vars.CastStarted = true;
	  end
	end
	if (event == 'UNIT_SPELLCAST_SUCCEEDED'
	 or event == 'UNIT_SPELLCAST_FAILED'
	 or event == 'UNIT_SPELLCAST_FAILED_QUIET'
	 or event == 'UNIT_SPELLCAST_INTERRUPTED'
	 or event == 'UNIT_SPELLCAST_CHANNEL_STOP'
	 or event == 'UNIT_SPELLCAST_STOP')
	 and ni.vars.CastStarted == true then
	  local unit, spell = ...;
	  if unit == 'player' then
		if ni.vars.CastStarted then
			ni.vars.CastStarted = false;
		end
	  end
	end
	if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
	  local _, subevent, _, source, _, _, dest, _, spellID, spellName = ...;
	  if source == UnitName('player') then
		if subevent == 'SPELL_CAST_SUCCESS' or subevent == 'SPELL_CAST_FAILED' then
		  if ni.vars.CastStarted then
			ni.vars.CastStarted = false;
		 end
		end
	  end
	end
end);