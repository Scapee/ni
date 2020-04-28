local files = {
	"Core\\Internal\\Vars.lua",
	"Core\\Internal\\Debug.lua",
	"Core\\Internal\\Rotation.lua",
	"Core\\Internal\\Bootstrap.lua",
	"Core\\Frames\\UI.lua",
	"Core\\Frames\\CombatLog.lua",
	"Core\\Frames\\Delay.lua",
	"Core\\Frames\\Interrupt.lua",
	"Core\\Frames\\Healing.lua",
	"Core\\Frames\\Global.lua",
	"Core\\Engines\\TimeToDie.lua",
	"Core\\Engines\\Healing.lua",
	"Core\\Engines\\Members.lua",
	"Core\\Engines\\ObjectManager.lua",
	"Core\\Frames\\ObjectManager.lua",
	"Core\\Tables\\Dummies.lua",
	"Core\\Tables\\Bosses.lua",
	"Core\\Tables\\MismarkedBosses.lua",
	"Core\\Tables\\BlacklistedAoEUnits.lua",
	"Core\\Tables\\WhitelistedLoSUnits.lua",
	"Core\\Api\\Power.lua",
	"Core\\Api\\Rune.lua",
	"Core\\Api\\Unit.lua",
	"Core\\Api\\Player.lua",
	"Core\\Api\\Spell.lua"
}

if ni.functions.loadlua("Core\\Internal\\Utils.lua") then
	if ni.utils.loadfiles(files) then
		ni.frames.delay:SetScript("OnUpdate", ni.frames.delay_OnUpdate)
		ni.frames.combatlog:SetScript("OnEvent", ni.frames.combatLog_OnEvent)
		ni.frames.interrupt:SetScript("OnUpdate", ni.frames.interrupt_OnUpdate)
		ni.frames.healing:SetScript("OnEvent", ni.frames.healing_OnUpdate)
		ni.frames.objectmanager:SetScript("OnUpdate", ni.frames.objectManager_OnUpdate)
		ni.frames.global:SetScript("OnUpdate", ni.frames.global_OnUpdate)
		ni.frames.floatingtext:message("Loaded")
	end
end
