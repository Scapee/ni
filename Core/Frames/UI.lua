local CreateFrame,
	UIFrameFadeOut,
	GetMouseFocus,
	ActionButton_GetPagedID,
	ChatFrame1,
	ActionButton_CalculateAction,
	HasAction,
	GetActionInfo =
	CreateFrame,
	UIFrameFadeOut,
	GetMouseFocus,
	ActionButton_GetPagedID,
	ChatFrame1,
	ActionButton_CalculateAction,
	HasAction,
	GetActionInfo

ni.frames.notification = CreateFrame("Frame", nil, ChatFrame1)
ni.frames.notification:setSize(ChatFrame1:getWidth(), 30)
ni.frames.notification:hide()
ni.frames.notification:setPoint("TOP", 0, 0)
ni.frames.notification.text = ni.frames.notification:createFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.notification.text:setAllPoints()
ni.frames.notification.texture = ni.frames.notification:createTexture()
ni.frames.notification.texture:setAllPoints()
ni.frames.notification.texture:setTexture(0, 0, 0, .50)

ni.frames.spellQueueHolder = CreateFrame("Frame")
ni.frames.spellQueueHolder:clearAllPoints()
ni.frames.spellQueueHolder:setHeight(30)
ni.frames.spellQueueHolder:setWidth(275)
ni.frames.spellQueueHolder:setMovable(true)
ni.frames.spellQueueHolder:enableMouse(true)
ni.frames.spellQueueHolder:registerForDrag("LeftButton")
ni.frames.spellQueueHolder:setScript("OnDragStart", ni.frames.spellQueueHolder.startMoving)
ni.frames.spellQueueHolder:setScript("OnDragStop", ni.frames.spellQueueHolder.stopMovingOrSizing)
ni.frames.spellQueueHolder:setBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	}
)
ni.frames.spellQueueHolder:setBackdropColor(0, 0, 0, 1)
ni.frames.spellQueueHolder:setPoint("CENTER", UIParent, "BOTTOM", 0, 130)
ni.frames.spellQueueHolder:hide()

ni.frames.spellQueue = CreateFrame("Frame", nil, ni.frames.spellQueueHolder)
ni.frames.spellQueue:clearAllPoints()
ni.frames.spellQueue:setHeight(20)
ni.frames.spellQueue:setWidth(200)
ni.frames.spellQueue:show()
ni.frames.spellQueue.text = ni.frames.spellQueue:createFontString(nil, "BACKGROUND", "GameFontNormal")
ni.frames.spellQueue.text:setAllPoints()
ni.frames.spellQueue.text:setJustifyV("MIDDLE")
ni.frames.spellQueue.text:setJustifyH("CENTER")
ni.frames.spellQueue.text:setText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
ni.frames.spellQueue:setPoint("CENTER", ni.frames.spellQueueHolder, 0, 0)
ni.frames.spellQueue.update = function(str, bool)
	local bool = true and bool or false

	if bool then
		if ni.frames.spellQueueHolder:isShown() == nil then
			ni.frames.spellQueueHolder:show()
		end
		ni.frames.spellQueue.text:setText("\124cFFFFFFFFQueued Ability: \124cFF15E615" .. GetSpellInfo(str))
	else
		ni.frames.spellQueue.text:setText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
		if ni.frames.spellQueueHolder:isShown() == 1 then
			ni.frames.spellQueueHolder:hide()
		end
	end
end

ni.frames.floatingText = CreateFrame("Frame")
ni.frames.floatingText:setSize(400, 30)
ni.frames.floatingText:setAlpha(0)
ni.frames.floatingText:setPoint("CENTER", 0, 80)
ni.frames.floatingText.text = ni.frames.floatingText:createFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.floatingText.text:setAllPoints()
ni.frames.floatingText.texture = ni.frames.floatingText:createTexture()
ni.frames.floatingText.texture:setAllPoints()
function ni.frames.floatingText:message(message)
	self.text:setText(message)
	UIFrameFadeOut(self, 2.5, 1, 0)
end

ni.showstatus = function(str)
	if ni.vars.profiles.enabled then
		ni.frames.floatingText:message("\124cff00ff00" .. str)
	else
		ni.frames.floatingText:message("\124cffff0000" .. str)
	end
end

ni.showintstatus = function()
	if ni.vars.profiles.interrupt then
		ni.frames.floatingText:message("Interrupts: \124cff00ff00Enabled")
	else
		ni.frames.floatingText:message("Interrupts: \124cffff0000Disabled")
	end
end

ni.updatefollow = function(enabled)
	if enabled then
		ni.frames.floatingText:message("Auto follow: \124cff00ff00Enabled")
	else
		ni.frames.floatingText:message("Auto follow: \124cffff0000Disabled")
	end
end

ni.message = function(message)
	ni.frames.notification.text:setText(message)
	ni.frames.notification:show()
end

ni.getSpellIdFromActionBar = function()
	local focus = GetMouseFocus():getName()
	if string.match(focus, "Button") then
		local button = _G[focus]
		local slot =
			ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:getAttribute("action") or 0
		if HasAction(slot) then
			local aType, aID, _, aMaxID = GetActionInfo(slot)
			if aType == "spell" then
				return aMaxID ~= nil and aMaxID or aID
			end
		end
	end
end
