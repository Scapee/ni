local createFrame = createFrame

ni.frames.healing = createFrame("frame", nil)
ni.frames.healing:registerEvent("PARTY_MEMBERS_CHANGED")
ni.frames.healing:registerEvent("RAID_ROSTER_UPDATE")
ni.frames.healing:registerEvent("GROUP_ROSTER_UPDATE")
ni.frames.healing:registerEvent("PARTY_CONVERTED_TO_RAID")
ni.frames.healing:registerEvent("ZONE_CHANGED")
ni.frames.healing:registerEvent("PLAYER_ENTERING_WORLD")
ni.frames.healing_OnUpdate = function()
	table.wipe(ni.members)
	table.wipe(ni.memberSetup.cache)
	ni.setupTables()
end
