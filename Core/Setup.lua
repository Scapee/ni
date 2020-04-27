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

if ni.functions.loadLua("Core\\Internal\\Utils.lua") then
	if ni.utils.loadFiles(files) then
		ni.frames.delay:setScript("OnUpdate", ni.frames.delay_OnUpdate)
		ni.frames.combatLog:setScript("OnEvent", ni.frames.combatLog_OnEvent)
		ni.frames.interrupt:setScript("OnUpdate", ni.frames.interrupt_OnUpdate)
		ni.frames.healing:setScript("OnEvent", ni.frames.healing_OnUpdate)
		ni.frames.objectManager:setScript("OnUpdate", ni.frames.objectManager_OnUpdate)
		ni.frames.global:setScript("OnUpdate", ni.frames.global_OnUpdate)
		ni.frames.floatingText:message("Loaded")
	end
end
