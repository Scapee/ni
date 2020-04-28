local CreateFrame = CreateFrame

ni.frames.healing = CreateFrame("frame", nil)
ni.frames.healing:RegisterEvent("PARTY_MEMBERS_CHANGED")
ni.frames.healing:RegisterEvent("RAID_ROSTER_UPDATE")
ni.frames.healing:RegisterEvent("GROUP_ROSTER_UPDATE")
ni.frames.healing:RegisterEvent("PARTY_CONVERTED_TO_RAID")
ni.frames.healing:RegisterEvent("ZONE_CHANGED")
ni.frames.healing:RegisterEvent("PLAYER_ENTERING_WORLD")
ni.frames.healing_OnUpdate = function()
	table.wipe(ni.members)
	table.wipe(ni.memberSetup.cache)
	ni.setupTables()
end
