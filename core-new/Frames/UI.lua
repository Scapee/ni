ni.frames.NotificationFrame = CreateFrame("Frame", nil, ChatFrame1)
ni.frames.NotificationFrame:SetSize(ChatFrame1:GetWidth(), 30)
ni.frames.NotificationFrame:Hide()
ni.frames.NotificationFrame:SetPoint("TOP", 0, 0)
ni.frames.NotificationFrame.text = ni.frames.NotificationFrame:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.NotificationFrame.text:SetAllPoints()
ni.frames.NotificationFrame.texture = ni.notification:CreateTexture()
ni.frames.NotificationFrame.texture:SetAllPoints()
ni.frames.NotificationFrame.texture:SetTexture(0, 0, 0, .50)

ni.frames.InfoFrameHolder = CreateFrame("Frame")
ni.frames.InfoFrameHolder:ClearAllPoints()
ni.frames.InfoFrameHolder:SetHeight(30)
ni.frames.InfoFrameHolder:SetWidth(275)
ni.frames.InfoFrameHolder:SetMovable(true)
ni.frames.InfoFrameHolder:EnableMouse(true)
ni.frames.InfoFrameHolder:RegisterForDrag("LeftButton")
ni.frames.InfoFrameHolder:SetScript("OnDragStart", ni.frames.InfoFrameHolder.StartMoving)
ni.frames.InfoFrameHolder:SetScript("OnDragStop", ni.frames.InfoFrameHolder.StopMovingOrSizing)
ni.frames.InfoFrameHolder:SetBackdrop(
	{
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	}
)
ni.frames.InfoFrameHolder:SetBackdropColor(0, 0, 0, 1)
ni.frames.InfoFrameHolder:SetPoint("CENTER", UIParent, "BOTTOM", 0, 130)
ni.frames.InfoFrameHolder:Hide()

ni.frames.InfoFrame = CreateFrame("Frame", nil, ni.frames.InfoFrameHolder)
ni.frames.InfoFrame:ClearAllPoints()
ni.frames.InfoFrame:SetHeight(20)
ni.frames.InfoFrame:SetWidth(200)
ni.frames.InfoFrame:Show()
ni.frames.InfoFrame.text = ni.frames.InfoFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
ni.frames.InfoFrame.text:SetAllPoints()
ni.frames.InfoFrame.text:SetJustifyV("MIDDLE")
ni.frames.InfoFrame.text:SetJustifyH("CENTER")
ni.frames.InfoFrame.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
ni.frames.InfoFrame:SetPoint("CENTER", ni.frames.InfoFrameHolder, 0, 0)

-- local MessengerFrame = CreateFrame("Frame", nil, UIParent)
-- MessengerFrame:SetSize(ChatFrame1:GetWidth(), 30)
-- MessengerFrame:Hide()
-- MessengerFrame:SetPoint("CENTER", 0, 70)
-- MessengerFrame.text = MessengerFrame:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
-- MessengerFrame.text:SetAllPoints()
-- MessengerFrame.texture = MessengerFrame:CreateTexture()
-- MessengerFrame.texture:SetAllPoints()
-- function MessengerFrame:message(message)
-- 	self.text:SetText(message)
-- 	self:SetAlpha(1)
-- 	self:Show()
-- end

ni.frames.FloatingFrame = CreateFrame("Frame")
ni.frames.FloatingFrame:SetSize(400, 30)
ni.frames.FloatingFrame:SetAlpha(0)
ni.frames.FloatingFrame:SetPoint("CENTER", 0, 80)
ni.frames.FloatingFrame.text = ni.frames.FloatingFrame:CreateFontString(nil, "OVERLAY", "MovieSubtitleFont")
ni.frames.FloatingFrame.text:SetAllPoints()
ni.frames.FloatingFrame.texture = ni.frames.FloatingFrame:CreateTexture()
ni.frames.FloatingFrame.texture:SetAllPoints()

function ni.frames.FloatingFrame:Message(message)
	self.text:SetText(message)
	UIFrameFadeOut(self, 2.5, 1, 0)
end

ni.frames.InfoFrame.update = function(str, bool)
	local bool = true and bool or false

	if bool then
		if ni.frames.InfoFrameHolder:IsShown() == nil then
			ni.frames.InfoFrameHolder:Show()
		end
		ni.frames.InfoFrame.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615" .. GetSpellInfo(str))
	else
		ni.frames.InfoFrame.text:SetText("\124cFFFFFFFFQueued Ability: \124cFF15E615None")
		if ni.frames.InfoFrameHolder:IsShown() == 1 then
			ni.frames.InfoFrameHolder:Hide()
		end
	end
end

ni.showstatus = function(str)
	if ni.vars.profiles.enabled then
		ni.frames.FloatingFrame:Message("\124cff00ff00" .. str)
	else
		ni.frames.FloatingFrame:Message("\124cffff0000" .. str)
	end
end
ni.showintstatus = function()
	if ni.vars.profiles.interrupt then
		ni.frames.FloatingFrame:Message("Interrupts: \124cff00ff00Enabled")
	else
		ni.frames.FloatingFrame:Message("Interrupts: \124cffff0000Disabled")
	end
end
ni.updatefollow = function(enabled)
	if enabled then
		ni.frames.FloatingFrame:Message("Auto follow: \124cff00ff00Enabled")
	else
		ni.frames.FloatingFrame:Message("Auto follow: \124cffff0000Disabled")
	end
end

ni.message = function(message)
	ni.frames.NotificationFrame.text:SetText(message)
	ni.frames.NotificationFrame:Show()
end


ni.getFrameSpellID = function()
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