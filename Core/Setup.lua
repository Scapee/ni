local files = {
	"Core\\Internal\\Vars.lua",
	"Core\\Internal\\Debug.lua",
	"Core\\Internal\\Rotation.lua",
	"Core\\Frames\\UI.lua",
	"Core\\Frames\\CombatLog.lua",
	"Core\\Frames\\Delay.lua",
	"Core\\Frames\\Interrupt.lua",
	"Core\\Frames\\Healing.lua",
	"Core\\Frames\\ObjectManager.lua",
	"Core\\Frames\\Global.lua",
	"Core\\Engines\\TimeToDie.lua",
	"Core\\Engines\\Healing.lua",
	"Core\\Engines\\ObjectManager.lua",
	"Core\\Tables\\Dummies.lua",
	"Core\\Tables\\Bosses.lua",
	"Core\\Tables\\MismarkedBosses.lua",
	"Core\\Tables\\BlacklistedAoEUnits.lua",
	"Core\\Tables\\BlacklistedInterrupts.lua",
	"Core\\Tables\\WhitelistedCCDebuffs.lua",
	"Core\\Tables\\WhitelistedInterrupts.lua",
	"Core\\Api\\Power.lua",
	"Core\\Api\\Rune.lua",
	"Core\\Api\\Unit.lua",
	"Core\\Api\\Player.lua",
	"Core\\Api\\Spell.lua"
}

if ni.functions.LoadLua("Core\\Internal\\Utils.lua") then
	if ni.utils.LoadFiles(files) then
		ni.frames.Delay:SetScript("OnUpdate", ni.frames.Delay_OnUpdate)
		ni.frames.CombatLog:SetScript("OnEvent", ni.frames.CombatLog_OnEvent)
		ni.frames.Interrupt:SetScript("OnUpdate", ni.frames.Interrupt_OnUpdate)
		ni.frames.Healing:SetScript("OnEvent", ni.frames.Healing_OnUpdate)
		ni.frames.ObjectManager:SetScript("OnUpdate", ni.frames.ObjectManager_OnUpdate)
		ni.frames.Global:SetScript("OnUpdate", ni.frames.Global_OnUpdate)
		ni.frames.FloatingText:Message("Loaded")
	end
end
