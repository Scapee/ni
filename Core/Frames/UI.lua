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

ni.frames.Notification = CreateFrame("Frame", nil, ChatFrame1)
ni.frames.Notification:SetSize(ChatFrame1:GetWidth(), 30)
ni.frames.Notification:Hide()
ni.frames.Notification:SetPoint("TOP", 0, 0)
ni.frames.Notification.text = ni.frames.Notification:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.Notification.text:SetAllPoints()
ni.frames.Notification.texture = ni.frames.Notification:CreateTexture()
ni.frames.Notification.texture:SetAllPoints()
ni.frames.Notification.texture:SetTexture(0, 0, 0, .50)

ni.frames.SpellQueueHolder = CreateFrame("Frame")
ni.frames.SpellQueueHolder:ClearAllPoints()
ni.frames.SpellQueueHolder:SetHeight(30)
ni.frames.SpellQueueHolder:SetWidth(275)
ni.frames.SpellQueueHolder:SetMovable(true)
ni.frames.SpellQueueHolder:EnableMouse(true)
ni.frames.SpellQueueHolder:RegisterForDrag("LeftButton")
ni.frames.SpellQueueHolder:SetScript("OnDragStart", ni.frames.SpellQueueHolder.StartMoving)
ni.frames.SpellQueueHolder:SetScript("OnDragStop", ni.frames.SpellQueueHolder.StopMovingOrSizing)
ni.frames.SpellQueueHolder:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	}
)
ni.frames.SpellQueueHolder:SetBackdropColor(0, 0, 0, 1)
ni.frames.SpellQueueHolder:SetPoint("CENTER", UIParent, "BOTTOM", 0, 130)
ni.frames.SpellQueueHolder:Hide()

ni.frames.SpellQueue = CreateFrame("Frame", nil, ni.frames.SpellQueueHolder)
ni.frames.SpellQueue:ClearAllPoints()
ni.frames.SpellQueue:SetHeight(20)
ni.frames.SpellQueue:SetWidth(200)
ni.frames.SpellQueue:Show()
ni.frames.SpellQueue.text = ni.frames.SpellQueue:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
ni.frames.SpellQueue.text:SetAllPoints()
ni.frames.SpellQueue.text:SetJustifyV("MIDDLE")
ni.frames.SpellQueue.text:SetJustifyH("CENTER")
ni.frames.SpellQueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
ni.frames.SpellQueue:SetPoint("CENTER", ni.frames.SpellQueueHolder, 0, 0)
ni.frames.SpellQueue.Update = function(str, bool)
	local bool = true and bool or false

	if bool then
		if ni.frames.SpellQueueHolder:IsShown() == nil then
			ni.frames.SpellQueueHolder:Show()
		end
		ni.frames.SpellQueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615" .. GetSpellInfo(str))
	else
		ni.frames.SpellQueue.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
		if ni.frames.SpellQueueHolder:IsShown() == 1 then
			ni.frames.SpellQueueHolder:Hide()
		end
	end
end

ni.frames.FloatingText = CreateFrame("Frame")
ni.frames.FloatingText:SetSize(400, 30)
ni.frames.FloatingText:SetAlpha(0)
ni.frames.FloatingText:SetPoint("CENTER", 0, 80)
ni.frames.FloatingText.text = ni.frames.FloatingText:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.FloatingText.text:SetAllPoints()
ni.frames.FloatingText.texture = ni.frames.FloatingText:CreateTexture()
ni.frames.FloatingText.texture:SetAllPoints()
function ni.frames.FloatingText:Message(message)
	self.text:SetText(message)
	UIFrameFadeOut(self, 2.5, 1, 0)
end

ni.showstatus = function(str)
	if ni.vars.profiles.enabled then
		ni.frames.FloatingText:Message("\124cff00ff00" .. str)
	else
		ni.frames.FloatingText:Message("\124cffff0000" .. str)
	end
end

ni.showintstatus = function()
	if ni.vars.profiles.interrupt then
		ni.frames.FloatingText:Message("Interrupts: \124cff00ff00Enabled")
	else
		ni.frames.FloatingText:Message("Interrupts: \124cffff0000Disabled")
	end
end

ni.updatefollow = function(enabled)
	if enabled then
		ni.frames.FloatingText:Message("Auto follow: \124cff00ff00Enabled")
	else
		ni.frames.FloatingText:Message("Auto follow: \124cffff0000Disabled")
	end
end

ni.message = function(message)
	ni.frames.Notification.text:SetText(message)
	ni.frames.Notification:Show()
end

ni.getSpellIdFromActionBar = function()
	local focus = GetMouseFocus():GetName()
	if string.match(focus, "Button") then
		local button = _G[focus]
		local slot =
			ActionButton_GetPagedID(button) or ActionButton_CalculateAction(button) or button:GetAttribute("action") or 0
		if HasAction(slot) then
			local aType, aID, _, aMaxID = GetActionInfo(slot)
			if aType == "spell" then
				return aMaxID ~= nil and aMaxID or aID
			end
		end
	end
end
