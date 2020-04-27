--8 - Combat Log.lua
local version = "1.0.0";
local UnitClass, UnitName, GetTime = UnitClass, UnitName, GetTime;
local _, class = UnitClass('player');
ni.CombatLog = CreateFrame('Frame');
ni.CombatLog:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_SENT');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_STOP');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_FAILED');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_FAILED_QUIET');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_INTERRUPTED');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START');
ni.CombatLog:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP');
ni.CombatLog:RegisterEvent('PLAYER_REGEN_ENABLED');
ni.CombatLog:RegisterEvent('PLAYER_REGEN_DISABLED');
ni.CombatLog:SetScript('OnEvent', function(self, event, ...)
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