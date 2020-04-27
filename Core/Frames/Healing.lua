local CreateFrame = CreateFrame

ni.frames.Healing = CreateFrame("frame", nil)
ni.frames.Healing:RegisterEvent("PARTY_MEMBERS_CHANGED")
ni.frames.Healing:RegisterEvent("RAID_ROSTER_UPDATE")
ni.frames.Healing:RegisterEvent("GROUP_ROSTER_UPDATE")
ni.frames.Healing:RegisterEvent("PARTY_CONVERTED_TO_RAID")
ni.frames.Healing:RegisterEvent("ZONE_CHANGED")
ni.frames.Healing:RegisterEvent("PLAYER_ENTERING_WORLD")
ni.frames.Healing_OnUpdate = function()
	table.wipe(ni.members)
	table.wipe(ni.memberSetup.cache)
	ni.SetupTables()
end
